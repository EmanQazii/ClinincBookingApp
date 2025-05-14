import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF00BFA6);

class UpdatePersonalInfoScreen extends StatefulWidget {
  final String patientId;

  const UpdatePersonalInfoScreen({super.key, required this.patientId});

  @override
  State<UpdatePersonalInfoScreen> createState() =>
      _UpdatePersonalInfoScreenState();
}

class _UpdatePersonalInfoScreenState extends State<UpdatePersonalInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController genderController;

  Map<String, bool> isEditing = {
    'name': false,
    'phone': false,
    'email': false,
    'age': false,
    'gender': false,
  };

  bool isLoading = true;
  String patientId = '';
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    patientId = widget.patientId;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .get();

      if (snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>;
        nameController = TextEditingController(text: userData?['name']);
        phoneController = TextEditingController(text: userData?['phone']);
        emailController = TextEditingController(text: userData?['email']);
        ageController = TextEditingController(
          text: userData?['age'].toString(),
        );
        genderController = TextEditingController(text: userData?['gender']);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    ageController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .update({
            'name': nameController.text,
            'phone': phoneController.text,
            'email': emailController.text,
            'age': ageController.text,
            'gender': genderController.text,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile Info',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: subColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: subColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Patient ID',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        patientId,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildEditableTile('Name', nameController, 'name'),
            _buildEditableTile('Phone Number', phoneController, 'phone'),
            _buildEditableTile('Email', emailController, 'email'),
            _buildEditableTile('Age', ageController, 'age'),
            _buildEditableTile('Gender', genderController, 'gender'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: subColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              onPressed: saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTile(
    String label,
    TextEditingController controller,
    String fieldKey,
  ) {
    final isFieldEditing = isEditing[fieldKey] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: mainColor,
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle:
            isFieldEditing
                ? TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller,
                  cursorColor: subColor,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: subColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: subColor, width: 2),
                    ),
                  ),
                )
                : Text(
                  controller.text,
                  style: const TextStyle(color: Colors.white),
                ),
        trailing: IconButton(
          icon: Icon(
            isFieldEditing ? Icons.check_circle : Icons.edit,
            color: isFieldEditing ? const Color(0xFF00B6B8) : Colors.white,
          ),
          onPressed: () {
            setState(() {
              isEditing[fieldKey] = !isEditing[fieldKey]!;
            });
          },
        ),
      ),
    );
  }
}
