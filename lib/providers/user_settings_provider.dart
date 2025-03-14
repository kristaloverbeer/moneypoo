import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/currency.dart';
import '../models/language.dart';

part 'user_settings_provider.g.dart';

class Settings {
  final double monthlyIncome;
  final double weeklyHours;
  final Currency currency;
  final Language language;

  const Settings({
    required this.monthlyIncome,
    required this.weeklyHours,
    required this.currency,
    required this.language,
  });

  Settings copyWith({
    double? monthlyIncome,
    double? weeklyHours,
    Currency? currency,
    Language? language,
  }) {
    return Settings(
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      currency: currency ?? this.currency,
      language: language ?? this.language,
    );
  }
}

@riverpod
class UserSettings extends _$UserSettings {
  @override
  Settings build() {
    _loadSettings();
    return const Settings(
      monthlyIncome: 0.0,
      weeklyHours: 0.0,
      currency: Currency.usd,
      language: Language.english,
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = Settings(
      monthlyIncome: prefs.getDouble('monthlyIncome') ?? 0.0,
      weeklyHours: prefs.getDouble('weeklyHours') ?? 0.0,
      currency: Currency.values.firstWhere(
        (c) => c.code == prefs.getString('selectedCurrency'),
        orElse: () => Currency.usd,
      ),
      language: Language.values.firstWhere(
        (l) => l.code == prefs.getString('selectedLanguage'),
        orElse: () => Language.english,
      ),
    );
  }

  Future<void> updateSettings({
    double? monthlyIncome,
    double? weeklyHours,
    Currency? currency,
    Language? language,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (monthlyIncome != null) {
      await prefs.setDouble('monthlyIncome', monthlyIncome);
    }
    if (weeklyHours != null) {
      await prefs.setDouble('weeklyHours', weeklyHours);
    }
    if (currency != null) {
      await prefs.setString('selectedCurrency', currency.code);
    }
    if (language != null) {
      await prefs.setString('selectedLanguage', language.code);
    }

    state = state.copyWith(
      monthlyIncome: monthlyIncome,
      weeklyHours: weeklyHours,
      currency: currency,
      language: language,
    );
  }
}
