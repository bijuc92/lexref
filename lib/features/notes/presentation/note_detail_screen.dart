import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/error/result.dart';
import '../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/date_utils.dart' as app_dates;
import '../../../shared/models/local/local_note.dart';
import '../../../shared/providers/folders_provider.dart';
import '../../../shared/widgets/folder_picker.dart';
import '../data/notes_repository.dart';
import 'notes_screen.dart';

final _noteProvider =
    FutureProvider.family<LocalNote?, String>((ref, id) async {
  return NotesRepository().getNote(id);
});

class NoteDetailScreen extends ConsumerStatefulWidget {
  final String noteId;
  const NoteDetailScreen({super.key, required this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  final _ctrl = TextEditingController();
  final _repo = NotesRepository();
  Timer? _debounce;
  bool _dirty = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _dirty = true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _save(value));
  }

  Future<void> _save(String content) async {
    try {
      await _repo.updateNote(widget.noteId, content);
      if (!mounted) return;
      setState(() => _dirty = false);
      ref.invalidate(notesProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _moveToFolder(LocalNote note) async {
    final target = await showFolderPicker(context, current: note.folder);
    if (target == null || target == note.folder) return;
    await _repo.updateNoteFolder(note.id, target);
    if (!mounted) return;
    ref.invalidate(_noteProvider(widget.noteId));
    ref.invalidate(notesProvider);
    ref.invalidate(foldersProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Moved to $target')),
    );
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('This note will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final result = await _repo.deleteNote(widget.noteId);
    if (!mounted) return;
    if (result case Err(:final failure)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(_noteProvider(widget.noteId));
    return noteAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(e.toString())),
      ),
      data: (note) {
        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Note not found')),
          );
        }
        if (_ctrl.text.isEmpty && note.content.isNotEmpty) {
          _ctrl.text = note.content;
          _ctrl.selection = TextSelection.collapsed(
            offset: _ctrl.text.length,
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.refId,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  app_dates.formatDate(note.updatedAt),
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              if (_dirty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.folder_outlined),
                tooltip: 'Move to folder',
                onPressed: () => _moveToFolder(note),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                tooltip: 'Delete note',
                onPressed: _delete,
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: TextField(
              controller: _ctrl,
              onChanged: _onChanged,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.dmSans(fontSize: 15, height: 1.7),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Start writing your note…',
              ),
            ),
          ),
        );
      },
    );
  }
}
