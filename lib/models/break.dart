import 'package:flutter/material.dart';

class BreakRecord {
  final String type;
  final Duration duration;

  BreakRecord({required this.type, required this.duration});

  Map<String, dynamic> toJson() {
    return {'type': type, 'durationSeconds': duration.inSeconds};
  }

  factory BreakRecord.fromJson(Map<String, dynamic> json) {
    return BreakRecord(type: json['type'], duration: Duration(seconds: json['durationSeconds']));
  }
}

enum BreakType {
  cigarette(representation: 'Cigarette Break', title: 'Cigs', color: Colors.grey),
  poop(representation: 'Poop Break', title: 'Poop', color: Colors.brown),
  pee(representation: 'Pee Break', title: 'Pee', color: Colors.amber);

  const BreakType({required this.representation, required this.title, required this.color});

  final String representation;
  final String title;
  final Color color;
}
