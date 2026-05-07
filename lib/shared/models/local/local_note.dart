class LocalNote {
  final String id;
  final String refType;
  final String refId;
  final String content;
  final DateTime updatedAt;
  final bool isSynced;

  const LocalNote({
    required this.id,
    required this.refType,
    required this.refId,
    required this.content,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'ref_type': refType,
        'ref_id': refId,
        'content': content,
        'updated_at': updatedAt.toIso8601String(),
        'is_synced': isSynced ? 1 : 0,
      };

  factory LocalNote.fromMap(Map<String, dynamic> m) => LocalNote(
        id: m['id'] as String,
        refType: m['ref_type'] as String,
        refId: m['ref_id'] as String,
        content: m['content'] as String,
        updatedAt: DateTime.parse(m['updated_at'] as String),
        isSynced: (m['is_synced'] as int) == 1,
      );

  LocalNote copyWith({
    String? id,
    String? refType,
    String? refId,
    String? content,
    DateTime? updatedAt,
    bool? isSynced,
  }) =>
      LocalNote(
        id: id ?? this.id,
        refType: refType ?? this.refType,
        refId: refId ?? this.refId,
        content: content ?? this.content,
        updatedAt: updatedAt ?? this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
      );
}
