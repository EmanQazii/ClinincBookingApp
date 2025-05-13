import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String gender;
  final String specialization;
  final String qualification;
  final int experience; // in years
  final double consultationFee;
  final double averageRating;
  final String imageUrl;
  final Map<String, Map<String, String>>
  weeklyAvailability; // Updated field for availability

  Doctor({
    required this.id,
    required this.name,
    required this.gender,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.consultationFee,
    required this.averageRating,
    required this.weeklyAvailability,
    required this.imageUrl,
  });

  // Factory constructor to convert Firestore document into Doctor object
  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      specialization: data['specialization'] ?? '',
      qualification: data['qualification'] ?? '',
      experience: data['experience'] ?? 0,
      consultationFee: (data['consultationFee'] ?? 0).toDouble(),
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      weeklyAvailability:
          (data['weeklyAvailability'] as Map<String, dynamic>?)?.map(
            (day, slots) =>
                MapEntry(day, Map<String, String>.from(slots as Map)),
          ) ??
          {},
    );
  }

  // Method to convert Doctor object into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'specialization': specialization,
      'qualification': qualification,
      'experience': experience,
      'consultationFee': consultationFee,
      'averageRating': averageRating,
      'imageUrl': imageUrl,
      'weeklyAvailability': weeklyAvailability,
    };
  }
}
