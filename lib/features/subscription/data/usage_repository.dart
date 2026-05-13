import 'package:shared_preferences/shared_preferences.dart';

const int kFreeAiLimit = 5;
const int kFreeCaseLimit = 3;

class UsageRepository {
  String _todayKey(String prefix) {
    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return '${prefix}_$date';
  }

  Future<int> getAiQueriesUsed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_todayKey('ai_count')) ?? 0;
  }

  Future<void> incrementAiQuery() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayKey('ai_count');
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }

  Future<int> getCaseSearchesUsed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_todayKey('case_count')) ?? 0;
  }

  Future<void> incrementCaseSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayKey('case_count');
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }
}
