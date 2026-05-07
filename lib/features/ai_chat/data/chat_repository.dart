import '../../../shared/models/local/database_helper.dart';
import '../../../shared/models/local/local_chat_message.dart';

class ChatRepository {
  Future<void> saveMessage(LocalChatMessage message) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('chat_messages', message.toMap());
  }

  Future<List<LocalChatMessage>> getMessages(String sessionId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'chat_messages',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'created_at ASC',
    );
    return rows.map(LocalChatMessage.fromMap).toList();
  }

  Future<void> deleteSession(String sessionId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'chat_messages',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<List<String>> getSessions() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.rawQuery(
      'SELECT DISTINCT session_id, MIN(created_at) as first_at FROM chat_messages GROUP BY session_id ORDER BY first_at DESC',
    );
    return rows.map((r) => r['session_id'] as String).toList();
  }
}
