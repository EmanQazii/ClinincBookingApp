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

      print("Fetched ${querySnapshot.docs.length} appointments");

      final appointments =
          querySnapshot.docs
              .map((doc) {
                final appointment = doc.data();
                final dateString = appointment['appointmentDate'];

                print("Appointment data: $appointment");

                if (dateString == null || dateString is! String) {
                  print("Invalid or missing appointmentDate: $dateString");
                  return null;
                }

                DateTime? appointmentDate = DateTime.tryParse(dateString);

                if (appointmentDate == null) {
                  print("Failed to parse appointmentDate: $dateString");
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

      print("Filtered appointments: $appointments");

      return appointments.cast<Map<String, dynamic>>().where((appointment) {
        final appointmentDate = appointment['appointmentDate'] as DateTime;

        return upcoming
            ? appointmentDate.isAfter(today) // For upcoming
            : appointmentDate.isBefore(today); // For history
      }).toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }
}
