import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/config/env.dart';
import '../../../core/error/result.dart';
import '../../bookmarks/data/bookmarks_repository.dart';
import '../../notes/data/notes_repository.dart';

class SyncService {
  final _bookmarksRepo = BookmarksRepository();
  final _notesRepo = NotesRepository();

  Future<Result<void>> syncAll() async {
    try {
      // Cloud sync is a Pro feature — skip silently for free users
      if (Env.revenueCatApiKey.isNotEmpty) {
        final info = await Purchases.getCustomerInfo();
        if (!info.entitlements.active.containsKey('pro')) return const Ok(null);
      }

      final results = await Connectivity().checkConnectivity();
      if (results.contains(ConnectivityResult.none)) return const Ok(null);

      final outcomes = await Future.wait(
        [
          _bookmarksRepo.syncToSupabase(),
          _notesRepo.syncToSupabase(),
        ],
        eagerError: false,
      );

      // Surface the first failure, if any
      for (final outcome in outcomes) {
        if (outcome is Err) return outcome;
      }
      return const Ok(null);
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }
}
