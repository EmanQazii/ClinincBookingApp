import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;

  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      // Reauthenticate if needed (optional if already verified OTP)
      if (user == null) {
        throw FirebaseAuthException(
          message: "User not authenticated",
          code: "user-not-found",
        );
      }

      // Update password in FirebaseAuth
      await user.updatePassword(newPassword);

      // Fetch the patient document from Firestore using UID
      final doc =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        // If document exists, update the password field in Firestore
        await doc.reference.update({'password': newPassword});

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Password reset successful")));

        Navigator.pushReplacementNamed(
          context,
          '/login',
          arguments: 'patient', // Or wherever you want to go
        );
      } else {
        // Document doesn't exist for this user (UID mismatch)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No patient document found")));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An unexpected error occurred")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF0A73B7);
    final Color subColor = const Color(0xFF00BFA6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Reset Password", style: TextStyle(color: mainColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: mainColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: TextStyle(color: mainColor),
                  hintText: 'Enter your new password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ), // Line color when not focused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: subColor),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.length < 6) {
                    return 'Enter min. 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: mainColor),
                  hintText: 'Confirm your new password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ), // Line color when not focused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: subColor),
                  ),
                ),
                validator: (val) {
                  if (val != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: subColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Reset Password",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
