import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/custom_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  late String phoneNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      verificationId = args['verificationId'];
      phoneNumber = args['phoneNumber'];
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter the OTP')));
      return;
    }

    if (otp == "123456") {
      // Dummy OTP matched (simulation)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Successfully signed in !')));
      Navigator.pushNamed(context, '/patient_dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP (dummy check failed)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C7DA0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the OTP sent to\n$phoneNumber",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 50),

              // OTP Input Fields
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  activeFillColor: Colors.white,
                  activeColor: Colors.white,
                  selectedColor: Colors.blue.shade100,
                  selectedFillColor: Colors.white,
                  inactiveColor: Colors.white70,
                  inactiveFillColor: Colors.white24,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: const Color(0xFF2C7DA0),
                enableActiveFill: true,
                onCompleted: (value) {
                  print("Completed: $value");
                },
                onChanged: (value) {},
              ),

              const SizedBox(height: 50),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomButton(onPressed: _verifyOTP, text: "Verify"),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  // You can add re-sending OTP feature here later
                  Fluttertoast.showToast(
                    msg: "Resend OTP feature not implemented yet",
                  );
                },
                child: const Text(
                  "Didn't receive code? Resend",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
