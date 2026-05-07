import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../domain/case_models.dart';

class CasesRepository {
  Future<List<CaseResult>> searchCases(
    String query, {
    String? court,
    int? year,
  }) async {
    var formInput = query;
    if (court != null) formInput += ' fromdate:${year ?? ''} todate:${year ?? ''}';

    final response = await ApiClient.indianKanoon.get(
      '/search/',
      queryParameters: {
        'formInput': formInput,
        'pagenum': 0,
      },
    );
    final docs = response.data['docs'] as List? ?? [];
    return docs
        .map((d) => CaseResult.fromIndianKanoon(d as Map<String, dynamic>))
        .where((c) => c.docId.isNotEmpty)
        .toList();
  }

  Future<CaseResult?> getCase(String docId) async {
    try {
      final response = await ApiClient.indianKanoon.post('/doc/$docId/');
      final data = response.data as Map<String, dynamic>;
      return CaseResult(
        docId: docId,
        title: CaseResult.stripHtml(data['title'] as String? ?? ''),
        citation: data['citation'] as String?,
        court: data['docsource'] as String? ?? 'Unknown Court',
        year: null,
        summary: data['headline'] != null
            ? CaseResult.stripHtml(data['headline'] as String)
            : null,
        url: 'https://indiankanoon.org/doc/$docId/',
      );
    } on DioException {
      return null;
    }
  }
}
