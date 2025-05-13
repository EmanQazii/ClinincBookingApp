import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String patientId;
  final String patientName;
  final String rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.patientId,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      patientId: data['patientId'] ?? '',
      patientName: data['patientName'] ?? '',
      rating: (data['rating'] ?? '0'),
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'rating': rating,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
