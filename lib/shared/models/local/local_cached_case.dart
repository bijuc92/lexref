import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_cached_case.freezed.dart';

@freezed
class LocalCachedCase with _$LocalCachedCase {
  const LocalCachedCase._();

  const factory LocalCachedCase({
    required String docId,
    required String title,
    String? citation,
    required String court,
    int? year,
    String? summary,
    String? url,
    @Default([]) List<String> sectionsCited,
    @Default(false) bool hasDetail,
    required DateTime cachedAt,
  }) = _LocalCachedCase;

  factory LocalCachedCase.fromMap(Map<String, dynamic> m) => LocalCachedCase(
        docId: m['doc_id'] as String,
        title: m['title'] as String,
        citation: m['citation'] as String?,
        court: m['court'] as String,
        year: m['year'] as int?,
        summary: m['summary'] as String?,
        url: m['url'] as String?,
        sectionsCited: (m['sections_cited'] as String?)?.isNotEmpty == true
            ? (jsonDecode(m['sections_cited'] as String) as List)
                .map((e) => e as String)
                .toList()
            : const [],
        hasDetail: (m['has_detail'] as int? ?? 0) == 1,
        cachedAt: DateTime.parse(m['cached_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'doc_id': docId,
        'title': title,
        'citation': citation,
        'court': court,
        'year': year,
        'summary': summary,
        'url': url,
        'sections_cited': jsonEncode(sectionsCited),
        'has_detail': hasDetail ? 1 : 0,
        'cached_at': cachedAt.toIso8601String(),
      };
}
