import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum BreakType {
  cigarette(color: Colors.red),
  poop(color: Colors.brown),
  pee(color: Colors.amber),
  coffee(color: Colors.black);

  const BreakType({required this.color});

  final Color color;

  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case BreakType.cigarette:
        return l10n.breakTypeCigarette;
      case BreakType.poop:
        return l10n.breakTypePoop;
      case BreakType.pee:
        return l10n.breakTypePee;
      case BreakType.coffee:
        return l10n.breakTypeCoffee;
    }
  }

  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case BreakType.cigarette:
        return l10n.breakTypeCigaretteShort;
      case BreakType.poop:
        return l10n.breakTypePoopShort;
      case BreakType.pee:
        return l10n.breakTypePeeShort;
      case BreakType.coffee:
        return l10n.breakTypeCoffeeShort;
    }
  }
}
