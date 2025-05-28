import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';
import '../screens/reset_password.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String? verificationId; // This should be passed to the widget
  final String phoneNumber;
  final String name;
  final String password;
  final String email;
  final bool isPasswordReset;

  const OTPVerificationScreen({
    super.key,
    required this.verificationId, // Make sure you pass it when calling this widget
    required this.phoneNumber,
    this.name = '',
    this.password = '',
    this.email = '',
    this.isPasswordReset = false, // default false for signup flow
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    try {
      if (widget.verificationId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Verification ID is missing!')));
        return;
      }

      // Step 1: Sign in with phone
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to sign in with OTP')));
        return;
      }
      if (widget.isPasswordReset) {
        // Go to reset password screen with phone
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResetPasswordScreen(phoneNumber: widget.phoneNumber),
          ),
        );
      } else {
        // Step 2: Link dummy email/password to phone user
        try {
          final emailCredential = EmailAuthProvider.credential(
            email: widget.email,
            password: widget.password,
          );
          await user.linkWithCredential(emailCredential);
        } catch (e) {}

        // Step 3: Create patient model and store in Firestore
        final patient = PatientModel(
          pId: user.uid,
          name: widget.name,
          email: widget.email,
          phone: widget.phoneNumber,
          gender: '',
          age: '',
          weight: '',
          dob: null,
          createdAt: Timestamp.now(),
          lastLogin: Timestamp.now(),
          rememberMe: false,
        );

        await FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .set(patient.toJson());

        Fluttertoast.showToast(msg: 'OTP verified and account created!');

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/patient_dashboard',
          arguments: patient,
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFF0A73B7);
    const Color subColor = Color(0xFF00BFA6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            // Top gradient with title
            ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor, subColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Form section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Enter the OTP sent to\n${widget.phoneNumber}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    autoDismissKeyboard: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      activeColor: mainColor,
                      selectedColor: subColor,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade400,
                      inactiveFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onCompleted: (value) {},
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: subColor,
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Resend OTP feature not implemented yet",
                      );
                    },
                    child: Text(
                      "Didn't receive code? Resend",
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 14,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for the curved top
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
