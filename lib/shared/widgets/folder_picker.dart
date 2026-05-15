import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../data/folders_repository.dart';
import 'folder_manage.dart';

/// Shows a bottom sheet to pick (or create) a folder. Returns the chosen
/// folder name, or null if dismissed.
Future<String?> showFolderPicker(
  BuildContext context, {
  required String current,
}) async {
  final repo = FoldersRepository();
  final folders = await repo.getFolders();
  if (!context.mounted) return null;

  return showModalBottomSheet<String>(
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
                'Move to folder',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final f in folders)
                  ListTile(
                    leading: Icon(
                      f == current
                          ? Icons.radio_button_checked
                          : Icons.folder_outlined,
                      color: f == current
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(f),
                    onTap: () => Navigator.pop(sheetCtx, f),
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.create_new_folder_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('New folder…'),
                  onTap: () async {
                    final name = await promptFolderName(sheetCtx);
                    if (name == null || name.isEmpty) return;
                    await repo.createFolder(name);
                    if (sheetCtx.mounted) Navigator.pop(sheetCtx, name);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
