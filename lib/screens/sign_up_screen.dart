import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For error messages

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
        child: Padding(
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
              ),
              _buildTextField(
                'Password',
                passwordController,
                true,
                "Create a password",
              ),
              const SizedBox(height: 10),

              Center(
                child: CustomButton(
                  text: "Get OTP Code",
                  onPressed: () {
                    Navigator.pushNamed(context, '/otp_code_screen');
                  },
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
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

                      String formattedPhone =
                          "+92" + phone.substring(1); // Remove 0 and add +92

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
          const SizedBox(height: 6), // Space between label & TextField
          Material(
            elevation: 5, // Elevation effect
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: controller,
              obscureText: isPassword ? !passwordVisible : false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
                hintText: hintText,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon:
                    isPassword
                        ? IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(
                                () => passwordVisible = !passwordVisible,
                              ),
                        )
                        : null,
              ),
              keyboardType:
                  isPassword ? TextInputType.text : TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }
}
