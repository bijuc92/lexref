import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart' as app_dates;
import '../../../shared/models/local/local_note.dart';
import '../../../shared/data/folders_repository.dart';
import '../../../shared/providers/folders_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/folder_manage.dart';
import '../data/notes_repository.dart';

final notesProvider = FutureProvider<Map<String, List<LocalNote>>>((ref) {
  return NotesRepository().getNotesByFolder();
});

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen>
    with TickerProviderStateMixin {
  late TabController _tabs;

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

  void _rebuildTabs(int count) {
    if (count != _tabs.length) {
      final old = _tabs;
      _tabs = TabController(
        length: count,
        vsync: this,
        initialIndex: old.index.clamp(0, count - 1),
      );
      old.dispose();
    }
  }

  Future<void> _createFolder() async {
    final name = await promptFolderName(context);
    if (name == null || name.isEmpty) return;
    await FoldersRepository().createFolder(name);
    ref.invalidate(foldersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);
    final folderList = ref.watch(foldersProvider).valueOrNull ?? const ['General'];

    return notesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('My Notes')),
        body: Center(child: Text(e.toString())),
      ),
      data: (byFolder) {
        final folders = <String>{...folderList, ...byFolder.keys}.toList()
          ..sort((a, b) {
            if (a == FoldersRepository.defaultFolder) return -1;
            if (b == FoldersRepository.defaultFolder) return 1;
            return a.compareTo(b);
          });
        _rebuildTabs(folders.length);

        final totalNotes =
            byFolder.values.fold<int>(0, (s, l) => s + l.length);

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Notes'),
            bottom: TabBar(
              controller: _tabs,
              isScrollable: true,
              tabs: folders.map((f) => Tab(text: f)).toList(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                tooltip: 'Manage folders',
                onPressed: () async {
                  final folder = folders[_tabs.index];
                  final changed = await manageFolder(context, folder);
                  if (changed) {
                    ref.invalidate(foldersProvider);
                    ref.invalidate(notesProvider);
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: _createFolder,
            tooltip: 'New folder',
            child: const Icon(Icons.create_new_folder_outlined),
          ),
          body: totalNotes == 0
              ? const EmptyState(
                  icon: Icons.edit_note,
                  title: 'No notes yet',
                  subtitle:
                      'Add notes while reading any section to annotate and remember key points',
                )
              : TabBarView(
                  controller: _tabs,
                  children: folders.map((folder) {
                    final items = byFolder[folder] ?? [];
                    if (items.isEmpty) {
                      return const EmptyState(
                        icon: Icons.edit_note,
                        title: 'Empty folder',
                        subtitle: 'No notes in this folder',
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => ref.invalidate(notesProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (_, i) => _NoteTile(note: items[i]),
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}

class _NoteTile extends ConsumerWidget {
  final LocalNote note;
  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushNoteDetail(note.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      note.refId,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    app_dates.timeAgo(note.updatedAt),
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.content.length > 120
                    ? '${note.content.substring(0, 120)}…'
                    : note.content,
                style: GoogleFonts.dmSans(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
