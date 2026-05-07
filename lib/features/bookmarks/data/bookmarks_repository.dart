import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/result.dart';
import '../../../shared/models/local/database_helper.dart';
import '../../../shared/models/local/local_bookmark.dart';

class BookmarksRepository {
  Future<void> addBookmark(LocalBookmark bookmark) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'bookmarks',
      bookmark.copyWith(isSynced: false).toMap(),
    );
  }

  Future<void> removeBookmark(String refId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('bookmarks', where: 'ref_id = ?', whereArgs: [refId]);
  }

  Future<LocalBookmark?> getBookmark(String refId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'bookmarks',
      where: 'ref_id = ?',
      whereArgs: [refId],
    );
    if (rows.isEmpty) return null;
    return LocalBookmark.fromMap(rows.first);
  }

  Future<List<LocalBookmark>> getAllBookmarks() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('bookmarks', orderBy: 'saved_at DESC');
    return rows.map(LocalBookmark.fromMap).toList();
  }

  Future<Map<String, List<LocalBookmark>>> getBookmarksByFolder() async {
    final all = await getAllBookmarks();
    final Map<String, List<LocalBookmark>> grouped = {};
    for (final bm in all) {
      grouped.putIfAbsent(bm.folder, () => []).add(bm);
    }
    return grouped;
  }

  Future<void> updateFolder(String bookmarkId, String folder) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'bookmarks',
      {'folder': folder, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [bookmarkId],
    );
  }

  Future<List<LocalBookmark>> getUnsynced() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'bookmarks',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return rows.map(LocalBookmark.fromMap).toList();
  }

  Future<void> markSynced(String id) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'bookmarks',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Result<void>> syncToSupabase() async {
    try {
      final unsynced = await getUnsynced();
      if (unsynced.isEmpty) return const Ok(null);
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return const Ok(null);

      for (final bm in unsynced) {
        await client.from('bookmarks').upsert({
          'id': bm.id,
          'user_id': userId,
          'ref_type': bm.refType,
          'ref_id': bm.refId,
          'ref_title': bm.refTitle,
          'ref_act': bm.refAct,
          'folder': bm.folder,
          'created_at': bm.savedAt.toIso8601String(),
        });
        await markSynced(bm.id);
      }
      return const Ok(null);
    } catch (e) {
      return Err(NetworkFailure('Bookmark sync failed: ${e.toString()}'));
    }
  }
}
