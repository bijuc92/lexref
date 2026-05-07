import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final actAsync = ref.watch(_actProvider(widget.actId));
    return Scaffold(
      appBar: AppBar(
        title: actAsync.whenData((a) => Text(a.shortName)).value ??
            Text(widget.actId.toUpperCase()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search sections...',
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                s.title.toLowerCase().contains(_query.toLowerCase()) ||
                                s.sectionNo.toLowerCase().contains(_query.toLowerCase()) ||
                                s.content.toLowerCase().contains(_query.toLowerCase()))
                            .toList(),
                      ))
                  .where((ch) => ch.sections.isNotEmpty)
                  .toList();

          if (filtered.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'No results',
              subtitle: 'No sections match "$_query"',
            );
          }

          return CustomScrollView(
            slivers: filtered
                .expand<Widget>((chapter) => [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _ChapterHeader(chapter.title),
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
                    ])
                .toList(),
          );
        },
      ),
    );
  }
}

class _ChapterHeader extends SliverPersistentHeaderDelegate {
  final String title;
  _ChapterHeader(this.title);

  @override
  double get minExtent => 40;
  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  @override
  bool shouldRebuild(_ChapterHeader old) => old.title != title;
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
        onTap: () => context.push('/acts/$actId/section/${section.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
