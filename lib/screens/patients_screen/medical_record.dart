import 'package:flutter/material.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF00BFA6);

class MedicalSectionScreen extends StatefulWidget {
  final Map<String, dynamic> medicalData;

  const MedicalSectionScreen({super.key, required this.medicalData});

  @override
  State<MedicalSectionScreen> createState() => _MedicalSectionScreenState();
}

class _MedicalSectionScreenState extends State<MedicalSectionScreen> {
  late TextEditingController bloodController;
  late TextEditingController allergyController;
  late TextEditingController historyController;
  final Map<String, bool> isEditing = {
    'blood': false,
    'allergy': false,
    'history': false,
  };

  @override
  void initState() {
    super.initState();
    bloodController = TextEditingController(
      text: widget.medicalData['bloodGroup'],
    );
    allergyController = TextEditingController(
      text: widget.medicalData['allergies'],
    );
    historyController = TextEditingController(
      text: widget.medicalData['history'],
    );
  }

  @override
  void dispose() {
    bloodController.dispose();
    allergyController.dispose();
    historyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Medical Info & Records',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: subColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildEditableTile(
              label: 'Blood Group',
              controller: bloodController,
              fieldKey: 'blood',
            ),
            const SizedBox(height: 10),
            _buildEditableTile(
              label: 'Allergies',
              controller: allergyController,
              fieldKey: 'allergy',
            ),

            const SizedBox(height: 10),
            _buildEditableTile(
              label: 'Medical History',
              controller: historyController,
              fieldKey: 'history',
            ),

            const SizedBox(height: 30),
            Text(
              'Medical Records',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 12),

            // Records Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _recordButton(Icons.note_alt, 'Diagnoses'),
                _recordButton(Icons.medication, 'Prescriptions'),
                _recordButton(Icons.file_present, 'Lab Reports'),
              ],
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

Widget _recordButton(IconData icon, String label) {
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: subColor.withOpacity(0.2),
        child: Icon(icon, color: mainColor, size: 28),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w500, color: mainColor),
      ),
    ],
  );
}
