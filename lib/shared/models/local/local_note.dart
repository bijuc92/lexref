import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_note.freezed.dart';

@freezed
class LocalNote with _$LocalNote {
  const LocalNote._();

  const factory LocalNote({
    required String id,
    required String refType,
    required String refId,
    required String content,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _LocalNote;

  factory LocalNote.fromMap(Map<String, dynamic> m) => LocalNote(
        id: m['id'] as String,
        refType: m['ref_type'] as String,
        refId: m['ref_id'] as String,
        content: m['content'] as String,
        updatedAt: DateTime.parse(m['updated_at'] as String),
        isSynced: (m['is_synced'] as int) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'ref_type': refType,
        'ref_id': refId,
        'content': content,
        'updated_at': updatedAt.toIso8601String(),
        'is_synced': isSynced ? 1 : 0,
      };
}
