import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reviews_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // targetType = 'clinics' or 'doctors'
  Stream<List<Review>> getReviews({
    required String targetType,
    required String targetId,
  }) {
    return _firestore
        .collection(targetType)
        .doc(targetId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
        });
  }

  Future<void> addReview({
    required String targetType,
    required String targetId,
    required Review review,
  }) async {
    await _firestore
        .collection(targetType)
        .doc(targetId)
        .collection('reviews')
        .add(review.toMap());
  }
}
