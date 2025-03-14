import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/break.dart';
import '../providers/breaks_provider.dart';
import '../providers/user_settings_provider.dart';
import 'dashboard.dart';

class BreakDetailsPage extends ConsumerWidget {
  final BreakRecord breakRecord;
  final int breakIndex;

  const BreakDetailsPage({super.key, required this.breakRecord, required this.breakIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('${l10n.onebreak} N°${breakIndex + 1}'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailSection(
              l10n.breakType,
              breakRecord.breakType.getDescription(context),
              context,
            ),
            _buildDetailSection(
              l10n.duration,
              '${breakRecord.duration.inHours}h ${breakRecord.duration.inMinutes.remainder(60)}min ${breakRecord.duration.inSeconds.remainder(60)}s',
              context,
            ),
            _buildDetailSection(
              l10n.earnings,
              '${settings.currency.symbol} ${breakRecord.earnings.toStringAsFixed(2)}',
              context,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteConfirmationDialog(context, ref, l10n),
                icon: const Icon(Icons.delete),
                label: Text(l10n.deleteBreak),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(content, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(l10n.deleteBreak),
            content: Text(l10n.confirmDeleteBreak),
            actions: [
              TextButton(child: Text(l10n.cancel), onPressed: () => Navigator.of(context).pop()),
              TextButton(
                child: Text(l10n.delete),
                onPressed: () {
                  ref.read(breaksProvider.notifier).deleteBreak(breakIndex);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
              ),
            ],
          ),
    );
  }
}
