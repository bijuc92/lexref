import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Jurisdiction key -> display name for states that currently have bundled
/// state-level acts. Keys match the `jurisdiction` field in the act JSON assets.
const kSupportedStates = <String, String>{
  'maharashtra': 'Maharashtra',
  'delhi': 'Delhi',
  'karnataka': 'Karnataka',
  'tamil_nadu': 'Tamil Nadu',
  'uttar_pradesh': 'Uttar Pradesh',
};

/// Maps a profile state display name (e.g. "Tamil Nadu") to a supported
/// jurisdiction key (e.g. "tamil_nadu"), or null if that state has no acts yet.
String? jurisdictionKeyFromProfileState(String? profileState) {
  if (profileState == null) return null;
  final normalized = profileState
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z]+'), '_');
  return kSupportedStates.containsKey(normalized) ? normalized : null;
}

/// Holds the user's manually-chosen jurisdiction key, persisted locally so it
/// survives offline. `null` means "fall back to the profile's registered
/// state" — resolution of that fallback happens at the UI layer.
class SelectedStateNotifier extends Notifier<String?> {
  static const _prefsKey = 'selected_jurisdiction_state';

  @override
  String? build() {
    _restore();
    return null;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && kSupportedStates.containsKey(saved)) {
      state = saved;
    }
  }

  Future<void> select(String? key) async {
    state = key;
    final prefs = await SharedPreferences.getInstance();
    if (key == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, key);
    }
  }
}

final selectedStateProvider =
    NotifierProvider<SelectedStateNotifier, String?>(SelectedStateNotifier.new);
