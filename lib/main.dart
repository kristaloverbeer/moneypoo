import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/configuration.dart';
import 'pages/dashboard.dart';
import 'providers/user_settings_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final language = settings.language;

    return MaterialApp(
      title: 'MoneyPoo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      // Add localization support
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(language.code),
      home: FutureBuilder<bool>(
        future: _isConfigured(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            final isConfigured = snapshot.data ?? false;
            return isConfigured ? const DashboardScreen() : const ConfigurationScreen();
          }
        },
      ),
    );
  }

  Future<bool> _isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('monthlyIncome') && prefs.containsKey('weeklyHours');
  }
}
