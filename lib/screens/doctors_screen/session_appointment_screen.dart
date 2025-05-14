import 'package:flutter/material.dart';
import '/models/appointment_model.dart';
import '/services/patient_service.dart';
import '/models/patient_model.dart';
import '/models/doctor_model.dart';
import '/services/appointment_service.dart';
import '../doctors_screen/doctor_dashboard.dart';

const Color mainColor = Color(0xFF0A73B7);
const Color subColor = Color(0xFF3ABCC0);

class AppointmentSessionScreen extends StatefulWidget {
  final AppointmentModel appointment;
  final Doctor doctor;

  const AppointmentSessionScreen({
    super.key,
    required this.doctor,
    required this.appointment,
  });

  @override
  State<AppointmentSessionScreen> createState() =>
      _AppointmentSessionScreenState();
}

class _AppointmentSessionScreenState extends State<AppointmentSessionScreen> {
  final PatientService _patientService = PatientService();
  PatientModel? _patient;
  bool _isLoadingPatient = true;

  // Controllers for prescriptions and lab tests
  List<Map<String, TextEditingController>> _prescriptionControllers = [];
  List<Map<String, TextEditingController>> _labTestControllers = [];
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
    _addPrescriptionCard();
    _addLabTestCard();
  }

  void _fetchPatientData() async {
    final patient = await _patientService.getPatientById(
      widget.appointment.patientId,
    );
    setState(() {
      _patient = patient;
      _isLoadingPatient = false;
    });
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    for (var ctrlMap in _prescriptionControllers) {
      ctrlMap.values.forEach((controller) => controller.dispose());
    }
    for (var ctrlMap in _labTestControllers) {
      ctrlMap.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  void _addPrescriptionCard() {
    final newPrescription = {
      'name': TextEditingController(),
      'duration': TextEditingController(),
      'perDay': TextEditingController(),
      'timing': TextEditingController(),
    };
    setState(() {
      _prescriptionControllers.add(newPrescription);
    });
  }

  void _addLabTestCard() {
    final newLabTest = {
      'name': TextEditingController(),
      'description': TextEditingController(),
    };
    setState(() {
      _labTestControllers.add(newLabTest);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final doctor = widget.doctor;
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
                  Text(
                    appointment.patientName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        appointment.appointmentTime,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _isLoadingPatient
                ? const Center(child: CircularProgressIndicator())
                : Card(
                  color: const Color.fromARGB(255, 238, 247, 246),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Age: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_patient?.age ?? "N/A"),
                            SizedBox(width: 16),
                            Text(
                              "Gender: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_patient?.gender ?? "N/A"),
                            SizedBox(width: 18),
                            Text(
                              "Weight: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_patient?.weight ?? "N/A"),
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
            _modernField(
              hint: "Description",
              maxLines: 2,
              controller: _diagnosisController,
            ),
            const SizedBox(height: 16),
            _sectionTitle("Prescription"),
            _buildPrescriptionSection(),
            const SizedBox(height: 16),
            _sectionTitle("Lab Tests"),
            _buildLabTestSection(),
            const SizedBox(height: 16),
            _sectionTitle("Additional Notes"),
            _modernField(
              hint: "Add any notes...",
              maxLines: 2,
              controller: _notesController,
            ),
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
                      // Call function to handle form submission
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
                    onPressed: () async {
                      await _saveData();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DoctorDashboardScreen(
                                doctor: doctor,
                                clinicId: appointment.clinicId,
                              ),
                        ),
                      );
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

  Widget _modernField({
    required String hint,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
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
        ..._prescriptionControllers.map(
          (controllers) => _buildPrescriptionCard(controllers),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: mainColor),
                icon: const Icon(Icons.delete_outline, color: subColor),
                label: const Text("Delete Prescription"),
                onPressed: () {
                  if (_prescriptionControllers.isNotEmpty) {
                    setState(() {
                      _prescriptionControllers.removeLast();
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
                    _addPrescriptionCard();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard(
    Map<String, TextEditingController> controllers,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _modernField(
                  hint: "Medicine Name",
                  controller: controllers['name'],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _modernField(
                  hint: "Duration",
                  controller: controllers['duration'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _modernField(
                  hint: "Per Day",
                  controller: controllers['perDay'],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _modernField(
                  hint: "Timings",
                  controller: controllers['timing'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabTestSection() {
    return Column(
      children: [
        ..._labTestControllers.map(
          (controllers) => _buildLabTestCard(controllers),
        ),
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
                  if (_labTestControllers.isNotEmpty) {
                    setState(() {
                      _labTestControllers.removeLast();
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
                    _addLabTestCard();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabTestCard(Map<String, TextEditingController> controllers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: _modernField(
              hint: "Test Name",
              controller: controllers['name'],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _modernField(
              hint: "Description",
              controller: controllers['description'],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveData() async {
    List<String> prescriptions =
        _prescriptionControllers.map((controllers) {
          return "${controllers['name']!.text},${controllers['duration']!.text},${controllers['perDay']!.text},${controllers['timing']!.text}";
        }).toList();

    List<String> labTests =
        _labTestControllers.map((controllers) {
          return "${controllers['name']!.text},${controllers['description']!.text}";
        }).toList();

    String diagnosis = _diagnosisController.text;
    String notes = _notesController.text;

    try {
      await AppointmentService.updateDiagnosisAndPrescription(
        clinicId: widget.appointment.clinicId,
        doctorId: widget.appointment.doctorId,
        patientId: widget.appointment.patientId,
        appointmentId: widget.appointment.appointmentId,
        diagnosis: diagnosis,
        prescription: prescriptions,
        labTestsRequested: labTests,
        notes: notes,
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send data: $error")));
    }
  }
}
