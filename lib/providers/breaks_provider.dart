import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/break.dart';

part 'breaks_provider.g.dart';

@riverpod
class Breaks extends _$Breaks {
  @override
  List<BreakRecord> build() {
    _loadBreaksFromPrefs(); // Load breaks when the provider is first created
    return []; // Initial empty state
  }

  Future<void> _loadBreaksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final breakRecordsJson = prefs.getStringList('breakRecords');
    if (breakRecordsJson != null) {
      state = breakRecordsJson.map((json) => BreakRecord.fromJson(jsonDecode(json))).toList();
    }
  }

  Future<void> _saveBreaksToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final breakRecordsJson = state.map((breakRecord) => jsonEncode(breakRecord.toJson())).toList();
    await prefs.setStringList('breakRecords', breakRecordsJson);
  }

  Future<void> createBreak(BreakRecord breakRecord) async {
    state = [...state, breakRecord];
    await _saveBreaksToPrefs();
  }

  Future<void> deleteBreak(int index) async {
    state = [...state]..removeAt(index);
    await _saveBreaksToPrefs();
  }
}
