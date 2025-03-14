import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/break.dart';
import '../models/break_type.dart';
import '../providers/breaks_provider.dart';
import '../providers/earnings_provider.dart';
import '../providers/user_settings_provider.dart';
import '../widgets/break_tile.dart';
import '../widgets/configuration_section.dart';
import '../widgets/summary_section.dart';
import 'configuration.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breaks = ref.watch(breaksProvider);
    final settings = ref.watch(userSettingsProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(l10n.dashboard),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigurationScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            ConfigurationSection(
              monthlyIncome: settings.monthlyIncome,
              weeklyHours: settings.weeklyHours,
              currency: settings.currency,
            ),
            const SizedBox(height: 10),
            SummarySection(title: l10n.summary, breakRecords: breaks, totalEarnings: totalEarnings),
            const SizedBox(height: 10),
            Text(l10n.breaks, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            breaks.isEmpty ? Center(child: Text(l10n.noBreakRecords)) : const SizedBox(),
            // Add break items in reverse chronological order
            ...breaks.asMap().entries.map((entry) {
              final index = breaks.length - 1 - entry.key;
              final record = breaks[index];
              return BreakTile(record: record, breakIndex: index, currency: settings.currency);
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: Text(l10n.reset),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfigurationScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddBreakDialog(context, ref);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Future<void> _showAddBreakDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    BreakType? selectedType;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    final GlobalKey<FormFieldState> breakTypeDropdown = GlobalKey();
    final GlobalKey<FormFieldState> hoursField = GlobalKey();
    final GlobalKey<FormFieldState> minutesField = GlobalKey();
    final GlobalKey<FormFieldState> secondsField = GlobalKey();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(l10n.addBreak),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<BreakType>(
                      key: breakTypeDropdown,
                      decoration: InputDecoration(labelText: l10n.breakType),
                      value: selectedType,
                      items:
                          BreakType.values.map<DropdownMenuItem<BreakType>>((BreakType breakType) {
                            return DropdownMenuItem<BreakType>(
                              value: breakType,
                              child: Text(breakType.getDescription(context)),
                            );
                          }).toList(),
                      onChanged: (BreakType? newValue) {
                        setState(() {
                          selectedType = newValue;
                        });
                      },
                      validator: (value) => value == null ? l10n.pleaseSelectBreakType : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: hoursField,
                            decoration: InputDecoration(labelText: l10n.hours),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              hours = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (int.tryParse(value) == null) {
                                return l10n.invalidNumber;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: minutesField,
                            decoration: InputDecoration(labelText: l10n.minutes),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              minutes = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (int.tryParse(value) == null) {
                                return l10n.invalidNumber;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: secondsField,
                            decoration: InputDecoration(labelText: l10n.seconds),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              seconds = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (int.tryParse(value) == null) {
                                return l10n.invalidNumber;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(l10n.add),
                  onPressed: () {
                    final isValid =
                        breakTypeDropdown.currentState!.validate() &&
                        hoursField.currentState!.validate() &&
                        minutesField.currentState!.validate() &&
                        secondsField.currentState!.validate();

                    if (isValid && selectedType != null) {
                      final duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
                      final earnings = ref.read(earningsCalculatorProvider(duration));
                      final breakRecord = BreakRecord(
                        breakType: selectedType!,
                        duration: duration,
                        earnings: earnings,
                      );
                      ref.read(breaksProvider.notifier).createBreak(breakRecord);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
