import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/case_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../core/error/result.dart';
import '../data/cases_repository.dart';
import '../domain/case_models.dart';

final _casesProvider =
    FutureProvider.family<List<CaseResult>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final result = await CasesRepository().searchCases(query);
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw failure.message,
  };
});

class CasesListScreen extends ConsumerStatefulWidget {
  const CasesListScreen({super.key});

  @override
  ConsumerState<CasesListScreen> createState() => _CasesListScreenState();
}

class _CasesListScreenState extends ConsumerState<CasesListScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(_casesProvider(_query));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Law'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Search cases...',
                      prefixIcon: Icon(Icons.search, size: 20),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() => _query = _ctrl.text),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: _query.isEmpty
                ? const EmptyState(
                    icon: Icons.balance,
                    title: 'Search Case Law',
                    subtitle:
                        'Search Supreme Court and High Court judgments via IndianKanoon',
                  )
                : resultsAsync.when(
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: CardShimmer(),
                      ),
                    ),
                    error: (e, _) => ErrorState(
                      message: e.toString(),
                      onRetry: () =>
                          ref.invalidate(_casesProvider(_query)),
                    ),
                    data: (cases) {
                      if (cases.isEmpty) {
                        return EmptyState(
                          icon: Icons.search_off,
                          title: 'No cases found',
                          subtitle: 'No judgments found for "$_query"',
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async =>
                            ref.invalidate(_casesProvider(_query)),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cases.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CaseCard(
                              caseResult: cases[i],
                              onTap: () =>
                                  context.pushCaseDetail(cases[i].docId),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
