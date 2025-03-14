import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/break.dart';
import '../models/break_type.dart';
import '../providers/user_settings_provider.dart';

class SummarySection extends ConsumerWidget {
  final double _totalEarnings;
  final List<BreakRecord> _breakRecords;
  final String title;

  const SummarySection({
    required double totalEarnings,
    required List<BreakRecord> breakRecords,
    required this.title,
    super.key,
  }) : _totalEarnings = totalEarnings,
       _breakRecords = breakRecords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.money_off_rounded),
            const SizedBox(width: 10),
            Text(
              l10n.totalBreakEarnings(settings.currency.symbol, _totalEarnings.toStringAsFixed(2)),
            ),
          ],
        ),
        BreakChart(breakRecords: _breakRecords),
      ],
    );
  }
}

class BreakChart extends StatelessWidget {
  final List<BreakRecord> breakRecords;

  const BreakChart({required this.breakRecords, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AspectRatio(
      aspectRatio: 1.3,
      child:
          breakRecords.isEmpty
              ? Center(child: Text(l10n.noBreakChartRecords))
              : PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections:
                      BreakType.values.map<PieChartSectionData>((BreakType breakType) {
                        return PieChartSectionData(
                          value: _computeDuration(breakType: breakType).toDouble(),
                          title: breakType.getTitle(context),
                          color: breakType.color,
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                ),
              ),
    );
  }

  int _computeDuration({required BreakType breakType}) {
    return breakRecords
        .where((record) => record.breakType == breakType)
        .map((record) => record.duration.inMinutes)
        .fold(0, (previous, current) => previous + current);
  }
}
