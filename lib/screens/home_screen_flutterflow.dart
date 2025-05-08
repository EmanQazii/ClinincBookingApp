import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Curved background
            ClipPath(
              clipper: TopCurveClipper(),
              child: Container(height: 450, color: const Color(0xFF0A73B7)),
            ),

            Positioned(
              top: 240,
              left: 0,
              right: 0,
              child: Image.asset("assets/images/clinic_logo.png", height: 320),
            ),

            // Main Content
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "Cure Connect",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A73B7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Continue as:',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomModernButton(
                    text: 'Patient',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/login',
                        arguments: 'patient',
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomModernButton(
                    text: 'Doctor',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/login',
                        arguments: 'doctor',
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Want to Register Your Clinic/Hospital?\nClick on the link below:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse('https://www.google.com');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: const Text(
                      'Click Here To Register',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0A73B7),
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
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

// Custom modern styled button
class CustomModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomModernButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3ABCC0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
