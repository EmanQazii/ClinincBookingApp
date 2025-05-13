import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinic_booking_app/screens/doctors_screen/appointment_record_screen.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({Key? key, required this.appointment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMEEEEd().format(appointment.date);
    String formattedTime = DateFormat.jm().format(
      DateFormat("HH:mm").parse(appointment.time),
    );

    // Dummy data
    final List<Map<String, String>> medicines = [
      {'name': 'Amoxicillin', 'dosage': '500mg', 'timing': '3 times a day'},
      {
        'name': 'Cough Syrup',
        'dosage': '10ml',
        'timing': '2 times a day after meals',
      },
    ];
    final String notes =
        'Plenty of fluids and rest recommended. Return in 1 week if symptoms persist.';

    final diagnosis =
        "Acute Bronchitis – inflammation of bronchial tubes with cough and wheezing.";
    final List tests = ['Chest X-Ray', 'CBC (Complete Blood Count)'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard("Patient Information", Icons.person, [
              buildRow("Name", appointment.name),
              Divider(),
              buildRow("DOB", "March 25, 1990"),
              Divider(),
              buildRow("Gender", appointment.gender),
              Divider(),
              buildRow("Issue", appointment.issue),
              Divider(),
              buildRow("Type", appointment.type),
            ]),

            buildCard("Session Information", Icons.schedule, [
              buildRow("Date", formattedDate),
              Divider(),
              buildRow("Time", formattedTime),
              Divider(),
              buildRow("Duration", "1 Hour"),
            ]),
            buildCard("Diagnosis", Icons.medical_services, [
              Text(diagnosis, style: TextStyle(fontSize: 14)),
            ]),
            buildCard("Prescription", Icons.description, [
              Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Medicine",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Dosage",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Timing",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 1),
              ...medicines.map(
                (med) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 3, child: Text(med['name']!)),
                        Expanded(flex: 2, child: Text(med['dosage']!)),
                        Expanded(flex: 3, child: Text(med['timing']!)),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text("Notes:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(notes),
            ]),
            buildCard("Tests (if any)", Icons.science, [
              for (var test in tests)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text("• $test", style: TextStyle(fontSize: 14)),
                ),
            ]),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: ElevatedButton.icon(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: subColor,
      //       padding: EdgeInsets.symmetric(vertical: 14),
      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //     ),
      //     icon: Icon(Icons.edit),
      //     label: Text("Edit Record"),
      //     onPressed: () {
      //       // Handle edit
      //       Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorDashboardScreen()));
      //     },
      //   ),
      // ),
    );
  }

  Widget buildCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: mainColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
