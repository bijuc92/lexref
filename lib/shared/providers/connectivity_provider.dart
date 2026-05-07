import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  // Emit current state first
  final initial = await connectivity.checkConnectivity();
  yield !initial.contains(ConnectivityResult.none);

  await for (final results in connectivity.onConnectivityChanged) {
    yield !results.contains(ConnectivityResult.none);
  }
});
