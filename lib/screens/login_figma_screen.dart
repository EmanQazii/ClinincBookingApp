import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool rememberMe = true;
  @override
  Widget build(BuildContext context) {
    final String role = ModalRoute.of(context)!.settings.arguments as String;
    const Color mainColor = Color(0xFF0A73B7);
    const Color subColor = Color(0xFF00BFA6);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            // Top curved gradient shape
            ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A73B7), Color(0xFF00BFA6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 24.0, bottom: 0),
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

            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "Email / Phone No",
                    style: TextStyle(
                      color: mainColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    cursorColor: subColor,
                    decoration: _inputDecoration("example@gmail.com"),
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

                  // Remember Me and Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor:
                                  mainColor, // Border color when unchecked
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.all(
                                  mainColor,
                                ), // Fill when checked
                              ),
                            ),
                            child: Checkbox(
                              value: rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  rememberMe = val ?? false;
                                });
                              },
                            ),
                          ),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          role == 'patient'
                              ? '/patient_dashboard'
                              : '/doctor_dashboard',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: subColor,
                      ),
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Sign up link
                  role == 'patient'
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
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
                          textAlign: TextAlign.center,
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

  static InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  // Widget _socialIcon(String path) {
  //   return CircleAvatar(
  //     radius: 20,
  //     backgroundColor: Colors.white,
  //     child: Image.asset(path, height: 22),
  //   );
  // }
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
