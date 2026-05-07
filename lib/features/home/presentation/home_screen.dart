import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/auth/domain/auth_providers.dart';
import '../../../features/bookmarks/data/bookmarks_repository.dart';
import '../../../features/notes/data/notes_repository.dart';
import '../../../features/search/data/search_repository.dart';

final _homeStatsProvider = FutureProvider<_HomeStats>((ref) async {
  final bookmarks =
      await BookmarksRepository().getBookmarksByFolder();
  final bookmarkCount =
      bookmarks.values.fold<int>(0, (sum, list) => sum + list.length);
  final notes = await NotesRepository().getAllNotes();
  final recent = await SearchRepository().getRecentSearches();
  return _HomeStats(
    bookmarks: bookmarkCount,
    notes: notes.length,
    recentSearches: recent.length,
    recent: recent.take(5).toList(),
  );
});

class _HomeStats {
  final int bookmarks, notes, recentSearches;
  final List<String> recent;
  const _HomeStats({
    required this.bookmarks,
    required this.notes,
    required this.recentSearches,
    required this.recent,
  });
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).valueOrNull;
    final stats = ref.watch(_homeStatsProvider);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    final firstName =
        (profile?['full_name'] as String? ?? '').split(' ').first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LexRef',
          style: GoogleFonts.dmSerifDisplay(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(_homeStatsProvider),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              firstName.isEmpty ? greeting : '$greeting, $firstName',
              style: GoogleFonts.dmSerifDisplay(fontSize: 26),
            ),
            const SizedBox(height: 4),
            Text(
              'Your legal research workspace',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            stats.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (s) => Row(
                children: [
                  _StatCard(
                    label: 'Bookmarks',
                    value: s.bookmarks,
                    icon: Icons.bookmark,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Notes',
                    value: s.notes,
                    icon: Icons.edit_note,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Searches',
                    value: s.recentSearches,
                    icon: Icons.history,
                    color: const Color(0xFF6A1B9A),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SearchTapTarget(onTap: () => context.go('/home/search')),
            const SizedBox(height: 24),
            Text(
              'Quick Access',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: [
                _QuickCard(
                  icon: Icons.menu_book,
                  label: 'Law Sections',
                  subtitle: 'IPC · CrPC · CPC · Evidence',
                  color: AppColors.primary,
                  onTap: () => context.go('/home/acts'),
                ),
                _QuickCard(
                  icon: Icons.gavel,
                  label: 'Case Law',
                  subtitle: 'Search judgments',
                  color: const Color(0xFF1565C0),
                  onTap: () => context.push('/home/search'),
                ),
                _QuickCard(
                  icon: Icons.smart_toy_outlined,
                  label: 'AI Assistant',
                  subtitle: 'Ask legal questions',
                  color: const Color(0xFF6A1B9A),
                  onTap: () => context.go('/home/ai'),
                ),
                _QuickCard(
                  icon: Icons.bookmark,
                  label: 'Bookmarks',
                  subtitle: 'Saved sections',
                  color: const Color(0xFF2E7D32),
                  onTap: () => context.go('/home/bookmarks'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            stats.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (s) {
                if (s.recent.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Searches',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...s.recent.map(
                      (q) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.history,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        title: Text(
                          q,
                          style: GoogleFonts.dmSans(fontSize: 14),
                        ),
                        onTap: () =>
                            context.push('/home/search?q=${Uri.encodeComponent(q)}'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 20,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchTapTarget extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchTapTarget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(
              'Search sections, cases…',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _QuickCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const Spacer(),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
