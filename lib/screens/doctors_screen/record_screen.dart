import 'package:flutter/material.dart';
import 'package:clinic_booking_app/screens/doctors_screen/patient_record_detail.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final List<Map<String, dynamic>> allPatients = [
    {
      "name": "Ayesha Khan",
      "age": 29,
      "dob": "1996-05-12",
      "bloodType": "A+",
      "allergies": ["Penicillin", "Dust"],
      "gender": "Female",
    },
    {
      "name": "Hamza Ahmed",
      "age": 41,
      "dob": "1983-07-02",
      "bloodType": "O-",
      "allergies": [],
      "gender": "Female",
    },
    {
      "name": "Fatima Noor",
      "age": 35,
      "dob": "1989-03-10",
      "bloodType": "B+",
      "allergies": ["Pollen"],
      "gender": "Male",
    },
  ];

  List<Map<String, dynamic>> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    filteredPatients = allPatients;
  }

  void _filterPatients(String query) {
    final filtered =
        allPatients.where((patient) {
          final nameLower = patient['name'].toLowerCase();
          return nameLower.contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredPatients = filtered;
    });
  }

  Widget _buildInfoRow(IconData icon, String label, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? mainColor),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Patients",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _filterPatients,
              decoration: InputDecoration(
                hintText: 'Search patient name...',
                prefixIcon: const Icon(Icons.search, color: mainColor),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                DiagnosisDetailScreen(patient: patient),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient['name'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            Icons.calendar_today,
                            "DOB: ${patient['dob']}",
                          ),
                          const SizedBox(height: 6),
                          _buildInfoRow(
                            Icons.person,
                            "Gender: ${patient['gender']}",
                          ),
                          const SizedBox(height: 6),
                          _buildInfoRow(Icons.cake, "Age: ${patient['age']}"),
                          const SizedBox(height: 6),
                          _buildInfoRow(
                            Icons.opacity,
                            "Blood Type: ${patient['bloodType']}",
                          ),
                          const SizedBox(height: 6),
                          _buildInfoRow(
                            Icons.warning,
                            "Allergies: ${(patient['allergies'] as List).isEmpty ? 'None' : (patient['allergies'] as List).join(', ')}",
                            iconColor: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
