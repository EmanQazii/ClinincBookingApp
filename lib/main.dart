import 'package:clinic_booking_app/screens/home_screen_flutterflow.dart';
import 'package:clinic_booking_app/screens/otp_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_figma_screen.dart';
import 'screens/sign_up_screen.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Cure Connect',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/patient_dashboard': (context) => PatientDashboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/otp_code_screen') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => OTPVerificationScreen(
                  verificationId: args['verificationId'],
                  phoneNumber: args['phoneNumber'],
                ),
          );
        }
        // unknown route
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
      },
    );
  }
}
