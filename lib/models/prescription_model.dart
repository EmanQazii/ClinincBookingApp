import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionModel {
  final String prescriptionId;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String clinicId;
  final String clinicName;
  final String appointmentId;
  final Timestamp issuedAt;
  final List<String> medicines;
  final List<String>? labTests;
  final String? diagnosis;
  final String? notes;
  final bool isActive;

  PrescriptionModel({
    required this.prescriptionId,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.clinicId,
    required this.clinicName,
    required this.appointmentId,
    required this.issuedAt,
    required this.medicines,
    this.labTests,
    this.diagnosis,
    this.notes,
    required this.isActive,
  });

  // For saving to Firestore (exclude prescriptionId because it's the doc ID)
  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'appointmentId': appointmentId,
      'issuedAt': issuedAt,
      'medicines': medicines,
      'labTests': labTests,
      'diagnosis': diagnosis,
      'notes': notes,
      'isActive': isActive,
    };
  }

  // Create model from Firestore DocumentSnapshot
  factory PrescriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrescriptionModel(
      prescriptionId: doc.id,
      doctorId: data['doctorId'],
      doctorName: data['doctorName'],
      specialization: data['specialization'],
      clinicId: data['clinicId'],
      clinicName: data['clinicName'],
      appointmentId: data['appointmentId'],
      issuedAt: data['issuedAt'],
      medicines: List<String>.from(data['medicines'] ?? []),
      labTests:
          data['labTests'] != null ? List<String>.from(data['labTests']) : null,
      diagnosis: data['diagnosis'],
      notes: data['notes'],
      isActive: data['isActive'] ?? true,
    );
  }
}
