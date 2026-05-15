import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/folders_repository.dart';

/// Shared folder list (notes + bookmarks). Invalidate after any folder
/// create/rename/delete to refresh tabs across both screens.
final foldersProvider = FutureProvider<List<String>>((ref) {
  return FoldersRepository().getFolders();
});
