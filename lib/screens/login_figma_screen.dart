import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String role = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: const Color(0xFF2C7DA0),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              Image.asset("assets/images/clinic_logo.png", height: 100),
              const SizedBox(height: 10),

              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Cure\n",
                      style: TextStyle(
                        fontFamily: "Kavoon",
                        fontSize: 43,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "Connect",
                      style: TextStyle(
                        fontFamily: "Kavoon",
                        fontSize: 41,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Welcome Text
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              // Sign In Text
              const Text(
                "Sign in",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Email TextField (Modern Underline)
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Enter your email or phone #"),
              ),

              const SizedBox(height: 20),

              // Password TextField (Modern Underline)
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Enter your password"),
              ),

              const SizedBox(height: 6),

              // Remember Me & Forgot Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      const Text(
                        "Remember me",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (role == 'patient') ...[
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.pushNamed(context, '/patient_dashboard');
                  },
                ),

                const SizedBox(height: 9),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ] else ...[
                CustomButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.pushNamed(context, '/doctor_dashboard');
                  },
                ),
                const SizedBox(height: 9),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Can't Login? Click Here to Contact Support.",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.tealAccent, width: 2),
      ),
    );
  }
}
