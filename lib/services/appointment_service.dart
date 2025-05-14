import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  static final _firestore = FirebaseFirestore.instance;
  static final _appointmentsCollection = _firestore.collection('appointments');

  static Future<void> bookAppointment(AppointmentModel appointment) async {
    final docRef = _appointmentsCollection.doc(); // generate unique ID
    final appointmentWithId = appointment.copyWith(appointmentId: docRef.id);

    final data = appointmentWithId.toMap();

    // Save in main appointments collection
    await docRef.set(data);

    // Save in patient's subcollection
    await _firestore
        .collection('patients')
        .doc(appointment.patientId)
        .collection('appointments')
        .doc(docRef.id)
        .set(data);

    // Save in doctor's subcollection
    await _firestore
        .collection('clinics')
        .doc(appointment.clinicId)
        .collection('doctors')
        .doc(appointment.doctorId)
        .collection('appointments')
        .doc(docRef.id)
        .set(data);
  }

  static Future<List<Map<String, dynamic>>> fetchAppointments({
    required String patientId,
    required bool upcoming,
  }) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .collection('appointments')
              .get();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final appointments =
          querySnapshot.docs
              .map((doc) {
                final appointment = doc.data();
                final dateString = appointment['appointmentDate'];

                if (dateString == null || dateString is! String) {
                  return null;
                }

                DateTime? appointmentDate = DateTime.tryParse(dateString);

                if (appointmentDate == null) {
                  return null;
                }

                appointmentDate = DateTime(
                  appointmentDate.year,
                  appointmentDate.month,
                  appointmentDate.day,
                );

                return {...appointment, 'appointmentDate': appointmentDate};
              })
              .where((appointment) => appointment != null)
              .toList();

      return appointments.cast<Map<String, dynamic>>().where((appointment) {
        final appointmentDate = appointment['appointmentDate'] as DateTime;
        final status = appointment['status']?.toString().toLowerCase();

        if (status == 'completed') {
          return !upcoming; // Show in history only
        }

        if (status == 'pending') {
          return upcoming
              ? !appointmentDate.isBefore(today) // Today or future
              : appointmentDate.isBefore(today); // Past
        }

        return false; // Unknown or missing status
      }).toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  static Future<bool> documentExists(DocumentReference docRef) async {
    var snapshot = await docRef.get();
    return snapshot.exists;
  }

  static Future<void> updateDiagnosisAndPrescription({
    required String clinicId,
    required String doctorId,
    required String patientId,
    required String appointmentId,
    String status = 'Completed',
    String? diagnosis,
    List<String>? prescription,
    List<String>? labTestsRequested,
    bool reviewed = false,
    String? notes,
  }) async {
    final dataToUpdate = <String, dynamic>{
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (prescription != null) 'prescription': prescription,
      if (labTestsRequested != null) 'labTestsRequested': labTestsRequested,
      'reviewed': reviewed,
      'status': status,
      if (notes != null) 'notes': notes,
    };

    // Update in all locations
    final paths = [
      FirebaseFirestore.instance.collection('appointments').doc(appointmentId),
      FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('appointments')
          .doc(appointmentId),
      FirebaseFirestore.instance
          .collection('clinics')
          .doc(clinicId)
          .collection('doctors')
          .doc(doctorId)
          .collection('appointments')
          .doc(appointmentId),
    ];

    for (final docRef in paths) {
      bool exists = await documentExists(docRef);
      if (!exists) {
        throw 'Document not found at path: ${docRef.path}';
      }
    }

    // If all documents exist, update them
    for (final docRef in paths) {
      await docRef.update(dataToUpdate);
    }
  }

  static Future<List<AppointmentModel>> fetchAppointmentsByDate({
    required String clinicId,
    required String doctorId,
    required DateTime date,
  }) async {
    try {
      final formattedDate =
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('clinics')
              .doc(clinicId)
              .collection('doctors')
              .doc(doctorId)
              .collection('appointments')
              .where('appointmentDate', isEqualTo: formattedDate)
              .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<AppointmentModel>> fetchAllAppointmentsByClinicAndDoctor({
    required String clinicId,
    required String doctorId,
  }) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('clinics')
              .doc(clinicId)
              .collection('doctors')
              .doc(doctorId)
              .collection('appointments')
              .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }
}
