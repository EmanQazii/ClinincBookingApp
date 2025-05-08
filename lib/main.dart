import 'package:clinic_booking_app/screens/doctors_screen/session_appointment_screen.dart';
import 'package:clinic_booking_app/screens/home_screen_flutterflow.dart';
import 'package:clinic_booking_app/screens/otp_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_figma_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/patients_screen/patient_dashboard_screen.dart';
import 'screens/patients_screen/clinic_details_screen.dart';
import 'screens/patients_screen/book_appointment_screen.dart';
import 'screens/doctors_screen/doctor_dashboard.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Cure Connect',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/otp_code_screen': (context) => OTPVerificationScreen(),
        '/patient_dashboard': (context) => PatientDashboard(),
        '/clinic_details': (context) => ClinicDetailScreen(),
        '/book_appointment': (context) => BookAppointmentScreen(),
      },
    );
  }
}
