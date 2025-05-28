import 'package:clinic_booking_app/screens/patients_screen/complete_profile.dart';
import 'package:clinic_booking_app/screens/patients_screen/medical_record.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Assuming you have these colors defined in your theme
const Color mainColor = Color(0xFF0A73B7);
const Color subColor = Color(0xFF00BFA6);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  XFile? _image;
  final picker = ImagePicker();
  final Map<String, dynamic> userProfile = {
    'id': "123-456",
    'name': 'Eman Qazi',
    'phone': '+92 3097167600',
    'email': 'emanqazi@example.com',
    'age': 20,
    'gender': 'Female',
    'medicalHistory': ['Diabetes', 'Hypertension'],
    'profilePic': null,
  };
  final Map<String, dynamic> sampleMedicalData = {
    'bloodGroup': 'A+',
    'allergies': 'Peanuts, Penicillin',
    'history': 'Diabetes, Hypertension',
  };

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          userProfile['name'] = doc.data()?['name'] ?? 'No Name';
        });
      } else {
        setState(() {
          userProfile['name'] = 'Unknown';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _image != null
                              ? FileImage(File(_image!.path))
                              : const AssetImage(
                                    'assets/images/default_profile.png',
                                  )
                                  as ImageProvider,
                    ),
                    Positioned(
                      child: InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: subColor,
                          radius: 18,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text(
                  userProfile['name'] ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 20),

            // Tiles Section
            _profileTile(
              icon: FontAwesomeIcons.userPen,
              title: 'Complete / Update Profile',
              subtitle: 'Add or modify contact & personal info',
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              UpdatePersonalInfoScreen(patientId: user.uid),
                    ),
                  );
                }
              },

              color: subColor,
            ),

            _profileTile(
              icon: FontAwesomeIcons.fileMedical,
              title: 'Medical Information and Records',
              subtitle: 'View & Add medical history, Prescriptions, Reports',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => MedicalSectionScreen(
                          medicalData: sampleMedicalData,
                        ),
                  ),
                );
              },
              color: mainColor,
            ),
            _profileTile(
              icon: FontAwesomeIcons.rightFromBracket,
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              onTap: () async {
                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(
                  'remember_me',
                  false,
                ); // Reset the rememberMe flag
                await prefs.remove('saved_email');
                await prefs.remove('saved_password');

                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // Navigate to the login screen after logging out
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                  arguments: 'patient',
                );
              },
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: FaIcon(icon, color: Colors.white, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    ).animate().fadeIn(duration: 400.ms).slideY();
  }
}
