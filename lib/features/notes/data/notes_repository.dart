import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/result.dart';
import '../../../shared/models/local/database_helper.dart';
import '../../../shared/models/local/local_note.dart';

class NotesRepository {
  Future<Result<void>> saveNote(LocalNote note) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        'notes',
        note.copyWith(isSynced: false).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to save note: ${e.toString()}'));
    }
  }

  Future<LocalNote?> getNote(String id) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return LocalNote.fromMap(rows.first);
  }

  Future<LocalNote?> getNoteForRef(String refId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'notes',
      where: 'ref_id = ?',
      whereArgs: [refId],
    );
    if (rows.isEmpty) return null;
    return LocalNote.fromMap(rows.first);
  }

  Future<List<LocalNote>> getAllNotes() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    debugPrint('getAllNotes: ${rows.length} raw rows found');
    for (final row in rows) {
      debugPrint('  row → $row');
    }
    final notes = rows
        .map((row) {
          try {
            return LocalNote.fromMap(row);
          } catch (e) {
            debugPrint('  fromMap FAILED for row $row: $e');
            return null;
          }
        })
        .whereType<LocalNote>()
        .toList();
    debugPrint('getAllNotes: ${notes.length} notes parsed successfully');
    return notes;
  }

  Future<Map<String, List<LocalNote>>> getNotesByFolder() async {
    final all = await getAllNotes();
    final Map<String, List<LocalNote>> grouped = {};
    for (final note in all) {
      grouped.putIfAbsent(note.folder, () => []).add(note);
    }
    return grouped;
  }

  Future<void> updateNoteFolder(String id, String folder) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'notes',
      {'folder': folder, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateNote(String id, String content) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'notes',
      {
        'content': content,
        'updated_at': DateTime.now().toIso8601String(),
        'is_synced': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Result<void>> deleteNote(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('notes', where: 'id = ?', whereArgs: [id]);
      // Best-effort remote delete — ignored if offline or unauthenticated
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId != null) {
        client
            .from('notes')
            .delete()
            .eq('id', id)
            .eq('user_id', userId)
            .then((_) {}, onError: (_) {});
      }
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete note: ${e.toString()}'));
    }
  }

  Future<List<LocalNote>> getUnsynced() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'notes',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return rows.map(LocalNote.fromMap).toList();
  }

  Future<Result<void>> syncToSupabase() async {
    try {
      final unsynced = await getUnsynced();
      if (unsynced.isEmpty) return const Ok(null);
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return const Ok(null);

      final db = await DatabaseHelper.instance.database;
      for (final note in unsynced) {
        await client.from('notes').upsert({
          'id': note.id,
          'user_id': userId,
          'ref_type': note.refType,
          'ref_id': note.refId,
          'content': note.content,
          'updated_at': note.updatedAt.toIso8601String(),
        });
        await db.update(
          'notes',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [note.id],
        );
      }
      return const Ok(null);
    } catch (e) {
      return Err(NetworkFailure('Note sync failed: ${e.toString()}'));
    }
  }
}
