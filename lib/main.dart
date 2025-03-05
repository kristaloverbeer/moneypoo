import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/configuration.dart';
import 'pages/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyPoo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: _isConfigured(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            final isConfigured = snapshot.data ?? false;
            return isConfigured ? const DashboardScreen() : const ConfigurationScreen();
          }
        },
      ),
    );
  }

  Future<bool> _isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    // Delete when done
    await prefs.clear();

    return prefs.containsKey('monthlyIncome'); // Check for a key that indicates configuration.
  }
}
