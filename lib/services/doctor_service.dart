import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new doctor to the clinic
  Future<void> addDoctor(String clinicId, Doctor doctor) async {
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('doctors')
        .add(doctor.toMap());
  }

  // Stream all doctors in a clinic
  Stream<List<Doctor>> getDoctorsForClinic(String clinicId) {
    print("Fetching doctors for clinic: $clinicId");
    return _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('doctors')
        .snapshots()
        .map((snapshot) {
          print("Docs fetched: ${snapshot.docs.length}");
          return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
        });
  }

  // Update a doctor's information in the clinic
  Future<void> updateDoctor(
    String clinicId,
    String doctorId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('doctors')
        .doc(doctorId)
        .update(data);
  }

  // Delete a doctor from the clinic
  Future<void> deleteDoctor(String clinicId, String doctorId) async {
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('doctors')
        .doc(doctorId)
        .delete();
  }

  Future<DoctorWithClinic?> getDoctorByCredentials(
    String email,
    String password,
  ) async {
    final clinicsSnapshot =
        await FirebaseFirestore.instance.collection('clinics').get();

    for (var clinicDoc in clinicsSnapshot.docs) {
      final doctorsSnapshot =
          await FirebaseFirestore.instance
              .collection('clinics')
              .doc(
                clinicDoc.id,
              ) // Access the 'doctors' collection under this clinic
              .collection('doctors')
              .where('email', isEqualTo: email)
              .where(
                'password',
                isEqualTo: password,
              ) // Note: plain text! Only for testing.
              .get();

      if (doctorsSnapshot.docs.isNotEmpty) {
        final doctor = Doctor.fromFirestore(doctorsSnapshot.docs.first);
        return DoctorWithClinic(doctor: doctor, clinicId: clinicDoc.id);
      }
    }

    // If no doctor matches the credentials, return null
    return null;
  }
}

class DoctorWithClinic {
  final Doctor doctor;
  final String clinicId;

  DoctorWithClinic({required this.doctor, required this.clinicId});
}
