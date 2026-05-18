import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/error/result.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/local/local_bookmark.dart';
import '../../../shared/models/local/local_note.dart';
import '../../../shared/widgets/act_badge.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/folder_picker.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../bookmarks/data/bookmarks_repository.dart';
import '../../bookmarks/presentation/bookmarks_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../notes/data/notes_repository.dart';
import '../../notes/presentation/notes_screen.dart';
import '../domain/act_models.dart';
import '../domain/acts_providers.dart';

class SectionDetailScreen extends ConsumerStatefulWidget {
  final String actId;
  final String sectionId;

  const SectionDetailScreen({
    super.key,
    required this.actId,
    required this.sectionId,
  });

  @override
  ConsumerState<SectionDetailScreen> createState() =>
      _SectionDetailScreenState();
}

class _SectionDetailScreenState extends ConsumerState<SectionDetailScreen> {
  final _tts = FlutterTts();
  bool _speaking = false;
  bool _bookmarked = false;
  String? _noteContent;
  final _bookmarksRepo = BookmarksRepository();
  final _notesRepo = NotesRepository();
  final _shareButtonKey = GlobalKey();

  String get _compositeId => '${widget.actId}__${widget.sectionId}';

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() => setState(() => _speaking = false));
    _checkBookmark();
    _loadNote();
  }

  Future<void> _checkBookmark() async {
    try {
      final bm = await _bookmarksRepo.getBookmark(widget.sectionId);
      if (mounted) setState(() => _bookmarked = bm != null);
    } catch (_) {}
  }

  Future<void> _loadNote() async {
    try {
      final note = await _notesRepo.getNoteForRef(widget.sectionId);
      if (mounted && note != null) setState(() => _noteContent = note.content);
    } catch (e) {
      debugPrint('_loadNote error: $e');
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _toggleTts(String text) async {
    if (_speaking) {
      await _tts.stop();
      setState(() => _speaking = false);
    } else {
      setState(() => _speaking = true);
      await _tts.setLanguage('en-IN');
      await _tts.speak(text.replaceAll(RegExp(r'\*+'), ''));
    }
  }

  Future<void> _toggleBookmark(SectionModel section) async {
    final Result<void> result;
    if (_bookmarked) {
      result = await _bookmarksRepo.removeBookmark(section.id);
    } else {
      final folder = await showFolderPicker(context, current: 'General');
      if (!mounted || folder == null) return;
      result = await _bookmarksRepo.addBookmark(
        LocalBookmark(
          id: section.id,
          refType: 'section',
          refId: section.id,
          refTitle: 'S.${section.sectionNo} — ${section.title}',
          refAct: widget.actId.toUpperCase(),
          folder: folder,
          savedAt: DateTime.now(),
        ),
      );
    }
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
    setState(() => _bookmarked = !_bookmarked);
    ref.invalidate(bookmarksProvider);
    ref.invalidate(homeStatsProvider);
  }

  Color _xrefColor(String actId) {
    switch (actId) {
      case 'bns':
        return AppColors.bnsBadge;
      case 'bnss':
        return AppColors.bnssBadge;
      case 'ipc':
        return AppColors.ipcBadge;
      case 'crpc':
        return AppColors.crpcBadge;
      default:
        return AppColors.primary;
    }
  }

  void _addNote(SectionModel section) {
    final ctrl = TextEditingController(text: _noteContent);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note for S.${section.sectionNo}',
              style: GoogleFonts.libreBaskerville(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Write your note...',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (ctrl.text.isNotEmpty) {
                    final result = await _notesRepo.saveNote(
                      LocalNote(
                        id: '${section.id}_note',
                        refType: 'section',
                        refId: section.id,
                        content: ctrl.text,
                        updatedAt: DateTime.now(),
                      ),
                    );
                    if (result case Err(:final failure)) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text(failure.message),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                      return;
                    }
                    setState(() => _noteContent = ctrl.text);
                    ref.invalidate(homeStatsProvider);
                    ref.invalidate(notesProvider);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save Note'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionAsync = ref.watch(sectionDetailProvider(_compositeId));
    return Scaffold(
      appBar: AppBar(
        actions: sectionAsync.whenData((s) {
          if (s == null) return <Widget>[];
          return [
            IconButton(
              icon: Icon(
                _bookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: _bookmarked ? AppColors.primary : null,
              ),
              tooltip: _bookmarked ? 'Remove bookmark' : 'Bookmark',
              onPressed: () => _toggleBookmark(s),
            ),
            IconButton(
              key: _shareButtonKey,
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share',
              onPressed: () {
                final box = _shareButtonKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                Share.share(
                  'Section ${s.sectionNo} — ${s.title}\n\n${s.content}\n\nShared via LexRef',
                  sharePositionOrigin: box != null
                      ? box.localToGlobal(Offset.zero) & box.size
                      : null,
                );
              },
            ),
          ];
        }).value ??
            [],
      ),
      body: sectionAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoadingShimmer(height: 24, width: 120),
              SizedBox(height: 12),
              LoadingShimmer(height: 18),
              SizedBox(height: 8),
              LoadingShimmer(height: 200),
            ],
          ),
        ),
        error: (e, _) => ErrorState(message: e.toString(), onRetry: () {}),
        data: (section) {
          if (section == null) {
            return const Center(child: Text('Section not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ActBadge(widget.actId.toUpperCase()),
                    const SizedBox(width: 8),
                    Text(
                      'Section ${section.sectionNo}',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _speaking
                            ? Icons.stop_circle_outlined
                            : Icons.volume_up_outlined,
                        color: _speaking ? AppColors.error : AppColors.primary,
                      ),
                      tooltip: _speaking ? 'Stop' : 'Read aloud',
                      onPressed: () => _toggleTts(section.content),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  section.title,
                  style: GoogleFonts.libreBaskerville(fontSize: 22),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                MarkdownBody(
                  data: section.content,
                  styleSheet: MarkdownStyleSheet(
                    p: GoogleFonts.dmSans(fontSize: 15, height: 1.7),
                    strong: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (section.relatedSections.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Related Sections',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: section.relatedSections.map((relId) {
                      final parts = relId.split('_');
                      final label = parts.length >= 2 ? 'S.${parts.last}' : relId;
                      return ActionChip(
                        label: Text(label),
                        onPressed: () => context.pushSectionDetail(
                          actId: parts.first,
                          sectionId: relId,
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (section.crossReferences.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'See Also',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: section.crossReferences.entries.map((entry) {
                      final xrefActId = entry.key;
                      final xrefSectionNo = entry.value;
                      final xrefSectionId = '${xrefActId}_$xrefSectionNo';
                      final actLabel = xrefActId.toUpperCase();
                      return ActionChip(
                        avatar: CircleAvatar(
                          backgroundColor: _xrefColor(xrefActId),
                          radius: 8,
                          child: const SizedBox.shrink(),
                        ),
                        label: Text('$actLabel S.$xrefSectionNo'),
                        onPressed: () => context.pushSectionDetail(
                          actId: xrefActId,
                          sectionId: xrefSectionId,
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (_noteContent != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Note',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _noteContent!,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_note),
                        label: Text(_noteContent == null ? 'Add Note' : 'Edit Note'),
                        onPressed: () => _addNote(section),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.smart_toy_outlined),
                        label: const Text('Ask AI'),
                        onPressed: () => context.goAiChat(
                          initialMessage: 'Explain Section ${section.sectionNo} ${widget.actId.toUpperCase()} in detail: ${section.title}',
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
