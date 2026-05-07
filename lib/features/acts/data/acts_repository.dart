import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../../../shared/models/local/database_helper.dart';
import '../../../shared/models/local/local_section.dart';
import '../domain/act_models.dart';

class ActsRepository {
  Future<Database> get _db => DatabaseHelper.instance.database;

  static const _assetPaths = {
    'ipc': 'assets/data/ipc.json',
    'crpc': 'assets/data/crpc.json',
    'cpc': 'assets/data/cpc.json',
    'evidence': 'assets/data/evidence_act.json',
  };

  Future<ActModel> loadActFromAsset(String actId) async {
    final path = _assetPaths[actId]!;
    final json = await rootBundle.loadString(path);
    return ActModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> seedIfNeeded(String actId) async {
    final db = await _db;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM sections WHERE act_id = ?',
        [actId],
      ),
    );
    if ((count ?? 0) > 0) return;

    final act = await loadActFromAsset(actId);
    final batch = db.batch();

    batch.insert(
      'acts',
      {
        'id': act.id,
        'short_name': act.shortName,
        'full_name': act.fullName,
        'year': act.year,
        'jurisdiction': act.jurisdiction,
        'category': act.category,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    for (final chapter in act.chapters) {
      for (final section in chapter.sections) {
        batch.insert(
          'sections',
          LocalSection(
            id: section.id,
            actId: act.id,
            actShortName: act.shortName,
            sectionNo: section.sectionNo,
            title: section.title,
            content: section.content,
            relatedSections: section.relatedSections,
            searchKey: '${act.id}_${section.sectionNo}',
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }

    await batch.commit(noResult: true);
  }

  Future<List<LocalSection>> getSectionsByAct(String actId) async {
    final db = await _db;
    final rows = await db.query(
      'sections',
      where: 'act_id = ?',
      whereArgs: [actId],
    );
    return rows.map(LocalSection.fromMap).toList();
  }

  Future<LocalSection?> getSection(String sectionId) async {
    final db = await _db;
    final rows = await db.query(
      'sections',
      where: 'id = ?',
      whereArgs: [sectionId],
    );
    if (rows.isEmpty) return null;
    return LocalSection.fromMap(rows.first);
  }

  Future<List<LocalSection>> searchInAct(String actId, String query) async {
    final db = await _db;
    final rows = await db.query(
      'sections',
      where: 'act_id = ? AND (title LIKE ? OR content LIKE ? OR section_no LIKE ?)',
      whereArgs: [actId, '%$query%', '%$query%', '%$query%'],
    );
    return rows.map(LocalSection.fromMap).toList();
  }
}
