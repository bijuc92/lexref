import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_chat_message.freezed.dart';

@freezed
class LocalChatMessage with _$LocalChatMessage {
  const LocalChatMessage._();

  const factory LocalChatMessage({
    required String id,
    required String sessionId,
    required String role,
    required String content,
    required DateTime createdAt,
  }) = _LocalChatMessage;

  factory LocalChatMessage.fromMap(Map<String, dynamic> m) => LocalChatMessage(
        id: m['id'] as String,
        sessionId: m['session_id'] as String,
        role: m['role'] as String,
        content: m['content'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'session_id': sessionId,
        'role': role,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };
}
