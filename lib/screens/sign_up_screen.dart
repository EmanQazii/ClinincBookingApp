import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../models/patient_model.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String dummyEmail = "";
  bool passwordVisible = false;

  static const Color mainColor = Color(0xFF0A73B7);
  static const Color subColor = Color(0xFF00BFA6);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
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
                      "Create Your\nAccount",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "Full Name",
                    style: TextStyle(
                      color: mainColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: nameController,
                    cursorColor: subColor,
                    decoration: _inputDecoration("Enter your full name"),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      color: mainColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        child: const Text(
                          "+92",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          cursorColor: subColor,
                          decoration: _inputDecoration("3XXXXXXXXXX"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Password",
                    style: TextStyle(
                      color: mainColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    cursorColor: subColor,
                    decoration: _inputDecoration("Create a password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: subColor,
                      ),
                      child: const Text(
                        "GET OTP CODE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignUp() {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    // Check if the fields are not empty
    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required.");
      return;
    }

    // Check if phone contains only digits and is 10 characters long
    if (!RegExp(r'^\d+$').hasMatch(phone) || phone.length != 10) {
      Fluttertoast.showToast(msg: "Enter a valid 10-digit phone number.");
      return;
    }

    // Concatenate the country code
    String fullPhone = "+92$phone";
    dummyEmail =
        "${fullPhone.replaceAll(RegExp(r'[^\d]'), '')}@cureconnect.com";
    // Call the AuthService to send OTP
    _authService.sendOtp(
      phoneNumber: fullPhone,
      onCodeSent: (verificationId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => OTPVerificationScreen(
                  verificationId: verificationId,
                  phoneNumber: fullPhone,
                  name: name,
                  password: password,
                  email: dummyEmail,
                ),
          ),
        );
      },
      onFailed: (error) {
        Fluttertoast.showToast(msg: "Failed to send OTP: $error");
      },
      onAutoVerified: (user) async {
        final patient = PatientModel(
          name: name,
          email: dummyEmail, // Initially empty unless you collect it
          phone: fullPhone,
          gender: '', // Optionally collect this later
          dob: null, // Collect later or update
          createdAt: Timestamp.now(),
          lastLogin: Timestamp.now(),
          rememberMe: false,
        );

        try {
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(user.uid)
              .set(patient.toJson());

          Navigator.pushReplacementNamed(context, '/patient_dashboard');
        } catch (e) {
          Fluttertoast.showToast(msg: "Failed to save user: $e");
        }
      },
    );
  }

  static InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: subColor, width: 2),
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
