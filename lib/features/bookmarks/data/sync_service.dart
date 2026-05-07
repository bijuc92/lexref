import 'package:connectivity_plus/connectivity_plus.dart';
import '../../bookmarks/data/bookmarks_repository.dart';
import '../../notes/data/notes_repository.dart';

class SyncService {
  final _bookmarksRepo = BookmarksRepository();
  final _notesRepo = NotesRepository();

  Future<void> syncAll() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none)) return;

    await Future.wait([
      _bookmarksRepo.syncToSupabase(),
      _notesRepo.syncToSupabase(),
    ]);
  }
}
