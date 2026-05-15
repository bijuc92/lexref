import 'package:sqflite/sqflite.dart';
import '../models/local/database_helper.dart';

/// Shared folder namespace for both notes and bookmarks. 'General' is the
/// implicit default — it is never stored in the table and cannot be renamed
/// or deleted.
class FoldersRepository {
  static const defaultFolder = 'General';

  /// Returns 'General' first, then any user-created folders alphabetically.
  Future<List<String>> getFolders() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('folders', columns: ['name'], orderBy: 'name');
    final custom = rows
        .map((r) => r['name'] as String)
        .where((n) => n != defaultFolder)
        .toList();
    return [defaultFolder, ...custom];
  }

  Future<void> createFolder(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == defaultFolder) return;
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'folders',
      {'name': trimmed, 'created_at': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Renames a folder and reassigns all notes and bookmarks that referenced it.
  Future<void> renameFolder(String oldName, String newName) async {
    final trimmed = newName.trim();
    if (oldName == defaultFolder ||
        trimmed.isEmpty ||
        trimmed == defaultFolder ||
        trimmed == oldName) {
      return;
    }
    final db = await DatabaseHelper.instance.database;
    await db.transaction((txn) async {
      await txn.insert(
        'folders',
        {'name': trimmed, 'created_at': DateTime.now().toIso8601String()},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      await txn.delete('folders', where: 'name = ?', whereArgs: [oldName]);
      for (final table in ['notes', 'bookmarks']) {
        await txn.update(
          table,
          {'folder': trimmed, 'is_synced': 0},
          where: 'folder = ?',
          whereArgs: [oldName],
        );
      }
    });
  }

  /// Deletes a folder; its notes and bookmarks fall back to 'General'.
  Future<void> deleteFolder(String name) async {
    if (name == defaultFolder) return;
    final db = await DatabaseHelper.instance.database;
    await db.transaction((txn) async {
      await txn.delete('folders', where: 'name = ?', whereArgs: [name]);
      for (final table in ['notes', 'bookmarks']) {
        await txn.update(
          table,
          {'folder': defaultFolder, 'is_synced': 0},
          where: 'folder = ?',
          whereArgs: [name],
        );
      }
    });
  }
}
