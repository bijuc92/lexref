import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_models.freezed.dart';

@freezed
class CaseResult with _$CaseResult {
  const CaseResult._();

  const factory CaseResult({
    required String docId,
    required String title,
    String? citation,
    required String court,
    int? year,
    String? summary,
    String? url,
    @Default([]) List<String> sectionsCited,
  }) = _CaseResult;

  factory CaseResult.fromIndianKanoon(Map<String, dynamic> doc) {
    final title = doc['title'] as String? ??
        doc['docsource'] as String? ??
        'Unknown Case';
    final court = doc['docsource'] as String? ?? 'Unknown Court';
    final yearStr = doc['publishdate'] as String?;
    int? year;
    if (yearStr != null && yearStr.length >= 4) {
      year = int.tryParse(yearStr.substring(0, 4));
    }

    return CaseResult(
      docId: doc['tid']?.toString() ?? doc['docid']?.toString() ?? '',
      title: stripHtml(title),
      citation: doc['citation'] as String?,
      court: _normalizeCourtName(court),
      year: year,
      summary: doc['headline'] != null
          ? stripHtml(doc['headline'] as String)
          : null,
      url: doc['docid'] != null
          ? 'https://indiankanoon.org/doc/${doc['docid']}/'
          : null,
    );
  }

  static String stripHtml(String html) =>
      html.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  static String _normalizeCourtName(String raw) {
    if (raw.toLowerCase().contains('supreme')) return 'Supreme Court';
    if (raw.toLowerCase().contains('high')) return 'High Court';
    return raw;
  }
}
