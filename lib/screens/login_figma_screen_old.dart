import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final String role = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Color(0xFF2C7DA0),
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
                text: TextSpan(
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
              Text(
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
              Text(
                "Sign in",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Email TextField
              Container(
                decoration: _boxDecoration(),
                child: TextField(
                  decoration: _inputDecoration("Enter your email or phone #"),
                ),
              ),

              const SizedBox(height: 20),

              // Password TextField
              Container(
                decoration: _boxDecoration(),
                child: TextField(
                  obscureText: true,
                  decoration: _inputDecoration("Enter your password"),
                ),
              ),

              const SizedBox(height: 6),

              // Remember Me & Forgot Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      Text(
                        "Remember me",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),

              const SizedBox(height: 9),
              if (role == 'patient') ...[
                TextButton(
                  onPressed: () {},
                  child: Text(
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
                TextButton(
                  onPressed: () {},
                  child: Text(
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

  // Custom Input Decoration for a Soft Look
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: InputBorder.none, // No border for softer look
    );
  }

  // Custom Box Decoration for Elevated Look
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 92, 91, 91),
          blurRadius: 1,
          offset: Offset(0, 0.9),
        ),
      ],
    );
  }
}
