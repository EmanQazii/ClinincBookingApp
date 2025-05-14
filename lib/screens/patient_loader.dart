import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientLoaderScreen extends StatefulWidget {
  final String uid;
  const PatientLoaderScreen({required this.uid, super.key});

  @override
  State<PatientLoaderScreen> createState() => _PatientLoaderScreenState();
}

class _PatientLoaderScreenState extends State<PatientLoaderScreen> {
  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  void fetchPatientData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(widget.uid)
              .get();

      if (doc.exists) {
        final patient = PatientModel.fromJson(doc.data()!, doc.id);
        Navigator.pushReplacementNamed(
          context,
          '/patient_dashboard',
          arguments: patient,
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login', arguments: 'patient');
        throw Exception("Patient record not found.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
