import 'package:clinic_booking_app/screens/home_screen_flutterflow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_figma_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/patients_screen/patient_dashboard_screen.dart';
import 'screens/patients_screen/clinic_details_screen.dart';
import 'screens/patients_screen/search_result_screen.dart';
import 'package:clinic_booking_app/models/patient_model.dart';
import 'screens/patient_loader.dart';
import 'package:clinic_booking_app/models/clinic_model.dart';
import 'screens/doctors_screen/doctor_dashboard.dart';
import 'package:clinic_booking_app/models/doctor_model.dart';
import 'package:clinic_booking_app/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init(); // Custom service (explained below)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background messages here
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cure Connect',
      theme: ThemeData(primarySwatch: Colors.teal),
      onGenerateRoute: (settings) {
        if (settings.name == '/patient_loader') {
          final uid = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => PatientLoaderScreen(uid: uid),
          );
        }
        if (settings.name == '/patient_dashboard') {
          final patient = settings.arguments as PatientModel;
          return MaterialPageRoute(
            builder: (context) => PatientDashboard(patient: patient),
          );
        }
        if (settings.name == '/clinic_details') {
          final clinic = settings.arguments as Clinic;
          return MaterialPageRoute(
            builder: (context) => ClinicDetailScreen(clinic: clinic),
          );
        }
        if (settings.name == '/doctor_dashboard') {
          final doctor = settings.arguments as Doctor;
          final clinicId = settings.arguments as String;
          return MaterialPageRoute(
            builder:
                (context) =>
                    DoctorDashboardScreen(doctor: doctor, clinicId: clinicId),
          );
        }

        // Add other route conditions if needed
        return null;
      },
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/search_results': (context) => SearchResultsScreen(),
        //'/doctor_dashboard': (context) => DoctorDashboardScreen(),
      },
    );
  }
}
