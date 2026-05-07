import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_section.freezed.dart';

@freezed
class LocalSection with _$LocalSection {
  const LocalSection._();

  const factory LocalSection({
    required String id,
    required String actId,
    required String actShortName,
    required String sectionNo,
    required String title,
    required String content,
    String? explanation,
    @Default([]) List<String> relatedSections,
    required String searchKey,
  }) = _LocalSection;

  factory LocalSection.fromMap(Map<String, dynamic> m) => LocalSection(
        id: m['id'] as String,
        actId: m['act_id'] as String,
        actShortName: m['act_short_name'] as String,
        sectionNo: m['section_no'] as String,
        title: m['title'] as String,
        content: m['content'] as String,
        explanation: m['explanation'] as String?,
        relatedSections: m['related_sections'] != null
            ? List<String>.from(
                jsonDecode(m['related_sections'] as String) as List)
            : [],
        searchKey: m['search_key'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'act_id': actId,
        'act_short_name': actShortName,
        'section_no': sectionNo,
        'title': title,
        'content': content,
        'explanation': explanation,
        'related_sections': jsonEncode(relatedSections),
        'search_key': searchKey,
      };
}
