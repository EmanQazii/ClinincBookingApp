import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF2C7DA0),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset("assets/images/clinic_logo.png", height: 120),
                const SizedBox(height: 10),

                // App Name (Two Lines)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Cure\n",
                        style: TextStyle(
                          fontFamily: "Kavoon",
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "Connect",
                        style: TextStyle(
                          fontFamily: "Kavoon",
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tagline
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Smart HealthCare & \nSeamless doctor appointments,\nAnytime!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.white,
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                // "Continue As" Text
                const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    'Continue as:',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      color: Color(0xFFFAFDFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                CustomButton(
                  text: 'Patient',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/login',
                      arguments: 'patient',
                    );
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: 'Doctor',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login', arguments: 'doctor');
                  },
                ),

                // Clinic Registration Info
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Want to Register Your Clinic/Hospital?\nClick on the link below:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      color: Color(0xFFFAFDFF),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                // Registration Link
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse('https://www.google.com');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text(
                    'Click Here To Register',
                    style: TextStyle(
                      fontFamily: 'Roboto Condensed',
                      color: Colors.cyan,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.cyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Common button widget
}
