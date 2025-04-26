import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C7DA0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Center(
              child: Image.asset("assets/images/clinicLogo.png", height: 200),
            ),
            SizedBox(height: 10),

            //App Name
            Text(
              "Cure Connect",
              style: TextStyle(
                fontFamily: "Kavoon",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),

            // 👋 Welcome Text
            Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            _buildTextField("Enter your email or phone #"),
            SizedBox(height: 15),

            // 🔑 Password Field
            _buildTextField("Enter your password", obscureText: true),
            SizedBox(height: 10),

            // ✅ Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    Text("Remember me", style: TextStyle(color: Colors.white)),
                  ],
                ),
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 🔵 Login Button
            _buildButton("Login", Colors.teal.shade300),
            SizedBox(height: 15),

            // 🔗 "Or Continue with Google"
            Text("or", style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            _buildGoogleButton(),
            SizedBox(height: 20),

            // 🔹 Signup Link
            Text(
              "Don't have an account?",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            _buildButton("Sign Up", Colors.teal.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  // 📌 Custom Button Widget
  Widget _buildButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {},
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  // 📌 Google Sign-In Button
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: BorderSide(color: Colors.white),
        ),
        icon: Image.asset(
          "assets/images/google.png",
          height: 24,
        ), // Add Google Icon
        label: Text(
          "Continue with Google",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
    );
  }
}
