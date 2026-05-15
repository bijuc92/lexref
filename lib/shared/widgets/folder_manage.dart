import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../data/folders_repository.dart';

/// Prompts for a folder name. Returns the trimmed name, or null if cancelled.
Future<String?> promptFolderName(
  BuildContext context, {
  String title = 'New Folder',
  String? initial,
}) {
  final ctrl = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
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
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Shows rename/delete actions for [folder]. Returns true if the folder was
/// renamed or deleted (caller should refresh). 'General' cannot be managed.
Future<bool> manageFolder(BuildContext context, String folder) async {
  if (folder == FoldersRepository.defaultFolder) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('The General folder cannot be modified.')),
    );
    return false;
  }

  final action = await showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                folder,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text('Rename folder'),
            onTap: () => Navigator.pop(sheetCtx, 'rename'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text('Delete folder'),
            subtitle: const Text('Items move to General'),
            onTap: () => Navigator.pop(sheetCtx, 'delete'),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return false;

  final repo = FoldersRepository();
  if (action == 'rename') {
    final newName = await promptFolderName(
      context,
      title: 'Rename Folder',
      initial: folder,
    );
    if (newName == null || newName.isEmpty || newName == folder) return false;
    await repo.renameFolder(folder, newName);
    return true;
  }

  if (action == 'delete') {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text(
          'Delete "$folder"? Notes and bookmarks in it will move to General.',
        ),
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
    if (confirmed != true) return false;
    await repo.deleteFolder(folder);
    return true;
  }
  return false;
}
