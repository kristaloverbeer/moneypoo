import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/break.dart';
import '../models/currency.dart';
import '../pages/break_details.dart';

class BreakTile extends StatelessWidget {
  final BreakRecord record;
  final int breakIndex;
  final Currency currency;

  const BreakTile({
    super.key,
    required this.record,
    required this.breakIndex,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        title: Text(
          '${record.breakType.getDescription(context)} - ${record.duration.inMinutes} minutes',
        ),
        subtitle: Text(
          '${l10n.earnings}: ${currency.symbol} ${record.earnings.toStringAsFixed(2)}',
        ),
        tileColor: record.breakType.color.withAlpha(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BreakDetailsPage(breakRecord: record, breakIndex: breakIndex),
            ),
          );
        },
      ),
    );
  }
}
