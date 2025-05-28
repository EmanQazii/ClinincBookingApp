import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '/models/patient_model.dart';
import 'package:clinic_booking_app/services/appointment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const Color mainColor = Color(0xFF0A73B7);
const Color subColor = Color(0xFF3ABCC0);

class CombinedAppointmentsScreen extends StatefulWidget {
  final PatientModel patient;

  const CombinedAppointmentsScreen({super.key, required this.patient});

  @override
  State<CombinedAppointmentsScreen> createState() =>
      _CombinedAppointmentsScreenState();
}

class _CombinedAppointmentsScreenState
    extends State<CombinedAppointmentsScreen> {
  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _upcomingAppointments = [];
  List<Map<String, dynamic>> _historyAppointments = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final user = FirebaseAuth.instance.currentUser!;

    final upcoming = await AppointmentService.fetchAppointments(
      patientId: user.uid,
      upcoming: true,
    );

    final history = await AppointmentService.fetchAppointments(
      patientId: user.uid,
      upcoming: false,
    );

    setState(() {
      _upcomingAppointments = upcoming;
      _historyAppointments = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    List<Map<String, dynamic>> getRecentAppointments() {
      return _historyAppointments.where((appt) {
        final date = appt['appointmentDate'];
        return date != null &&
            date.isAfter(now.subtract(const Duration(days: 30)));
      }).toList();
    }

    List<Map<String, dynamic>> getPastAppointments() {
      return _historyAppointments.where((appt) {
        final date = appt['appointmentDate'];
        return date != null &&
            date.isBefore(now.subtract(const Duration(days: 30)));
      }).toList();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 2,
          title: const Text(
            'Appointments',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: subColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 3,
            tabs: const [Tab(text: 'Upcoming'), Tab(text: 'History')],
          ),
        ),
        body: TabBarView(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _upcomingAppointments.isEmpty
                ? const Center(
                  child: Text(
                    'No upcoming appointments',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _upcomingAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = _upcomingAppointments[index];
                    return _buildUpcomingCard(appointment, index);
                  },
                ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSearchBar(),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (getRecentAppointments().isNotEmpty)
                        _buildSection(
                          'Recent Appointments',
                          getRecentAppointments(),
                        ),
                      if (getPastAppointments().isNotEmpty)
                        _buildSection(
                          'Past Appointments',
                          getPastAppointments(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, dynamic> appointment, int index) {
    final String appointmentDate =
        appointment['appointmentDate'] != null
            ? DateFormat('dd MMM yyyy').format(appointment['appointmentDate'])
            : '';
    final String appointmentTime = appointment['appointmentTime'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 103, 150, 159),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['doctorName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment['specialization'],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: subColor),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 18,
                color: Color(0xFF2C7DA0),
              ),
              const SizedBox(width: 6),
              Text(
                '$appointmentDate at $appointmentTime',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Color(0xFF2C7DA0)),
              const SizedBox(width: 6),
              Text(
                appointment['clinicName'],
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed:
                    () => _showCallDialog(context, appointment['patientPhone']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.call, size: 18, color: Colors.white),
                label: const Text(
                  'Call',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _showCancelDialog(context, index),
                style: OutlinedButton.styleFrom(
                  foregroundColor: subColor,
                  side: const BorderSide(color: subColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.cancel, size: 18, color: subColor),
                label: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: subColor.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: subColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: const InputDecoration(
                hintText: "Search by Doctor, Clinic, or Diagnosis",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> appointments) {
    final filtered =
        appointments.where((appt) {
          return (appt['doctorName'] ?? '').toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              (appt['clinicName'] ?? '').toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              (appt['specialization'] ?? '').toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              (appt['diagnosis'] ?? '').toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
        }).toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: mainColor,
          ),
        ),
        const SizedBox(height: 12),
        ...filtered.map((appt) => _buildHistoryCard(appt)),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> appointment) {
    final date = DateFormat(
      'dd MMM yyyy',
    ).format(appointment['appointmentDate']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DiagnosisDetailScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BFA6).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment['doctorName'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF0A73B7), // main color
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${appointment['specialization']} • ${appointment['clinicName']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (appointment['diagnosis'] != null)
                Text(
                  'Diagnosis: ${appointment['diagnosis']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Place Call'),
          backgroundColor: Colors.white,
          content: Text('Do you want to call $phoneNumber?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: subColor)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: subColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          backgroundColor: Colors.white,
          content: const Text('Do you really want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No', style: TextStyle(color: subColor)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _upcomingAppointments.removeAt(index);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: subColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class DiagnosisDetailScreen extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const DiagnosisDetailScreen({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    final prescription = appointment['prescription'];
    final List<dynamic> medicines = prescription is List ? prescription : [];
    final String notes = prescription is Map ? prescription['notes'] ?? '' : '';
    final date = DateFormat(
      'dd MMM yyyy',
    ).format(appointment['appointmentDate']);
    final String prescriptionText =
        prescription is Map ? _buildPrescriptionText(prescription) : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: subColor,
        title: const Text(
          'Diagnosis Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Session Information',
              children: [
                _buildDetailTile(
                  'Doctor Name',
                  appointment['doctorName'] ?? 'N/A',
                ),
                _buildDetailTile(
                  'Specialization',
                  appointment['specialization'] ?? 'N/A',
                ),
                _buildDetailTile('Clinic', appointment['clinicName'] ?? 'N/A'),
                _buildDetailTile('Date', date),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              title: 'Diagnosis',
              children: [
                _buildDetailTile(
                  'Diagnosis Summary',
                  appointment['diagnosis'] ?? 'Not Provided',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.medical_services, color: subColor),
                        const SizedBox(width: 8),
                        Text(
                          'Prescription',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.copy, color: subColor),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: prescriptionText),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Prescription copied to clipboard',
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.download_rounded, color: subColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: subColor.withOpacity(0.95),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    'Download Prescription',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    'Do you want to download the prescription?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        generatePdf(appointment);
                                      },
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Medicine',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Duration',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ' /day',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: Text(
                            'Timing',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...medicines.map((medicine) {
                      // Split the string into parts based on commas
                      final parts = medicine.split(',');
                      final name = parts.isNotEmpty ? parts[0] : '';
                      final duration = parts.length > 1 ? parts[1] : '';
                      final perday = parts.length > 2 ? parts[2] : '';
                      final timings = parts.length > 3 ? parts[3] : '';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(name)),
                            Expanded(flex: 3, child: Text(duration)),
                            Expanded(flex: 2, child: Text(perday)),
                            Expanded(flex: 4, child: Text(timings)),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 30, thickness: 1),
                    const Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notes.isNotEmpty ? notes : 'No additional notes.',
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: const Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildPrescriptionText(Map prescription) {
    final medicines = prescription['medicines'] as List<dynamic>? ?? [];
    final notes = prescription['notes'] ?? '';

    final buffer = StringBuffer();
    buffer.writeln('Prescription:');
    for (var med in medicines) {
      // Split each medicine into parts
      final parts = med.split(',');
      final name = parts.isNotEmpty ? parts[0] : '';
      final dosage = parts.length > 1 ? parts[1] : '';
      final timing = parts.length > 2 ? parts[2] : '';
      buffer.writeln('• $name - $dosage ($timing)');
    }
    buffer.writeln('\nNotes: $notes');
    return buffer.toString();
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Future<void> generatePdf(Map<String, dynamic> appointment) async {
    final pdf = pw.Document();
    final date = appointment['appointmentDate'] as DateTime;
    final List<dynamic> medicines =
        (appointment['prescription'] is List)
            ? appointment['prescription']
            : [];
    final String notes =
        (appointment['prescription'] is Map)
            ? appointment['prescription']['notes'] ?? ''
            : '';
    final formattedDate = '${date.day}/${date.month}/${date.year}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Diagnosis Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Doctor: ${appointment['doctorName'] ?? 'N/A'}'),
              pw.Text(
                'Specialization: ${appointment['specialization'] ?? 'N/A'}',
              ),
              pw.Text('Clinic: ${appointment['clinicName'] ?? 'N/A'}'),
              pw.Text('Date: $formattedDate'),
              pw.SizedBox(height: 12),
              pw.Text(
                'Diagnosis:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(appointment['diagnosis'] ?? 'Not Provided'),
              pw.SizedBox(height: 12),
              pw.Text(
                'Prescription:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              if (medicines.isNotEmpty)
                ...medicines.map<pw.Widget>((med) {
                  final parts = med.split(',');
                  final name = parts.isNotEmpty ? parts[0] : '';
                  final duration = parts.length > 1 ? parts[1] : '';
                  final perday = parts.length > 2 ? parts[2] : '';
                  final timing = parts.length > 3 ? parts[3] : '';
                  return pw.Bullet(
                    text:
                        '$name - Duration: $duration, /day: $perday, Timing: $timing',
                  );
                })
              else
                pw.Text('No medicines prescribed.'),
              if (notes.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  'Doctor\'s Notes:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(notes),
              ],
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
