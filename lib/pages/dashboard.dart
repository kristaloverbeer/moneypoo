import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/break.dart';
import 'configuration.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BreakRecord> _breakRecords = [];

  double _monthlyIncome = 0.0;
  double _weeklyHours = 0.0;
  double _totalEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ConfigurationScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.money),
                const SizedBox(width: 10),
                Text('Monthly Income: $_monthlyIncome'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text('Weekly Hours: $_weeklyHours'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Break Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Add the total amount earned during all breaks
            Row(
              children: [
                const Icon(Icons.money_off_rounded),
                const SizedBox(width: 10),
                Text('Total break earnings: ${_totalEarnings.toStringAsFixed(2)}'),
              ],
            ),
            //Call function to display chart
            BreakChart(breakRecords: _breakRecords),

            const SizedBox(height: 10),
            const Text('Break Records:', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: _breakRecords.length,
                itemBuilder: (context, index) {
                  final record = _breakRecords[index];
                  return ListTile(
                    title: Text('${record.type} - ${record.duration.inMinutes} minutes'),
                    subtitle: Text('Earned: \$${_calculateEarnings(record).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddBreakDialog(context);
        },
      ),
    );
  }

  Future<void> _showAddBreakDialog(BuildContext context) async {
    String? selectedType;
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
              title: const Text('Add Break'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      key: breakTypeDropdown,
                      decoration: const InputDecoration(labelText: 'Break Type'),
                      value: selectedType,
                      items:
                          BreakType.values.map<DropdownMenuItem<String>>((BreakType breakType) {
                            return DropdownMenuItem<String>(
                              value: breakType.representation,
                              child: Text(breakType.representation),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedType = newValue;
                        });
                      },
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Please select a break type'
                                  : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: hoursField,
                            decoration: const InputDecoration(labelText: 'Hours'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              hours = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (int.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: minutesField,
                            decoration: const InputDecoration(labelText: 'Minutes'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              minutes = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (int.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: secondsField,
                            decoration: const InputDecoration(labelText: 'Seconds'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              seconds = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (int.tryParse(value) == null) {
                                return 'Invalid number';
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
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    final isValid =
                        breakTypeDropdown.currentState!.validate() &&
                        hoursField.currentState!.validate() &&
                        minutesField.currentState!.validate() &&
                        secondsField.currentState!.validate();

                    if (isValid) {
                      final duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
                      final newBreak = BreakRecord(type: selectedType!, duration: duration);
                      _addBreak(newBreak);
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

  double _calculateEarnings(BreakRecord record) {
    final hourlyRate = _monthlyIncome / (_weeklyHours * 4.33); // Approximate monthly hours
    final breakHours = record.duration.inSeconds / 3600;
    return hourlyRate * breakHours;
  }

  void _addBreak(BreakRecord breakRecord) {
    setState(() {
      _breakRecords.add(breakRecord);
      _totalEarnings += _calculateEarnings(breakRecord);
    });
    _saveData(); // Persist the new break.
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _monthlyIncome = prefs.getDouble('monthlyIncome') ?? 0.0;
      _weeklyHours = prefs.getDouble('weeklyHours') ?? 0.0;
      _totalEarnings = prefs.getDouble('totalEarnings') ?? 0.0;

      // Load break records from SharedPreferences
      final breakRecordsJson = prefs.getStringList('breakRecords');
      if (breakRecordsJson != null) {
        _breakRecords =
            breakRecordsJson.map((json) => BreakRecord.fromJson(jsonDecode(json))).toList();
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    // Save break records to SharedPreferences
    final breakRecordsJson =
        _breakRecords.map((breakRecord) => jsonEncode(breakRecord.toJson())).toList();
    await prefs.setStringList('breakRecords', breakRecordsJson);
    await prefs.setDouble('totalEarnings', _totalEarnings);
  }
}

class BreakChart extends StatelessWidget {
  final List<BreakRecord> breakRecords;

  const BreakChart({required this.breakRecords, super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child:
          breakRecords.isEmpty
              ? const Center(child: Text('No break records available yet.'))
              : PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections:
                      BreakType.values.map<PieChartSectionData>((BreakType breakType) {
                        return PieChartSectionData(
                          value: _computeDuration(breakType: breakType).toDouble(),
                          title: breakType.title,
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
        .where((record) => record.type == breakType.representation)
        .map((record) => record.duration.inMinutes)
        .fold(0, (previous, current) => previous + current);
  }
}
