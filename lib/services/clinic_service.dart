import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/clinic_model.dart';

class ClinicService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Clinic>> getClinics() async {
    var snapshot = await _db.collection('clinics').get();
    return snapshot.docs.map((doc) => Clinic.fromFirestore(doc)).toList();
  }

  Future<void> addClinic(Clinic clinic) async {
    await _db.collection('clinics').add(clinic.toMap());
  }

  Future<void> updateClinic(String clinicId, Clinic clinic) async {
    await _db.collection('clinics').doc(clinicId).update(clinic.toMap());
  }

  Future<void> deleteClinic(String clinicId) async {
    await _db.collection('clinics').doc(clinicId).delete();
  }

  Future<Clinic?> getClinicById(String clinicId) async {
    var docSnapshot = await _db.collection('clinics').doc(clinicId).get();

    if (docSnapshot.exists) {
      // If the clinic exists, return a Clinic object
      return Clinic.fromFirestore(docSnapshot);
    } else {
      // If the clinic doesn't exist, return null
      return null;
    }
  }
}
