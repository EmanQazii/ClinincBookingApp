import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final Timestamp? dob;
  final Timestamp? createdAt;
  final Timestamp? lastLogin;
  final bool rememberMe;

  PatientModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.dob,
    this.createdAt,
    this.lastLogin,
    required this.rememberMe,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
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
      'dob': dob,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'rememberMe': rememberMe,
    };
  }
}
