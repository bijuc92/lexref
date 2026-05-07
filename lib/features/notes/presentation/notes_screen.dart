import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart' as app_dates;
import '../../../shared/models/local/local_note.dart';
import '../../../shared/widgets/empty_state.dart';
import '../data/notes_repository.dart';

final _notesProvider = FutureProvider<List<LocalNote>>((ref) {
  return NotesRepository().getAllNotes();
});

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(_notesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (notes) {
          if (notes.isEmpty) {
            return const EmptyState(
              icon: Icons.edit_note,
              title: 'No notes yet',
              subtitle:
                  'Add notes while reading any section to annotate and remember key points',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (_, i) => _NoteTile(note: notes[i]),
          );
        },
      ),
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
                      color: AppColors.primary.withOpacity(0.08),
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
