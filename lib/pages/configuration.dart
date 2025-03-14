import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../models/language.dart';
import '../providers/user_settings_provider.dart';
import 'dashboard.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  ConsumerState<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {
  final TextEditingController _monthlyIncomeController = TextEditingController();
  final TextEditingController _weeklyHoursController = TextEditingController();
  late Currency _selectedCurrency;
  late Language _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(userSettingsProvider);
    _monthlyIncomeController.text = settings.monthlyIncome.toString();
    _weeklyHoursController.text = settings.weeklyHours.toString();
    _selectedCurrency = settings.currency;
    _selectedLanguage = settings.language;
  }

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _weeklyHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.configuration), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _monthlyIncomeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '${l10n.monthlyIncome} (${_selectedCurrency.symbol})',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _weeklyHoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.weeklyHours),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Currency>(
              value: _selectedCurrency,
              decoration: InputDecoration(labelText: l10n.currency),
              items:
                  Currency.values.map<DropdownMenuItem<Currency>>((Currency currency) {
                    return DropdownMenuItem<Currency>(
                      value: currency,
                      child: Text('${currency.name} (${currency.symbol})'),
                    );
                  }).toList(),
              onChanged: (Currency? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                }
              },
              validator: (value) => value == null ? l10n.pleaseSelectCurrency : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Language>(
              value: _selectedLanguage,
              decoration: InputDecoration(labelText: l10n.language),
              items:
                  Language.values.map<DropdownMenuItem<Language>>((Language language) {
                    return DropdownMenuItem<Language>(value: language, child: Text(language.name));
                  }).toList(),
              onChanged: (Language? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final monthlyIncome = double.tryParse(_monthlyIncomeController.text) ?? 0.0;
                final weeklyHours = double.tryParse(_weeklyHoursController.text) ?? 0.0;

                await ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(
                      monthlyIncome: monthlyIncome,
                      weeklyHours: weeklyHours,
                      currency: _selectedCurrency,
                      language: _selectedLanguage,
                    );

                if (!mounted) {
                  return;
                }

                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
