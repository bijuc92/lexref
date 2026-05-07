import 'dart:async';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/local/database_helper.dart';
import '../../../shared/models/local/local_section.dart';
import '../../cases/domain/case_models.dart';

class SearchRepository {
  Future<List<LocalSection>> searchLocal(String query, String? actFilter) async {
    if (query.trim().isEmpty) return [];
    final db = await DatabaseHelper.instance.database;

    String where = '(title LIKE ? OR content LIKE ? OR section_no LIKE ?)';
    final args = ['%$query%', '%$query%', '%$query%'];

    if (actFilter != null && actFilter != 'all') {
      where += ' AND act_id = ?';
      args.add(actFilter);
    }

    final rows = await db.query(
      'sections',
      where: where,
      whereArgs: args,
      limit: 30,
    );
    return rows.map(LocalSection.fromMap).toList();
  }

  Future<List<CaseResult>> searchCases(String query) async {
    try {
      final response = await ApiClient.indianKanoon.get(
        '/search/',
        queryParameters: {'formInput': query, 'pagenum': 0},
      );
      final docs = response.data['docs'] as List? ?? [];
      return docs
          .map((d) => CaseResult.fromIndianKanoon(d as Map<String, dynamic>))
          .where((c) => c.docId.isNotEmpty)
          .toList();
    } on DioException {
      return [];
    }
  }

  Future<void> saveSearchHistory(String query, String? filterType) async {
    if (query.trim().isEmpty) return;
    final db = await DatabaseHelper.instance.database;
    await db.insert('search_history', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'query': query,
      'filter_type': filterType,
      'searched_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<String>> getRecentSearches() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'search_history',
      columns: ['query'],
      orderBy: 'searched_at DESC',
      limit: 10,
    );
    return rows.map((r) => r['query'] as String).toList();
  }

  Future<void> clearHistory() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('search_history');
  }
}
