import 'break_type.dart';

class BreakRecord {
  final BreakType breakType;
  final Duration duration;
  final double earnings;

  BreakRecord({required this.breakType, required this.duration, required this.earnings});

  Map<String, dynamic> toJson() {
    return {'type': breakType.index, 'durationSeconds': duration.inSeconds, 'earnings': earnings};
  }

  factory BreakRecord.fromJson(Map<String, dynamic> json) {
    return BreakRecord(
      breakType: BreakType.values[json['type']],
      duration: Duration(seconds: json['durationSeconds']),
      earnings: json['earnings']?.toDouble() ?? 0.0,
    );
  }
}
