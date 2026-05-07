import 'dart:convert';

class LocalSection {
  final String id;
  final String actId;
  final String actShortName;
  final String sectionNo;
  final String title;
  final String content;
  final String? explanation;
  final List<String> relatedSections;
  final String searchKey;

  const LocalSection({
    required this.id,
    required this.actId,
    required this.actShortName,
    required this.sectionNo,
    required this.title,
    required this.content,
    this.explanation,
    this.relatedSections = const [],
    required this.searchKey,
  });

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

  factory LocalSection.fromMap(Map<String, dynamic> m) => LocalSection(
        id: m['id'] as String,
        actId: m['act_id'] as String,
        actShortName: m['act_short_name'] as String,
        sectionNo: m['section_no'] as String,
        title: m['title'] as String,
        content: m['content'] as String,
        explanation: m['explanation'] as String?,
        relatedSections: m['related_sections'] != null
            ? List<String>.from(jsonDecode(m['related_sections'] as String))
            : [],
        searchKey: m['search_key'] as String,
      );
}
