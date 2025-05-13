import 'package:cloud_firestore/cloud_firestore.dart';

class Clinic {
  final String id;
  final String name;
  final String image;
  final String location;
  final String phone;
  final GeoPoint mapLocation;
  final Map<String, String> hours;
  final double rating;
  final int totalReviews;
  final String description;

  Clinic({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.phone,
    required this.mapLocation,
    required this.hours,
    required this.rating,
    required this.totalReviews,
    required this.description,
  });

  factory Clinic.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Clinic(
      id: doc.id,
      name: data['name'],
      image: data['image'],
      location: data['location'],
      phone: data['phone'],
      mapLocation: data['mapLocation'],
      hours: Map<String, String>.from(data['hours']),
      rating: data['rating'],
      totalReviews: data['totalReviews'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'location': location,
      'phone': phone,
      'mapLocation': mapLocation,
      'hours': hours,
      'rating': rating,
      'totalReviews': totalReviews,
      'description': description,
    };
  }
}
