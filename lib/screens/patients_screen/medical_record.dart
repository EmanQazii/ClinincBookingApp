import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF00BFA6);

class MedicalSectionScreen extends StatefulWidget {
  final Map<String, dynamic> medicalData;

  const MedicalSectionScreen({super.key, required this.medicalData});

  @override
  State<MedicalSectionScreen> createState() => _MedicalSectionScreenState();
}

class _MedicalSectionScreenState extends State<MedicalSectionScreen> {
  String selectedRecord = '';
  late TextEditingController bloodController;
  late TextEditingController allergyController;
  late TextEditingController historyController;
  final Map<String, bool> isEditing = {
    'blood': false,
    'allergy': false,
    'history': false,
  };
  bool showDiagnoses = false;

  List<Map<String, String>> diagnoses = [
    {
      'diagnosis': 'Hypertension',
      'doctor': 'Dr. Ayesha Khan',
      'date': '2024-11-01',
      'appointmentId': 'APT3456',
    },
    {
      'diagnosis': 'Type 2 Diabetes',
      'doctor': 'Dr. Raza Ali',
      'date': '2024-12-15',
      'appointmentId': 'APT3480',
    },
  ];
  bool showPrescriptions = false;
  bool showLabReports = false;

  List<Map<String, String>> labReports = [
    {
      'file': 'Blood_Test_Report.pdf',
      'date': '2025-01-15',
      'note': 'Routine check-up blood test',
    },
    {
      'file': 'XRay_Chest.pdf',
      'date': '2025-02-02',
      'note': 'Cough and chest pain investigation',
    },
  ];

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
                _recordButton(
                  Icons.note_alt,
                  'Diagnoses',
                  isActive: selectedRecord == 'Diagnoses',
                  onTap: () {
                    setState(() {
                      selectedRecord =
                          selectedRecord == 'Diagnoses' ? '' : 'Diagnoses';
                      showDiagnoses = !showDiagnoses;
                      showPrescriptions = false;
                    });
                  },
                ),
                _recordButton(
                  Icons.medication,
                  'Prescriptions',
                  isActive: selectedRecord == 'Prescriptions',
                  onTap: () {
                    setState(() {
                      selectedRecord =
                          selectedRecord == 'Prescriptions'
                              ? ''
                              : 'Prescriptions';
                      showPrescriptions = !showPrescriptions;
                      showDiagnoses = false;
                    });
                  },
                ),
                _recordButton(
                  Icons.file_present,
                  'Lab Reports',
                  isActive: selectedRecord == 'Lab Reports',
                  onTap: () {
                    setState(() {
                      selectedRecord =
                          selectedRecord == 'Lab Reports' ? '' : 'Lab Reports';
                      showLabReports = !showLabReports;
                      showDiagnoses = false;
                      showPrescriptions = false;
                    });
                  },
                ),
              ],
            ),

            if (showDiagnoses) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Diagnoses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Wrap the list in a constrained container + scroll view
                  SizedBox(
                    height: 300, // or MediaQuery.of(context).size.height * 0.4
                    child: ListView.builder(
                      itemCount: diagnoses.length,
                      itemBuilder: (context, index) {
                        final diag = diagnoses[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          child: ListTile(
                            tileColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isThreeLine: true,
                            title: Text(
                              diag['diagnosis']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Doctor: ${diag['doctor']}'),
                                Text('Date: ${diag['date']}'),
                                Text(
                                  'Appointment ID: ${diag['appointmentId']}',
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: subColor),
                              onPressed: () {
                                setState(() {
                                  diagnoses.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
            if (showPrescriptions) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Prescriptions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                child: ListTile(
                  tileColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isThreeLine: true,
                  title: Text(
                    'Hypertension',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Prescribed on: 2024-11-01'),
                      SizedBox(height: 6),
                      Text('Amlodipine — 5mg once daily for 30 days'),
                      Text('Lisinopril — 10mg once daily for 30 days'),
                    ],
                  ),
                  trailing: Icon(Icons.delete, color: subColor),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                child: ListTile(
                  tileColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isThreeLine: true,
                  title: Text(
                    'Type 2 Diabetes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Prescribed on: 2024-12-15'),
                      SizedBox(height: 6),
                      Text('Metformin — 500mg twice daily for 60 days'),
                    ],
                  ),
                  trailing: Icon(Icons.delete, color: subColor),
                ),
              ),
            ],
            if (showLabReports) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Lab Reports',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // You can later replace this with file picker logic
                      setState(() {
                        labReports.add({
                          'file': 'New_Lab_Report.pdf',
                          'date': '2025-04-29',
                          'note': 'Manually added test report',
                        });
                      });
                    },
                    icon: Icon(
                      Icons.upload_file,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: labReports.length,
                itemBuilder: (context, index) {
                  final report = labReports[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    child: ListTile(
                      tileColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      title: Text(
                        report['file']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Uploaded on: ${report['date']}'),
                          if (report['note'] != null &&
                              report['note']!.isNotEmpty)
                            Text('Note: ${report['note']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: subColor),
                        onPressed: () {
                          setState(() {
                            labReports.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
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

Widget _recordButton(
  IconData icon,
  String label, {
  required VoidCallback onTap,
  bool isActive = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isActive ? subColor : subColor.withOpacity(0.2),
          child: Icon(
            icon,
            color: isActive ? Colors.white : mainColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isActive ? subColor : mainColor,
          ),
        ),
      ],
    ),
  );
}
