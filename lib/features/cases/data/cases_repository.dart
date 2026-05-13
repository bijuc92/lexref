import 'package:dio/dio.dart';
import '../../../core/error/result.dart';
import '../../../core/network/api_client.dart';
import '../domain/case_models.dart';

class CasesRepository {
  Future<Result<List<CaseResult>>> searchCases(
    String query, {
    String? court,
    int? year,
  }) async {
    var formInput = query;
    if (court != null) formInput += ' fromdate:${year ?? ''} todate:${year ?? ''}';

    try {
      final response = await ApiClient.indianKanoon.post(
        '/search/',
        data: FormData.fromMap({'formInput': formInput, 'pagenum': 0}),
      );
      final docs = response.data['docs'] as List? ?? [];
      final results = docs
          .map((d) => CaseResult.fromIndianKanoon(d as Map<String, dynamic>))
          .where((c) => c.docId.isNotEmpty)
          .toList();
      return Ok(results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Err(NetworkFailure());
      }
      return Err(UnknownFailure(e.message ?? 'Case search failed.'));
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }

  Future<Result<CaseResult>> getCase(String docId) async {
    try {
      final response = await ApiClient.indianKanoon.post('/doc/$docId/');
      final data = response.data as Map<String, dynamic>;
      return Ok(CaseResult(
        docId: docId,
        title: CaseResult.stripHtml(data['title'] as String? ?? ''),
        citation: data['citation'] as String?,
        court: data['docsource'] as String? ?? 'Unknown Court',
        year: null,
        summary: data['headline'] != null
            ? CaseResult.stripHtml(data['headline'] as String)
            : null,
        url: 'https://indiankanoon.org/doc/$docId/',
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Err(NetworkFailure());
      }
      return const Err(NotFoundFailure('Case document not found.'));
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }
}
