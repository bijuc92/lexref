import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/error/result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/local/local_bookmark.dart';
import '../../../shared/widgets/act_badge.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../core/utils/date_utils.dart' as app_dates;
import '../data/bookmarks_repository.dart';

final bookmarksProvider =
    FutureProvider<Map<String, List<LocalBookmark>>>((ref) {
  return BookmarksRepository().getBookmarksByFolder();
});

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen>
    with TickerProviderStateMixin {
  late TabController _tabs;
  final List<String> _extraFolders = [];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _rebuildTabs(List<String> folders) {
    if (folders.length != _tabs.length) {
      _tabs.dispose();
      _tabs = TabController(length: folders.length, vsync: this);
    }
  }

  void _createFolder() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Folder name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = ctrl.text.trim();
              Navigator.pop(ctx);
              if (name.isEmpty) return;
              setState(() => _extraFolders.add(name));
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    return bookmarksAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Bookmarks')),
        body: Center(child: Text(e.toString())),
      ),
      data: (byFolder) {
        final folderSet = {...byFolder.keys, ..._extraFolders};
        final folders = folderSet.toList()..sort();
        final mergedByFolder = {for (final f in folders) f: byFolder[f] ?? []};
        _rebuildTabs(folders.isEmpty ? ['General'] : folders);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bookmarks'),
            bottom: folders.isEmpty
                ? null
                : TabBar(
                    controller: _tabs,
                    isScrollable: true,
                    tabs: folders.map((f) => Tab(text: f)).toList(),
                  ),
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: _createFolder,
            tooltip: 'New folder',
            child: const Icon(Icons.create_new_folder_outlined),
          ),
          body: Column(
            children: [
              const OfflineBanner(),
              Expanded(
                child: folders.isEmpty
                    ? const EmptyState(
                        icon: Icons.bookmark_border,
                        title: 'No bookmarks yet',
                        subtitle:
                            'Bookmark any section or case to find it quickly later',
                      )
                    : TabBarView(
                        controller: _tabs,
                        children: folders.map((folder) {
                          final items = mergedByFolder[folder] ?? [];
                          if (items.isEmpty) {
                            return const EmptyState(
                              icon: Icons.bookmark_border,
                              title: 'Empty folder',
                              subtitle: 'No bookmarks in this folder',
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async =>
                                ref.invalidate(bookmarksProvider),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              itemBuilder: (_, i) =>
                                  _BookmarkTile(bookmark: items[i]),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BookmarkTile extends ConsumerWidget {
  final LocalBookmark bookmark;
  const _BookmarkTile({required this.bookmark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (bookmark.refType == 'section') {
            final parts = bookmark.refId.split('_');
            final actId = parts.first;
            context.pushSectionDetail(actId: actId, sectionId: bookmark.refId);
          } else if (bookmark.refType == 'case') {
            context.pushCaseDetail(bookmark.refId);
          }
        },
        onLongPress: () => _showOptions(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (bookmark.refAct != null)
                          ActBadge(bookmark.refAct!),
                        const SizedBox(width: 6),
                        Text(
                          app_dates.formatDate(bookmark.savedAt),
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bookmark.refTitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text('Remove bookmark'),
              onTap: () async {
                Navigator.pop(context);
                final result = await BookmarksRepository()
                    .removeBookmark(bookmark.refId);
                if (result case Err(:final failure)) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(failure.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                  return;
                }
                ref.invalidate(bookmarksProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
