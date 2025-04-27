import 'package:flutter/material.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Dashboard')),
      body: Center(child: Text('Welcome to the Patient Dashboard!')),
    );
  }
}
