class LocalBookmark {
  final String id;
  final String refType;
  final String refId;
  final String refTitle;
  final String? refAct;
  final String folder;
  final DateTime savedAt;
  final bool isSynced;

  const LocalBookmark({
    required this.id,
    required this.refType,
    required this.refId,
    required this.refTitle,
    this.refAct,
    this.folder = 'General',
    required this.savedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'ref_type': refType,
        'ref_id': refId,
        'ref_title': refTitle,
        'ref_act': refAct,
        'folder': folder,
        'saved_at': savedAt.toIso8601String(),
        'is_synced': isSynced ? 1 : 0,
      };

  factory LocalBookmark.fromMap(Map<String, dynamic> m) => LocalBookmark(
        id: m['id'] as String,
        refType: m['ref_type'] as String,
        refId: m['ref_id'] as String,
        refTitle: m['ref_title'] as String,
        refAct: m['ref_act'] as String?,
        folder: m['folder'] as String? ?? 'General',
        savedAt: DateTime.parse(m['saved_at'] as String),
        isSynced: (m['is_synced'] as int) == 1,
      );

  LocalBookmark copyWith({
    String? id,
    String? refType,
    String? refId,
    String? refTitle,
    String? refAct,
    String? folder,
    DateTime? savedAt,
    bool? isSynced,
  }) =>
      LocalBookmark(
        id: id ?? this.id,
        refType: refType ?? this.refType,
        refId: refId ?? this.refId,
        refTitle: refTitle ?? this.refTitle,
        refAct: refAct ?? this.refAct,
        folder: folder ?? this.folder,
        savedAt: savedAt ?? this.savedAt,
        isSynced: isSynced ?? this.isSynced,
      );
}
