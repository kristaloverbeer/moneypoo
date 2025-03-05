import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyIncomeController = TextEditingController();
  final _weeklyHoursController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentInformation();
  }

  Future<void> _loadCurrentInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final double currentMonthlyIncome = prefs.getDouble('monthlyIncome') ?? 0.0;
    final double currentWeeklyHours = prefs.getDouble('weeklyHours') ?? 0.0;

    setState(() {
      _monthlyIncomeController.text =
          currentMonthlyIncome == 0.0 ? '' : currentMonthlyIncome.toString();
      _weeklyHoursController.text = currentWeeklyHours == 0.0 ? '' : currentWeeklyHours.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _monthlyIncomeController,
                decoration: const InputDecoration(labelText: 'Monthly Income'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly income.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a positive number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _weeklyHoursController,
                decoration: const InputDecoration(labelText: 'Weekly Working Hours'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weekly working hours.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a positive number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble(
                      'monthlyIncome',
                      double.parse(_monthlyIncomeController.text),
                    );
                    await prefs.setDouble('weeklyHours', double.parse(_weeklyHoursController.text));

                    if (context.mounted) {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      );
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _weeklyHoursController.dispose();
    super.dispose();
  }
}
