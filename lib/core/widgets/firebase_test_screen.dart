import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase/firebase_data_seeder.dart';

class FirebaseTestScreen extends StatelessWidget {
  const FirebaseTestScreen({super.key});

  Future<void> _testFirebase() async {
    try {
      // Test data seeding
      var seeder = FirebaseDataSeeder();
      await seeder.seedSampleData();
      print('Firebase test successful');
    } catch (e) {
      print('Firebase test failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: _testFirebase,
          child: const Text('Test Firebase & Seed Data'),
        ),
      ),
    );
}
