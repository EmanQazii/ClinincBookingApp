import 'package:flutter/material.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF00BFA6);

class UpdatePersonalInfoScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UpdatePersonalInfoScreen({super.key, required this.userData});

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

  // Control which fields are editable
  Map<String, bool> isEditing = {
    'name': false,
    'phone': false,
    'email': false,
    'age': false,
    'gender': false,
  };

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    phoneController = TextEditingController(text: widget.userData['phone']);
    emailController = TextEditingController(text: widget.userData['email']);
    ageController = TextEditingController(
      text: widget.userData['age'].toString(),
    );
    genderController = TextEditingController(text: widget.userData['gender']);
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

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Patient ID',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.userData['id'].toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    // No edit icon since it's readOnly
                  ],
                ),
              ),
            ),
            _buildEditableTile(
              label: 'Name',
              controller: nameController,
              fieldKey: 'name',
            ),
            _buildEditableTile(
              label: 'Phone Number',
              controller: phoneController,
              fieldKey: 'phone',
            ),
            _buildEditableTile(
              label: 'Email',
              controller: emailController,
              fieldKey: 'email',
            ),
            _buildEditableTile(
              label: 'Age',
              controller: ageController,
              fieldKey: 'age',
            ),
            _buildEditableTile(
              label: 'Gender',
              controller: genderController,
              fieldKey: 'gender',
            ),
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
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Save Changes'),
              onPressed: () {
                // Save logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTile({
    required String label,
    required TextEditingController controller,
    required String fieldKey,
  }) {
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
                  style: TextStyle(color: Colors.white),
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
                    border: UnderlineInputBorder(),
                  ),
                )
                : Text(controller.text, style: TextStyle(color: Colors.white)),
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
