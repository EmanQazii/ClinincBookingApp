import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

const Color mainColor = Color(0xFF2C7DA0);
const Color subColor = Color(0xFF3ABCC0);

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> history = [
    {
      'doctorName': 'Dr. Javaid Iqbal',
      'specialization': 'Cardiologist',
      'clinic': 'City Heart Clinic',
      'date': DateTime(2025, 4, 10),
      'diagnosis': 'Hypertension',
      'prescription': {
        'medicines': [
          {'name': 'Amlodipine', 'dosage': '5mg', 'timing': 'Morning'},
          {'name': 'Losartan', 'dosage': '50mg', 'timing': 'Night'},
        ],
        'notes': 'Monitor blood pressure daily.\nReduce salt intake.',
      },
    },
    {
      'doctorName': 'Dr. Sarah Khan',
      'specialization': 'Dermatologist',
      'clinic': 'Skin Care Center',
      'date': DateTime(2025, 3, 5),
      'diagnosis': 'Acne Vulgaris',
      'prescription': {
        'medicines': [
          {
            'name': 'Acne Cream',
            'dosage': 'Apply thin layer',
            'timing': 'Morning, Evening',
          },
        ],
        'notes': 'Avoid direct sunlight after application.',
      },
    },
  ];

  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('MMMM d, yyyy');

    DateTime getDate(dynamic dateValue) {
      if (dateValue is DateTime) {
        return dateValue;
      } else if (dateValue is String) {
        return dateFormat.parse(dateValue);
      } else {
        throw Exception('Unknown date type: $dateValue');
      }
    }

    final recentAppointments =
        history.where((appt) {
          final parsedDate = getDate(appt['date']);
          return parsedDate.isAfter(now.subtract(const Duration(days: 30)));
        }).toList();

    final pastAppointments =
        history.where((appt) {
          final parsedDate = getDate(appt['date']);
          return parsedDate.isBefore(now.subtract(const Duration(days: 30)));
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Appointment History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: _buildSearchBar()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (recentAppointments.isNotEmpty)
                  _buildSection('Recent Appointments', recentAppointments),
                if (pastAppointments.isNotEmpty)
                  _buildSection('Past Appointments', pastAppointments),
              ],
            ),
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
                hintText: "Search by Doctor, Clinic, Specialization, or Date",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> appointments) {
    final filteredAppointments =
        appointments.where((appointment) {
          return appointment['doctorName'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              appointment['clinic'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              appointment['specialization'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              (appointment['diagnosis'] ?? '').toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              appointment['date'].toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
        }).toList();

    if (filteredAppointments.isEmpty) return const SizedBox.shrink();

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
        ...filteredAppointments.map(
          (appointment) => _buildAppointmentCard(appointment),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final dateFormatted = DateFormat('dd/MM/yyyy').format(appointment['date']);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder:
                (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: DiagnosisDetailScreen(appointment: appointment),
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: subColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.medical_services_rounded, color: mainColor, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment['doctorName'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    appointment['specialization'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    appointment['clinic'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dateFormatted,
                  style: const TextStyle(color: mainColor, fontSize: 13),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: subColor,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Detail Diagnosis Page
class DiagnosisDetailScreen extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const DiagnosisDetailScreen({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    final prescription = appointment['prescription'];
    final String prescriptionText =
        prescription is Map ? _buildPrescriptionText(prescription) : '';

    final List<dynamic> medicines =
        prescription is Map ? prescription['medicines'] ?? [] : [];
    final String notes = prescription is Map ? prescription['notes'] ?? '' : '';

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
            // --- Session Info Card ---
            _sectionCard(
              title: 'Session Information',
              children: [
                _buildDetailTile('Doctor Name', appointment['doctorName']),
                _buildDetailTile(
                  'Specialization',
                  appointment['specialization'],
                ),
                _buildDetailTile('Clinic', appointment['clinic']),
                _buildDetailTile(
                  'Date',
                  '${appointment['date'].day}/${appointment['date'].month}/${appointment['date'].year}',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Diagnosis Info Card ---
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

            /// --- Prescription Info Card ---
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

                    // Table header
                    Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Medicine',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Dosage',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Timing',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Table content
                    ...medicines.map((medicine) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(medicine['name'] ?? ''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(medicine['dosage'] ?? ''),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(medicine['timing'] ?? ''),
                            ),
                          ],
                        ),
                      );
                    }),

                    const Divider(height: 30, thickness: 1),

                    // Notes Section
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
                      notes,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Done Button
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

  /// Helper to create formatted prescription string for copying
  String _buildPrescriptionText(Map prescription) {
    final medicines = prescription['medicines'] as List<dynamic>? ?? [];
    final notes = prescription['notes'] ?? '';

    final buffer = StringBuffer();
    buffer.writeln('Prescription:');
    for (var med in medicines) {
      buffer.writeln('• ${med['name']} - ${med['dosage']} (${med['timing']})');
    }
    buffer.writeln('\nNotes: $notes');
    return buffer.toString();
  }

  // Section Card Wrapper
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

  // Detail Tile
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
}
