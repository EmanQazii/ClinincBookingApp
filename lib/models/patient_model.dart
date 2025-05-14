import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String pId;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String age;
  final String weight;
  final Timestamp? dob;
  final Timestamp? createdAt;
  final Timestamp? lastLogin;
  final bool rememberMe;

  PatientModel({
    required this.pId,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.weight,
    this.dob,
    this.createdAt,
    this.lastLogin,
    required this.rememberMe,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json, String id) {
    return PatientModel(
      pId: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? 'N/A',
      age: json['age'] ?? 'N/A',
      weight: json['weight'] ?? 'N/A',
      dob: json['dob'],
      createdAt: json['createdAt'],
      lastLogin: json['lastLogin'],
      rememberMe: json['rememberMe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'age': age,
      'weight': weight,
      'dob': dob,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'rememberMe': rememberMe,
    };
  }
}
