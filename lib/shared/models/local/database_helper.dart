import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'lexref.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sections (
        id TEXT PRIMARY KEY,
        act_id TEXT NOT NULL,
        act_short_name TEXT NOT NULL,
        section_no TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        explanation TEXT,
        related_sections TEXT,
        search_key TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE acts (
        id TEXT PRIMARY KEY,
        short_name TEXT NOT NULL,
        full_name TEXT NOT NULL,
        year INTEGER NOT NULL,
        jurisdiction TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id TEXT PRIMARY KEY,
        ref_type TEXT NOT NULL,
        ref_id TEXT NOT NULL,
        ref_title TEXT NOT NULL,
        ref_act TEXT,
        folder TEXT NOT NULL DEFAULT 'General',
        saved_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        ref_type TEXT NOT NULL,
        ref_id TEXT NOT NULL,
        content TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        role TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE search_history (
        id TEXT PRIMARY KEY,
        query TEXT NOT NULL,
        filter_type TEXT,
        searched_at TEXT NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_sections_act ON sections(act_id)',
    );
    await db.execute(
      'CREATE INDEX idx_sections_search ON sections(search_key)',
    );
    await db.execute(
      'CREATE INDEX idx_chat_session ON chat_messages(session_id)',
    );
    await db.execute(
      'CREATE INDEX idx_bookmarks_user ON bookmarks(is_synced)',
    );
    await db.execute(
      'CREATE INDEX idx_notes_synced ON notes(is_synced)',
    );
  }
}
