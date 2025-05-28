import 'package:cloud_firestore/cloud_firestore.dart';

class ActivePlanModel {
  final String activePlanId;
  final String prescriptionId;
  final String patientId;
  final String doctorId;
  final String title; // e.g., Diabetes Plan
  final List<String> medicines;
  final int totalDoses;
  final int takenDoses;
  final int durationDays;
  final int daysPassed;
  final Timestamp startedAt;
  final bool isCompleted;

  ActivePlanModel({
    required this.activePlanId,
    required this.prescriptionId,
    required this.patientId,
    required this.doctorId,
    required this.title,
    required this.medicines,
    required this.totalDoses,
    required this.takenDoses,
    required this.durationDays,
    required this.daysPassed,
    required this.startedAt,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() => {
    'activePlanId': activePlanId,
    'prescriptionId': prescriptionId,
    'patientId': patientId,
    'doctorId': doctorId,
    'title': title,
    'medicines': medicines,
    'totalDoses': totalDoses,
    'takenDoses': takenDoses,
    'durationDays': durationDays,
    'daysPassed': daysPassed,
    'startedAt': startedAt,
    'isCompleted': isCompleted,
  };

  factory ActivePlanModel.fromMap(Map<String, dynamic> map) {
    return ActivePlanModel(
      activePlanId: map['activePlanId'],
      prescriptionId: map['prescriptionId'],
      patientId: map['patientId'],
      doctorId: map['doctorId'],
      title: map['title'],
      medicines: List<String>.from(map['medicines']),
      totalDoses: map['totalDoses'],
      takenDoses: map['takenDoses'],
      durationDays: map['durationDays'],
      daysPassed: map['daysPassed'],
      startedAt: map['startedAt'],
      isCompleted: map['isCompleted'],
    );
  }
}
