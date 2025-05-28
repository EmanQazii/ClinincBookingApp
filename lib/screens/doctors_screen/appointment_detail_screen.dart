import 'package:flutter/material.dart';
import 'package:clinic_booking_app/models/appointment_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class AppointmentDetailScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> medicines =
        appointment.prescription!.map((item) {
          final parts = item.split(',');
          return {
            'name': parts.isNotEmpty ? parts[0] : '',
            'duration': parts.length > 1 ? parts[1] : '',
            '/day': parts.length > 2 ? parts[2] : '',
            'timings': parts.length > 3 ? parts[3] : '',
          };
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard("Patient Information", Icons.person, [
              buildRow("Name", appointment.patientName),
              const Divider(),
              buildRow("DOB", "March 25, 1990"),
              const Divider(),
              buildRow("Gender", appointment.specialization),
              const Divider(),
              buildRow("Issue", appointment.diagnosis ?? "N/A"),
              const Divider(),
              buildRow("Phone", appointment.patientPhone),
            ]),
            buildCard("Session Information", Icons.schedule, [
              buildRow("Date", appointment.appointmentDate),
              const Divider(),
              buildRow("Time", appointment.appointmentTime),
              const Divider(),
              buildRow("Duration", "1 Hour"),
            ]),
            buildCard("Diagnosis", Icons.medical_services, [
              Text(
                appointment.diagnosis ?? "N/A",
                style: const TextStyle(fontSize: 14),
              ),
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
                  SizedBox(width: 3),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Duration",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "/Day",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Timings",
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
                        Expanded(flex: 3, child: Text(med['duration']!)),
                        Expanded(flex: 2, child: Text(med['/day']!)),
                        Expanded(flex: 4, child: Text(med['timings']!)),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Notes:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(appointment.notes),
            ]),
            buildCard("Tests (if any)", Icons.science, [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  "• ${appointment.labTestsRequested}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: subColor,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(Icons.download, color: Colors.white),
          label: Text(
            "Download Prescription",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _generatePDF(context, medicines),
        ),
      ),
    );
  }

  Widget buildCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: mainColor),
                const SizedBox(width: 9),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _generatePDF(
    BuildContext context,
    List<Map<String, String>> medicines,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Appointment Report',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Patient Name: ${appointment.patientName}'),
              pw.Text('Phone: ${appointment.patientPhone}'),
              pw.Text('Issue: ${appointment.diagnosis ?? "N/A"}'),
              pw.Text('Date: ${appointment.appointmentDate}'),
              pw.Text('Time: ${appointment.appointmentTime}'),
              pw.SizedBox(height: 12),
              pw.Text(
                'Diagnosis:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(appointment.diagnosis ?? "N/A"),
              pw.SizedBox(height: 12),
              pw.Text(
                'Prescription:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Table.fromTextArray(
                context: context,
                cellAlignment: pw.Alignment.centerLeft,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Medicine', 'Duration', '/Day', 'Timings'],
                data:
                    medicines.map((med) {
                      return [
                        med['name'],
                        med['duration'],
                        med['/day'],
                        med['timings'],
                      ];
                    }).toList(),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Notes:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(appointment.notes),
              pw.SizedBox(height: 12),
              pw.Text(
                'Lab Tests:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(appointment.labTestsRequested?.join(', ') ?? 'None'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
