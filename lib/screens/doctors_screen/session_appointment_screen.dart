import 'package:flutter/material.dart';
import 'doctor_dashboard.dart';

const Color mainColor = Color(0xFF0A73B7);
const Color subColor = Color(0xFF3ABCC0);

class AppointmentSessionScreen extends StatefulWidget {
  const AppointmentSessionScreen({super.key});

  @override
  State<AppointmentSessionScreen> createState() =>
      _AppointmentSessionScreenState();
}

class _AppointmentSessionScreenState extends State<AppointmentSessionScreen> {
  final List<Widget> _prescriptionCards = [];
  final List<Widget> _labTestCards = [];

  @override
  void initState() {
    super.initState();
    _prescriptionCards.add(_buildPrescriptionCard());
    _labTestCards.add(_buildLabTestCard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Appointment Session',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Patient Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Patient ID: 123-456",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.access_time, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        "4:00pm - 5:00pm",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color.fromARGB(255, 238, 247, 246),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Text(
                          "Age: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("29"),
                        SizedBox(width: 16),
                        Text(
                          "Gender: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Male"),
                        SizedBox(width: 16),
                        Text(
                          "Weight: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("72 kg"),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Existing Conditions: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "None"),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Symptoms: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "Headache, Mild fever"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle("Diagnosis"),
            _modernField(hint: "Description", maxLines: 2),
            const SizedBox(height: 16),
            _sectionTitle("Prescription"),
            _buildPrescriptionSection(),
            const SizedBox(height: 16),
            _sectionTitle("Lab Tests"),
            _buildLabTestSection(),
            const SizedBox(height: 16),
            _sectionTitle("Additional Notes"),
            _modernField(hint: "Add any notes...", maxLines: 2),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DoctorDashboardScreen(),
                      //   ),
                      // );
                    },
                    child: const Text(
                      "Send Prescription",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DoctorDashboardScreen(),
                      //   ),
                      // );
                    },
                    child: const Text(
                      "End Session",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernField({required String hint, int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      cursorColor: subColor,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: subColor, width: 2),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }

  Widget _buildPrescriptionSection() {
    return Column(
      children: [
        ..._prescriptionCards,
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: mainColor),
                icon: const Icon(Icons.delete_outline, color: subColor),
                label: const Text("Delete Prescription"),
                onPressed: () {
                  if (_prescriptionCards.isNotEmpty) {
                    setState(() {
                      _prescriptionCards
                          .removeLast(); // Remove the last added card
                    });
                  }
                },
              ),
              const SizedBox(width: 8),

              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: mainColor),
                icon: const Icon(Icons.add_circle_outline, color: subColor),
                label: const Text("Add Medicine"),
                onPressed: () {
                  setState(() {
                    _prescriptionCards.add(_buildPrescriptionCard());
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _modernField(hint: "Medicine Name")),
              const SizedBox(width: 8),
              Expanded(child: _modernField(hint: "Duration")),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _modernField(hint: "Per Day")),
              const SizedBox(width: 8),
              Expanded(child: _modernField(hint: "Timings")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabTestSection() {
    return Column(
      children: [
        ..._labTestCards,
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: mainColor),
                icon: const Icon(Icons.delete_outline, color: subColor),
                label: const Text("Delete Test"),
                onPressed: () {
                  if (_labTestCards.isNotEmpty) {
                    setState(() {
                      _labTestCards.removeLast();
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: mainColor),
                icon: const Icon(Icons.add_circle_outline, color: subColor),
                label: const Text("Add Test"),
                onPressed: () {
                  setState(() {
                    _labTestCards.add(_buildLabTestCard());
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabTestCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: _modernField(hint: "Test Name")),
          const SizedBox(width: 8),
          Expanded(child: _modernField(hint: "Description")),
        ],
      ),
    );
  }
}
