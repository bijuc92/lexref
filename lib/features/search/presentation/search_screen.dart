import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/local/local_section.dart';
import '../../../shared/widgets/case_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../../cases/domain/case_models.dart';
import '../data/search_repository.dart';

final _searchRepo = SearchRepository();

const _filters = [
  ('all', 'All'),
  ('bns', 'BNS'),
  ('bnss', 'BNSS'),
  ('ipc', 'IPC'),
  ('crpc', 'CrPC'),
  ('cpc', 'CPC'),
  ('evidence', 'Evidence'),
];

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;

  String _query = '';
  String _filter = 'all';
  bool _loading = false;
  List<LocalSection> _sections = [];
  List<CaseResult> _cases = [];
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ctrl.text = widget.initialQuery!;
        _onChanged(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final h = await _searchRepo.getRecentSearches();
    if (mounted) setState(() => _history = h);
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _query = v);
      if (v.isNotEmpty) _doSearch(v);
    });
  }

  Future<void> _doSearch(String q) async {
    setState(() => _loading = true);
    await _searchRepo.saveSearchHistory(q, _filter);
    final sections = await _searchRepo.searchLocal(
      q,
      _filter == 'all' ? null : _filter,
    );
    List<CaseResult> cases = [];
    if (_filter == 'all' || _filter == 'sc' || _filter == 'hc') {
      cases = await _searchRepo.searchCases(q);
    }
    if (mounted) {
      setState(() {
        _sections = sections;
        _cases = cases;
        _loading = false;
      });
    }
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          focusNode: _focus,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Search sections, cases...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            hintStyle: GoogleFonts.dmSans(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() {
                        _query = '';
                        _sections = [];
                        _cases = [];
                      });
                    },
                  )
                : null,
          ),
          onChanged: _onChanged,
          onSubmitted: (v) {
            if (v.isNotEmpty) _doSearch(v);
          },
        ),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _filters.map((f) {
                final selected = _filter == f.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f.$2),
                    selected: selected,
                    onSelected: (v) {
                      setState(() => _filter = v ? f.$1 : 'all');
                      if (_query.isNotEmpty) _doSearch(_query);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? _buildHistory()
                : _loading
                    ? _buildShimmer()
                    : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    if (_history.isEmpty) {
      return const EmptyState(
        icon: Icons.search,
        title: 'Search LexRef',
        subtitle: 'Search across IPC, BNS, CrPC, BNSS, CPC, Evidence Act and case law',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () async {
                await _searchRepo.clearHistory();
                _loadHistory();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
        ..._history.map((h) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, size: 18),
              title: Text(
                h,
                style: GoogleFonts.dmSans(fontSize: 14),
              ),
              onTap: () {
                _ctrl.text = h;
                setState(() => _query = h);
                _doSearch(h);
              },
            )),
      ],
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: CardShimmer(),
      ),
    );
  }

  Widget _buildResults() {
    if (_sections.isEmpty && _cases.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No results',
        subtitle: 'No results found for "$_query"',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_sections.isNotEmpty) ...[
          Text(
            'Law Sections (${_sections.length})',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._sections.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SectionCard(
                  section: s,
                  onTap: () =>
                      context.pushSectionDetail(actId: s.actId, sectionId: s.id),
                ),
              )),
        ],
        if (_cases.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Case Law (${_cases.length})',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._cases.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CaseCard(
                  caseResult: c,
                  onTap: () => context.pushCaseDetail(c.docId),
                ),
              )),
        ],
      ],
    );
  }
}
