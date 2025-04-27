import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7DA0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/clinic_logo.png",
                  height: 100,
                ),
              ),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Phone Number',
                phoneController,
                false,
                "e.g 03XXXXXXXXX (11-digit number)",
                false,
              ),
              _buildTextField(
                'Password',
                passwordController,
                true,
                "Create a password",
                true,
              ),
              const SizedBox(height: 10),
              Center(
                child: CustomButton(
                  text: "Get OTP Code",
                  onPressed: () {
                    String phone = phoneController.text.trim();

                    if (phone.isEmpty ||
                        phone.length != 11 ||
                        !phone.startsWith('03')) {
                      Fluttertoast.showToast(
                        msg:
                            "Please enter a valid 11-digit number starting with 03",
                      );
                      return;
                    }

                    String formattedPhone = "+92${phone.substring(1)}";

                    Navigator.pushNamed(
                      context,
                      '/otp_code_screen',
                      arguments: {
                        'verificationId': 'dummy_verification_id',
                        'phoneNumber': formattedPhone,
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      color: Color(0xFFFAFDFF),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      String phone = phoneController.text.trim();

                      if (phone.isEmpty ||
                          phone.length != 11 ||
                          !phone.startsWith('03')) {
                        Fluttertoast.showToast(
                          msg:
                              "Please enter a valid 11-digit number starting with 03",
                        );
                        return;
                      }

                      String formattedPhone = "+92${phone.substring(1)}";

                      try {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: formattedPhone,
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            Fluttertoast.showToast(
                              msg: "Verification Failed. ${e.message}",
                            );
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            Navigator.pushNamed(
                              context,
                              '/otp_code_screen',
                              arguments: {
                                'verificationId': verificationId,
                                'phoneNumber': formattedPhone,
                              },
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Error: ${e.toString()}");
                      }
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.cyan,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
    String hintText,
    bool showPasswordToggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: isPassword ? !passwordVisible : false,
            style: const TextStyle(color: Colors.white),
            keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent, width: 2),
              ),
              suffixIcon:
                  showPasswordToggle
                      ? IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      )
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}
