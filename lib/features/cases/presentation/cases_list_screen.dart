import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/typed_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/case_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../core/error/result.dart';
import '../../subscription/data/usage_repository.dart';
import '../../subscription/domain/subscription_providers.dart';
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
  bool _searching = false;
  int _caseSearchesUsed = 0;

  @override
  void initState() {
    super.initState();
    _loadCaseUsage();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadCaseUsage() async {
    final used = await UsageRepository().getCaseSearchesUsed();
    if (mounted) setState(() => _caseSearchesUsed = used);
  }

  Future<void> _doSearch(String q) async {
    if (q.trim().isEmpty || _searching) return;
    setState(() => _searching = true);

    final isSubscribed = ref.read(isSubscribedProvider);
    if (!isSubscribed) {
      final used = await UsageRepository().getCaseSearchesUsed();
      if (used >= kFreeCaseLimit) {
        if (mounted) {
          setState(() => _searching = false);
          context.pushPaywall(reason: 'cases');
        }
        return;
      }
      await UsageRepository().incrementCaseSearch();
      await _loadCaseUsage();
    }

    if (mounted) {
      setState(() {
        _query = q.trim();
        _searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubscribed = ref.watch(isSubscribedProvider);
    final resultsAsync = ref.watch(_casesProvider(_query));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Law'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(!isSubscribed ? 80 : 56),
          child: Column(
            children: [
              Padding(
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
                        onSubmitted: _doSearch,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: _searching
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _searching ? null : () => _doSearch(_ctrl.text),
                    ),
                  ],
                ),
              ),
              if (!isSubscribed)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Case searches: $_caseSearchesUsed/$kFreeCaseLimit today',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: _caseSearchesUsed >= kFreeCaseLimit
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => context.pushPaywall(reason: 'cases'),
                        child: Text(
                          'Upgrade',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
