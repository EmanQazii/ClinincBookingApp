import 'package:clinic_booking_app/screens/home_screen_flutterflow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_figma_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/patient_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      title: 'Cure Connect',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Adjust theme if needed
      ),
      initialRoute: '/home', // Set LoginScreen as the first screen
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/patient_dashboard': (context) => PatientDashboardScreen(),
      },
    );
  }
}
