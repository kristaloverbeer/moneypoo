import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'breaks_provider.dart';
import 'user_settings_provider.dart';

part 'earnings_provider.g.dart';

@riverpod
double totalEarnings(Ref ref) {
  final breaks = ref.watch(breaksProvider);
  return breaks.fold(0.0, (total, breakRecord) => total + breakRecord.earnings);
}

@riverpod
double earningsCalculator(Ref ref, Duration duration) {
  final settings = ref.watch(userSettingsProvider);
  final hourlyRate = settings.monthlyIncome / (settings.weeklyHours * 4.33);
  final breakHours = duration.inSeconds / 3600;
  return hourlyRate * breakHours;
}
