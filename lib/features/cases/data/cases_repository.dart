import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/error/result.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/local/database_helper.dart';
import '../../../shared/models/local/local_cached_case.dart';
import '../domain/case_models.dart';

class CasesRepository {
  /// Keep the on-device case cache bounded — judgments are text-heavy.
  static const _maxCachedCases = 300;

  Future<Result<List<CaseResult>>> searchCases(
    String query, {
    String? court,
    int? year,
  }) async {
    var formInput = query;
    if (court != null) formInput += ' fromdate:${year ?? ''} todate:${year ?? ''}';

    try {
      final response = await ApiClient.indianKanoon.post(
        '/search/',
        data: FormData.fromMap({'formInput': formInput, 'pagenum': 0}),
      );
      final docs = response.data['docs'] as List? ?? [];
      final results = docs
          .map((d) => CaseResult.fromIndianKanoon(d as Map<String, dynamic>))
          .where((c) => c.docId.isNotEmpty)
          .toList();
      await _cacheSearchResults(query, results);
      return Ok(results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        final cached = await _cachedSearch(query);
        if (cached != null && cached.isNotEmpty) return Ok(cached);
        return const Err(NetworkFailure());
      }
      return Err(UnknownFailure(e.message ?? 'Case search failed.'));
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }

  Future<Result<CaseResult>> getCase(String docId) async {
    try {
      final response = await ApiClient.indianKanoon.post('/doc/$docId/');
      final data = response.data as Map<String, dynamic>;
      final result = CaseResult(
        docId: docId,
        title: CaseResult.stripHtml(data['title'] as String? ?? ''),
        citation: data['citation'] as String?,
        court: data['docsource'] as String? ?? 'Unknown Court',
        year: null,
        summary: data['headline'] != null
            ? CaseResult.stripHtml(data['headline'] as String)
            : null,
        url: 'https://indiankanoon.org/doc/$docId/',
      );
      await _cacheCases([result], hasDetail: true);
      return Ok(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        final cached = await _cachedCase(docId);
        if (cached != null) return Ok(cached);
        return const Err(NetworkFailure());
      }
      return const Err(NotFoundFailure('Case document not found.'));
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }

  // --- Offline cache ---------------------------------------------------------

  String _normalizeQuery(String q) => q.trim().toLowerCase();

  CaseResult _toCaseResult(LocalCachedCase c) => CaseResult(
        docId: c.docId,
        title: c.title,
        citation: c.citation,
        court: c.court,
        year: c.year,
        summary: c.summary,
        url: c.url,
        sectionsCited: c.sectionsCited,
      );

  LocalCachedCase _toCached(CaseResult c, bool hasDetail) => LocalCachedCase(
        docId: c.docId,
        title: c.title,
        citation: c.citation,
        court: c.court,
        year: c.year,
        summary: c.summary,
        url: c.url,
        sectionsCited: c.sectionsCited,
        hasDetail: hasDetail,
        cachedAt: DateTime.now(),
      );

  Future<void> _cacheCases(
    List<CaseResult> cases, {
    required bool hasDetail,
  }) async {
    if (cases.isEmpty) return;
    final db = await DatabaseHelper.instance.database;
    final batch = db.batch();
    for (final c in cases) {
      batch.insert(
        'cached_cases',
        _toCached(c, hasDetail).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    await _pruneCache(db);
  }

  Future<void> _cacheSearchResults(
    String query,
    List<CaseResult> results,
  ) async {
    if (results.isEmpty) return;
    await _cacheCases(results, hasDetail: false);
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'cached_case_searches',
      {
        'query': _normalizeQuery(query),
        'doc_ids': jsonEncode(results.map((c) => c.docId).toList()),
        'cached_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CaseResult>?> _cachedSearch(String query) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'cached_case_searches',
      where: 'query = ?',
      whereArgs: [_normalizeQuery(query)],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final docIds = (jsonDecode(rows.first['doc_ids'] as String) as List)
        .map((e) => e as String)
        .toList();
    if (docIds.isEmpty) return null;

    final placeholders = List.filled(docIds.length, '?').join(',');
    final caseRows = await db.query(
      'cached_cases',
      where: 'doc_id IN ($placeholders)',
      whereArgs: docIds,
    );
    final byId = {
      for (final r in caseRows)
        (r['doc_id'] as String): _toCaseResult(LocalCachedCase.fromMap(r)),
    };
    // Preserve original result ordering.
    return [
      for (final id in docIds)
        if (byId[id] != null) byId[id]!,
    ];
  }

  Future<CaseResult?> _cachedCase(String docId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'cached_cases',
      where: 'doc_id = ?',
      whereArgs: [docId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _toCaseResult(LocalCachedCase.fromMap(rows.first));
  }

  Future<void> _pruneCache(Database db) async {
    await db.rawDelete(
      '''
      DELETE FROM cached_cases WHERE doc_id NOT IN (
        SELECT doc_id FROM cached_cases ORDER BY cached_at DESC LIMIT ?
      )
      ''',
      [_maxCachedCases],
    );
  }
}
