import 'package:firebase_auth/firebase_auth.dart';
// Import your model
import 'patient_service.dart'; // Firestore CRUD handler

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;

  // Helper: Convert phone to a dummy email
  String _phoneToEmail(String phone) {
    return '${phone.replaceAll('+', '')}@cureconnect.com';
  }

  /// Send OTP to given phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
    required Function(User user) onAutoVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);
          onAutoVerified(result.user!);
        },
        verificationFailed: (FirebaseAuthException e) {
          onFailed(e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onFailed("Something went wrong: $e");
    }
  }

  /// Verify OTP manually
  Future<User?> verifyOtp({
    required String smsCode,
    required Function(String error) onError,
  }) async {
    try {
      if (_verificationId == null) {
        onError("Verification ID is null. Try again.");
        return null;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      onError("Invalid OTP: $e");
      return null;
    }
  }

  /// Simple wrapper for email-password login
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      return null;
    }
  }

  User? getCurrentUser() => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
