import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/court_badge.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../core/error/result.dart';
import '../data/cases_repository.dart';
import '../domain/case_models.dart';

final _caseDetailProvider =
    FutureProvider.family<CaseResult, String>((ref, docId) async {
  final result = await CasesRepository().getCase(docId);
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw failure.message,
  };
});

class CaseDetailScreen extends ConsumerWidget {
  final String caseId;
  const CaseDetailScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseAsync = ref.watch(_caseDetailProvider(caseId));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser_outlined),
            tooltip: 'Open full judgment',
            onPressed: () async {
              final url = 'https://indiankanoon.org/doc/$caseId/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
      body: caseAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoadingShimmer(height: 20, width: 80),
              SizedBox(height: 12),
              LoadingShimmer(height: 24),
              SizedBox(height: 8),
              LoadingShimmer(height: 150),
            ],
          ),
        ),
        error: (e, _) =>
            ErrorState(message: e.toString(), onRetry: () {}),
        data: (c) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourtBadge(c.court),
                const SizedBox(height: 12),
                Text(
                  c.title,
                  style: GoogleFonts.libreBaskerville(fontSize: 22),
                ),
                if (c.citation != null && c.citation!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    c.citation!,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                if (c.summary != null) ...[
                  Text(
                    'Summary',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.summary!,
                    style: GoogleFonts.dmSans(fontSize: 14, height: 1.7),
                  ),
                  const SizedBox(height: 24),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open Full Judgment on IndianKanoon'),
                    onPressed: () async {
                      final url = c.url ?? 'https://indiankanoon.org/doc/$caseId/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.smart_toy_outlined),
                    label: const Text('Ask AI about this case'),
                    onPressed: () => context.goAiChat(
                      initialMessage: 'Summarize and explain the case: ${c.title}',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
