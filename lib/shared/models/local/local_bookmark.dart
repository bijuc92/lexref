import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_bookmark.freezed.dart';

@freezed
class LocalBookmark with _$LocalBookmark {
  const LocalBookmark._();

  const factory LocalBookmark({
    required String id,
    required String refType,
    required String refId,
    required String refTitle,
    String? refAct,
    @Default('General') String folder,
    required DateTime savedAt,
    @Default(false) bool isSynced,
  }) = _LocalBookmark;

  factory LocalBookmark.fromMap(Map<String, dynamic> m) => LocalBookmark(
        id: m['id'] as String,
        refType: m['ref_type'] as String,
        refId: m['ref_id'] as String,
        refTitle: m['ref_title'] as String,
        refAct: m['ref_act'] as String?,
        folder: m['folder'] as String? ?? 'General',
        savedAt: DateTime.parse(m['saved_at'] as String),
        isSynced: (m['is_synced'] as int? ?? 0) == 1,
      );

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
}
