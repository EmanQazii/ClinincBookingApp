import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prescription_model.dart';
import '../models/active_plan_model.dart';

class PrescriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new prescription under a patient
  Future<String> addPrescription(
    String patientId,
    PrescriptionModel prescription,
  ) async {
    final collectionRef = _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions');

    // Add a new document with auto-generated ID
    final docRef = await collectionRef.add(prescription.toMap());

    // Return the generated document ID
    return docRef.id;
  }

  Future<List<Map<String, dynamic>>> getPrescriptionsForPatient(
    String patientId,
  ) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .collection('prescriptions')
              .orderBy('issuedAt', descending: true) // Order by date
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['prescriptionId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> generateActivePlan(
    String patientId,
    String prescriptionId,
    PrescriptionModel prescription,
  ) async {
    final activePlanId =
        _firestore
            .collection('patients')
            .doc(patientId)
            .collection('prescriptions')
            .doc(prescriptionId)
            .collection('activePlans')
            .doc()
            .id;

    // Extract duration and schedule from medicines field
    final medicines = prescription.medicines ?? [];
    int totalDurationDays = 0;
    String timing = "";
    String frequency = "";

    if (medicines.isNotEmpty) {
      final firstMed = medicines.first;
      final parts = firstMed.split('|').map((e) => e.trim()).toList();

      if (parts.length >= 4) {
        final durationString = parts[1].split(' ').first;
        totalDurationDays = int.tryParse(durationString) ?? 0;
        frequency = parts[2];
        timing = parts[3];
      }
    }

    final DateTime startDate = prescription.issuedAt.toDate() ?? DateTime.now();
    final DateTime endDate = startDate.add(Duration(days: totalDurationDays));

    int dosesPerDay = 1;
    final freqParts = frequency.split(' ');
    if (freqParts.isNotEmpty) {
      dosesPerDay = int.tryParse(freqParts[0]) ?? 1;
    }
    final totalDoses = dosesPerDay * totalDurationDays;

    // Create the active plan document
    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions')
        .doc(prescriptionId)
        .collection('activePlans')
        .doc(activePlanId)
        .set({
          'activePlanId': activePlanId,
          'prescriptionId': prescriptionId,
          'patientId': patientId,
          'doctorId': prescription.doctorId ?? '',
          'title': prescription.diagnosis ?? 'Medication Plan',
          'medicines': medicines,
          'totalDoses': totalDoses,
          'takenDoses': 0,
          'durationDays': totalDurationDays,
          'daysPassed': 0,
          'startedAt': Timestamp.fromDate(startDate),
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'timing': timing,
          'frequency': frequency,
          'status': 'active',
          'isCompleted': false,
          'generatedAt': DateTime.now().toIso8601String(),
        });
  }

  Future<void> updateTakenDoses({
    required String patientId,
    required String prescriptionId,
    required String activePlanId,
    required int frequency,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('prescriptions')
          .doc(prescriptionId)
          .collection('activePlans')
          .doc(activePlanId);

      await docRef.update({
        'takenDoses': FieldValue.increment(frequency),
        'daysPassed': FieldValue.increment(1),
      });
    } catch (e) {}
  }

  Future<void> markPlanAsCompleted({
    required String patientId,
    required String prescriptionId,
    required String activePlanId,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('prescriptions')
          .doc(prescriptionId)
          .collection('activePlans')
          .doc(activePlanId);

      await docRef.update({'status': 'completed', 'isCompleted': true});
    } catch (e) {}
  }

  Future<List<ActivePlanModel>> getCompletedPlansForPatient(
    String patientId,
  ) async {
    final snapshot =
        await _firestore
            .collection('patients')
            .doc(patientId)
            .collection('prescriptions')
            .get();

    List<ActivePlanModel> completedPlans = [];

    for (var prescriptionDoc in snapshot.docs) {
      final activePlansSnapshot =
          await prescriptionDoc.reference
              .collection('activePlans')
              .where('status', isEqualTo: 'completed')
              .get();

      completedPlans.addAll(
        activePlansSnapshot.docs.map((doc) {
          return ActivePlanModel.fromMap(doc.data());
        }),
      );
    }

    return completedPlans;
  }

  // Mark a prescription inactive (e.g., expired or completed)
  Future<void> markPrescriptionActive(
    String patientId,
    String prescriptionId,
  ) async {
    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions')
        .doc(prescriptionId)
        .update({'isActive': true});
  }

  Future<List<ActivePlanModel>> getActivePlansForPatient(
    String patientId,
  ) async {
    try {
      final prescriptionsSnapshot =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .collection('prescriptions')
              .get();

      List<ActivePlanModel> activePlans = [];

      for (var prescDoc in prescriptionsSnapshot.docs) {
        final prescriptionId = prescDoc.id;
        final activePlansSnapshot =
            await FirebaseFirestore.instance
                .collection('patients')
                .doc(patientId)
                .collection('prescriptions')
                .doc(prescriptionId)
                .collection('activePlans')
                .where('status', isEqualTo: 'active')
                .get();

        for (var activePlanDoc in activePlansSnapshot.docs) {
          final data = activePlanDoc.data();
          activePlans.add(ActivePlanModel.fromMap(data));
        }
      }

      return activePlans;
    } catch (e) {
      return [];
    }
  }
}
