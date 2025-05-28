import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/patient_service.dart';
import 'otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clinic_booking_app/services/doctor_service.dart';
import 'doctors_screen/doctor_dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool rememberMe = true;
  final Color mainColor = const Color(0xFF0A73B7);
  final Color subColor = const Color(0xFF00BFA6);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLogin(String role) async {
    setState(() => _isLoading = true); // Start loading
    String? input = _emailOrPhoneController.text.trim();
    if (input.startsWith('0') && input.length == 11) {
      input = '+92${input.substring(1)}';
    }
    final password = _passwordController.text.trim();

    if (input.isEmpty || password.isEmpty) {
      _showMessage("Please enter both fields");
      setState(() => _isLoading = false); // Stop loading
      return;
    }

    late String email;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(input)) {
      email = input;
    } else {
      final cleanedPhone = input.replaceAll(RegExp(r'[^\d]'), '');
      email = '$cleanedPhone@cureconnect.com';
    }

    try {
      if (role == 'patient') {
        final user = await AuthService().signInWithEmailAndPassword(
          email,
          password,
        );
        if (user == null) {
          _showMessage("No user found for this credential");
          setState(() => _isLoading = false);
          return;
        }

        final patient = await PatientService().getPatientByEmail(email);
        if (patient == null) {
          _showMessage("No patient data found");
          setState(() => _isLoading = false);
          return;
        }
        // Add this part here:
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await FirebaseFirestore.instance
              .collection("patients")
              .doc(patient.pId)
              .update({'fcmToken': fcmToken});
        }

        Navigator.pushNamed(context, '/patient_dashboard', arguments: patient);
      } else if (role == 'doctor') {
        final result = await DoctorService().getDoctorByCredentials(
          email,
          password,
        );
        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DoctorDashboardScreen(
                    doctor: result.doctor,
                    clinicId: result.clinicId,
                  ),
            ),
          );
        } else {
          _showMessage('Invalid credentials');
        }
      }
    } catch (e) {
      _showMessage("Login failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // Stop loading
      }
    }
  }

  // try {
  //       final user = await AuthService().signInWithEmailAndPassword(
  //         email,
  //         password,
  //       );
  //       final patient = await PatientService().getPatientByEmail(email);

  //       if (user == null) {
  //         _showMessage("No user found for this credential");
  //         return;
  //       }

  //       if (rememberMe) {
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('saved_email', input);
  //         await prefs.setString('saved_password', password);
  //         await prefs.setBool('remember_me', true);
  //       }

  //       Navigator.pushNamed(
  //         context,
  //         role == 'patient' ? '/patient_dashboard' : '/appointment_session',
  //         arguments: patient,
  //       );
  //     } catch (e) {
  //       _showMessage("Login failed: ${e.toString()}");
  //     }
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showForgotPasswordDialog() {
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white, // Dialog background color
            title: Text(
              "Reset Password",
              style: TextStyle(color: mainColor), // Title color
            ),
            content: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter your phone number",
                prefixText: '+92 ',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mainColor,
                  ), // Line color when not focused
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: subColor),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final phone = "+92${phoneController.text.trim()}";

                  FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phone,
                    timeout: const Duration(seconds: 60),
                    verificationCompleted: (PhoneAuthCredential credential) {
                      // Auto-sign in not required here for password reset
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      // Handle error
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OTPVerificationScreen(
                                verificationId: verificationId,
                                phoneNumber: phone,
                                isPasswordReset: true,
                              ),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      // Optional timeout handling
                    },
                  );
                },
                child: Text(
                  "Send OTP",
                  style: TextStyle(color: mainColor), // Button text color
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String role = ModalRoute.of(context)!.settings.arguments as String;

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
                decoration: BoxDecoration(
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
                      "Hello\nSign in!",
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
                  Text("Email / Phone No", style: TextStyle(color: mainColor)),
                  const SizedBox(height: 3),
                  TextField(
                    controller: _emailOrPhoneController,
                    cursorColor: subColor,
                    decoration: _inputDecoration("Enter Phone # or Email"),
                  ),
                  const SizedBox(height: 20),
                  Text("Password", style: TextStyle(color: mainColor)),
                  const SizedBox(height: 3),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    cursorColor: subColor,
                    decoration: _inputDecoration(
                      "Enter your password",
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: subColor,
                            value: rememberMe,
                            onChanged: (val) {
                              setState(() {
                                rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog();
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => _handleLogin(role),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: subColor,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2.5,
                                ),
                              )
                              : const Text(
                                "SIGN IN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  role == 'patient'
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(context, '/signup'),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                      : Center(
                        child: Text(
                          "Can't login? Contact support.",
                          style: TextStyle(
                            color: mainColor,
                            fontStyle: FontStyle.italic,
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
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
