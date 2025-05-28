import 'package:flutter/material.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class DiagnosisDetailScreen extends StatefulWidget {
  final Map<String, dynamic> patient;

  const DiagnosisDetailScreen({super.key, required this.patient});

  @override
  State<DiagnosisDetailScreen> createState() => _DiagnosisDetailScreenState();
}

class _DiagnosisDetailScreenState extends State<DiagnosisDetailScreen> {
  bool showAllDiagnoses = false;
  bool showAllPrescriptions = false;
  bool showAllTests = false;

  List<Map<String, dynamic>> _getDummyDiagnoses(String name) {
    switch (name) {
      case 'Ayesha Khan':
        return [
          {"date": "2022-05-20", "diagnosis": "Stroke"},
          {"date": "2023-07-15", "diagnosis": "High Blood Pressure"},
          {"date": "2023-10-10", "diagnosis": "Diabetes Type 2"},
          {"date": "2024-02-01", "diagnosis": "Heart Disease"},
        ];
      case 'Fatima Noor':
        return [
          {"date": "2023-09-14", "diagnosis": "High Cholesterol"},
          {"date": "2023-11-25", "diagnosis": "Osteoarthritis"},
          {"date": "2024-01-20", "diagnosis": "Hypertension"},
        ];
      case 'Hamza Ahmed':
        return [
          {"date": "2024-01-05", "diagnosis": "Arrhythmia"},
          {"date": "2024-02-10", "diagnosis": "Atrial Fibrillation"},
          {"date": "2024-03-15", "diagnosis": "Cardiomyopathy"},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getDummyPrescriptions(String name) {
    switch (name) {
      case 'Ayesha Khan':
        return [
          {
            "date": "2022-05-20",
            "medicines": [
              {"name": "Aspirin", "dosage": "75mg", "timing": "Morning"},
              {"name": "Statin", "dosage": "10mg", "timing": "Evening"},
            ],
            "notes": "Avoid fatty foods and get weekly BP checks.",
          },
          {
            "date": "2023-07-15",
            "medicines": [
              {"name": "Lisinopril", "dosage": "5mg", "timing": "Morning"},
            ],
            "notes": "Monitor blood pressure daily.",
          },
        ];
      case 'Fatima Noor':
        return [
          {
            "date": "2023-09-14",
            "medicines": [
              {"name": "Atorvastatin", "dosage": "20mg", "timing": "Night"},
            ],
            "notes": "Maintain cholesterol-friendly diet.",
          },
        ];
      case 'Hamza Ahmed':
        return [
          {
            "date": "2024-01-05",
            "medicines": [
              {
                "name": "Metoprolol",
                "dosage": "50mg",
                "timing": "Morning and Night",
              },
            ],
            "notes": "Monitor heart rate and avoid caffeine.",
          },
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getDummyTests(String name) {
    switch (name) {
      case 'Ayesha Khan':
        return [
          {"name": "CT Scan", "date": "2022-05-21"},
          {"name": "Blood Test", "date": "2023-07-15"},
        ];
      case 'Fatima Noor':
        return [
          {"name": "Lipid Profile", "date": "2023-09-15"},
        ];
      case 'Hamza Ahmed':
        return [
          {"name": "ECG", "date": "2024-01-06"},
          {"name": "Holter Monitor", "date": "2024-01-08"},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;
    final name = patient['name'];
    final diagnoses = _getDummyDiagnoses(name);
    final prescriptions = _getDummyPrescriptions(name);
    final tests = _getDummyTests(name);
    final allergies = patient['allergies'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$name's History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Personal Info
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person, color: subColor),
                        SizedBox(width: 8),
                        Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text("Age: ${patient['age']}"),
                    Text("DOB: ${patient['dob']}"),
                    Text("Gender: ${patient['gender']}"),
                    Text("Blood Type: ${patient['bloodType']}"),
                    Text("Allergies: ${allergies.join(', ')}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Diagnosis
            _buildCardSection(
              icon: Icons.coronavirus,
              title: "Diagnoses",
              color: Colors.redAccent,
              items:
                  diagnoses
                      .map(
                        (d) => ListTile(
                          title: Text(d['diagnosis']),
                          subtitle: Text("Date: ${d['date']}"),
                        ),
                      )
                      .toList(),
              expanded: showAllDiagnoses,
              toggleExpanded: () {
                setState(() => showAllDiagnoses = !showAllDiagnoses);
              },
              maxItems: 1,
            ),

            // Prescriptions
            _buildCardSection(
              icon: Icons.medication,
              title: "Prescriptions",
              color: Colors.blueAccent,
              items:
                  prescriptions.map((p) {
                    final List meds = p['medicines'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${p['date']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        ...meds.map(
                          (m) => Text(
                            "- ${m['name']} (${m['dosage']}, ${m['timing']})",
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Notes: ${p['notes']}"),
                      ],
                    );
                  }).toList(),
              expanded: showAllPrescriptions,
              toggleExpanded: () {
                setState(() => showAllPrescriptions = !showAllPrescriptions);
              },
              maxItems: 1,
            ),

            // Tests Done
            _buildCardSection(
              icon: Icons.biotech,
              title: "Tests Done",
              color: Colors.green,
              items:
                  tests
                      .map(
                        (t) => ListTile(
                          title: Text(t['name']),
                          subtitle: Text("Date: ${t['date']}"),
                        ),
                      )
                      .toList(),
              expanded: showAllTests,
              toggleExpanded: () {
                setState(() => showAllTests = !showAllTests);
              },
              maxItems: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection({
    required IconData icon,
    required String title,
    required List<Widget> items,
    required bool expanded,
    required VoidCallback toggleExpanded,
    required int maxItems,
    required Color color,
  }) {
    final displayItems = expanded ? items : items.take(maxItems).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            ...displayItems.expand((item) => [item, const Divider()]),
            if (items.length > maxItems)
              TextButton(
                onPressed: toggleExpanded,
                child: Text(expanded ? "View Less" : "View More"),
              ),
          ],
        ),
      ),
    );
  }
}
