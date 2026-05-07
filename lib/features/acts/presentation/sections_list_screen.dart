import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../data/acts_repository.dart';
import '../domain/act_models.dart';

final _actProvider = FutureProvider.family<ActModel, String>((ref, actId) async {
  final repo = ActsRepository();
  await repo.seedIfNeeded(actId);
  return repo.loadActFromAsset(actId);
});

class SectionsListScreen extends ConsumerStatefulWidget {
  final String actId;
  const SectionsListScreen({super.key, required this.actId});

  @override
  ConsumerState<SectionsListScreen> createState() => _SectionsListScreenState();
}

class _SectionsListScreenState extends ConsumerState<SectionsListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actAsync = ref.watch(_actProvider(widget.actId));
    return Scaffold(
      appBar: AppBar(
        title: actAsync.when(
          data: (a) => Text('${a.shortName}  ·  ${a.totalSections} sections'),
          loading: () => Text(widget.actId.toUpperCase()),
          error: (_, __) => Text(widget.actId.toUpperCase()),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search sections...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: actAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: CardShimmer(),
          ),
        ),
        error: (e, _) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(_actProvider(widget.actId)),
        ),
        data: (act) {
          final filtered = _query.isEmpty
              ? act.chapters
              : act.chapters
                  .map((ch) => ChapterModel(
                        id: ch.id,
                        title: ch.title,
                        sections: ch.sections
                            .where((s) =>
                                s.title
                                    .toLowerCase()
                                    .contains(_query.toLowerCase()) ||
                                s.sectionNo
                                    .toLowerCase()
                                    .contains(_query.toLowerCase()) ||
                                s.content
                                    .toLowerCase()
                                    .contains(_query.toLowerCase()))
                            .toList(),
                      ))
                  .where((ch) => ch.sections.isNotEmpty)
                  .toList();

          final matchCount =
              filtered.fold<int>(0, (sum, ch) => sum + ch.sections.length);

          if (filtered.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              title: _query.isEmpty ? 'No sections found' : 'No results',
              subtitle: _query.isEmpty
                  ? 'Could not load sections for this act'
                  : 'No sections match "$_query"',
            );
          }

          return CustomScrollView(
            slivers: [
              if (_query.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      '$matchCount section${matchCount == 1 ? '' : 's'} match "$_query"',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ...filtered.expand<Widget>((chapter) => [
                    SliverToBoxAdapter(
                      child: _ChapterHeader(chapter.title),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final section = chapter.sections[i];
                            return _SectionTile(
                              actId: widget.actId,
                              section: section,
                              actShortName: act.shortName,
                            );
                          },
                          childCount: chapter.sections.length,
                        ),
                      ),
                    ),
                  ]),
            ],
          );
        },
      ),
    );
  }
}

class _ChapterHeader extends StatelessWidget {
  final String title;
  const _ChapterHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String actId;
  final SectionModel section;
  final String actShortName;

  const _SectionTile({
    required this.actId,
    required this.section,
    required this.actShortName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.pushSectionDetail(actId: actId, sectionId: section.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'S.${section.sectionNo}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section.content.length > 90
                          ? '${section.content.substring(0, 90)}…'
                          : section.content,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
