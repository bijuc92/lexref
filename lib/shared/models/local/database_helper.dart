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
    return openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
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
        cross_references TEXT,
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
        folder TEXT NOT NULL DEFAULT 'General',
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await _createFoldersTable(db);

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

    await _createCaseCacheTables(db);

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

  Future<void> _createCaseCacheTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_cases (
        doc_id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        citation TEXT,
        court TEXT NOT NULL,
        year INTEGER,
        summary TEXT,
        url TEXT,
        sections_cited TEXT,
        has_detail INTEGER NOT NULL DEFAULT 0,
        cached_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_case_searches (
        query TEXT PRIMARY KEY,
        doc_ids TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_cached_cases_at ON cached_cases(cached_at)',
    );
  }

  Future<void> _createFoldersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS folders (
        name TEXT PRIMARY KEY,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE sections ADD COLUMN cross_references TEXT',
      );
    }
    if (oldVersion < 3) {
      // Ensure bookmarks and notes have the full schema.
      // Try/catch each column — SQLite throws if it already exists.
      for (final sql in [
        "ALTER TABLE bookmarks ADD COLUMN ref_title TEXT NOT NULL DEFAULT ''",
        "ALTER TABLE bookmarks ADD COLUMN ref_act TEXT",
        "ALTER TABLE bookmarks ADD COLUMN folder TEXT NOT NULL DEFAULT 'General'",
        "ALTER TABLE bookmarks ADD COLUMN saved_at TEXT NOT NULL DEFAULT ''",
        "ALTER TABLE bookmarks ADD COLUMN is_synced INTEGER NOT NULL DEFAULT 0",
        "ALTER TABLE notes ADD COLUMN ref_type TEXT NOT NULL DEFAULT 'section'",
        "ALTER TABLE notes ADD COLUMN ref_id TEXT NOT NULL DEFAULT ''",
        "ALTER TABLE notes ADD COLUMN updated_at TEXT NOT NULL DEFAULT ''",
        "ALTER TABLE notes ADD COLUMN is_synced INTEGER NOT NULL DEFAULT 0",
      ]) {
        try {
          await db.execute(sql);
        } catch (_) {
          // Column already exists — safe to ignore
        }
      }
    }
    if (oldVersion < 4) {
      await _createCaseCacheTables(db);
    }
    if (oldVersion < 5) {
      try {
        await db.execute(
          "ALTER TABLE notes ADD COLUMN folder TEXT NOT NULL DEFAULT 'General'",
        );
      } catch (_) {
        // Column already exists — safe to ignore
      }
      await _createFoldersTable(db);
    }
  }
}
