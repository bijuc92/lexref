class CaseResult {
  final String docId;
  final String title;
  final String? citation;
  final String court;
  final int? year;
  final String? summary;
  final String? url;
  final List<String> sectionsCited;

  const CaseResult({
    required this.docId,
    required this.title,
    this.citation,
    required this.court,
    this.year,
    this.summary,
    this.url,
    this.sectionsCited = const [],
  });

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
      sectionsCited: [],
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
