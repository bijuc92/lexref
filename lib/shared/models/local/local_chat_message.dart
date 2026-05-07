class LocalChatMessage {
  final String id;
  final String sessionId;
  final String role;
  final String content;
  final DateTime createdAt;

  const LocalChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'session_id': sessionId,
        'role': role,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };

  factory LocalChatMessage.fromMap(Map<String, dynamic> m) => LocalChatMessage(
        id: m['id'] as String,
        sessionId: m['session_id'] as String,
        role: m['role'] as String,
        content: m['content'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
      );
}
