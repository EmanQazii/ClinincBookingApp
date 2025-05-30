import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientService {
  final CollectionReference _patientCollection = FirebaseFirestore.instance
      .collection('patients');

  /// Create or update patient info using UID
  Future<void> createOrUpdatePatient(String uid, PatientModel patient) async {
    try {
      await _patientCollection
          .doc(uid)
          .set(patient.toJson(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<PatientModel?> getPatientByEmail(String email) async {
    try {
      final querySnapshot =
          await _patientCollection
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return PatientModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get patient data by UID
  Future<PatientModel?> getPatientById(String uid) async {
    try {
      final doc = await _patientCollection.doc(uid).get();

      if (doc.exists) {
        return PatientModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      } else {}
    } catch (e) {}
    return null;
  }

  /// Update last login timestamp
  Future<void> updateLastLogin(String uid) async {
    try {
      await _patientCollection.doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {}
  }

  /// Check if patient exists
  Future<bool> patientExists(String uid) async {
    try {
      final doc = await _patientCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
