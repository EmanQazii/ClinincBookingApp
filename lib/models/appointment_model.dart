import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String clinicId;
  final String clinicName;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final Timestamp bookedAt;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String? symptoms;
  final List<String>? labTestsRequested;
  final String? diagnosis;
  final String? prescription;
  final bool reviewed;

  AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.clinicId,
    required this.clinicName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.bookedAt,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    this.symptoms,
    this.labTestsRequested,
    this.diagnosis,
    this.prescription,
    this.reviewed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'status': status,
      'bookedAt': bookedAt,
      'patientId': patientId,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'symptoms': symptoms,
      'labTestsRequested': labTestsRequested,
      'diagnosis': diagnosis,
      'prescription': prescription,
      'reviewed': reviewed,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentId: map['appointmentId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      specialization: map['specialization'] ?? '',
      clinicId: map['clinicId'] ?? '',
      clinicName: map['clinicName'] ?? '',
      appointmentDate: map['appointmentDate'] ?? '',
      appointmentTime: map['appointmentTime'] ?? '',
      status: map['status'] ?? '',
      bookedAt: map['bookedAt'],
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      patientPhone: map['patientPhone'] ?? '',
      symptoms: map['symptoms'],
      labTestsRequested: List<String>.from(map['labTestsRequested'] ?? []),
      diagnosis: map['diagnosis'],
      prescription: map['prescription'],
      reviewed: map['reviewed'] ?? false,
    );
  }
  AppointmentModel copyWith({
    String? appointmentId,
    String? doctorId,
    String? doctorName,
    String? specialization,
    String? clinicId,
    String? clinicName,
    String? appointmentDate,
    String? appointmentTime,
    String? status,
    Timestamp? bookedAt,
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? symptoms,
    List<String>? labTestsRequested,
    String? diagnosis,
    String? prescription,
    bool? reviewed,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      bookedAt: bookedAt ?? this.bookedAt,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      symptoms: symptoms ?? this.symptoms,
      labTestsRequested: labTestsRequested ?? this.labTestsRequested,
      diagnosis: diagnosis ?? this.diagnosis,
      prescription: prescription ?? this.prescription,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}
