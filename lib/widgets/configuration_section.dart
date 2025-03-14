import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/currency.dart';

class ConfigurationSection extends StatelessWidget {
  final double _monthlyIncome;
  final double _weeklyHours;
  final Currency _currency;

  const ConfigurationSection({
    required double monthlyIncome,
    required double weeklyHours,
    required Currency currency,
    super.key,
  }) : _monthlyIncome = monthlyIncome,
       _weeklyHours = weeklyHours,
       _currency = currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.money),
            const SizedBox(width: 10),
            Text(l10n.configurationMonthlyIncome(_currency.symbol, _monthlyIncome.toString())),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 10),
            Text(l10n.configurationWeeklyHours(_weeklyHours.toString())),
          ],
        ),
      ],
    );
  }
}
