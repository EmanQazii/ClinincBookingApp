import 'package:flutter/material.dart';
import '/services/prescription_service.dart';
import '/models/patient_model.dart';
import 'package:intl/intl.dart';
import '/models/prescription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/active_plan_model.dart';
import '/services/notification_service.dart';

class PrescriptionScreen extends StatefulWidget {
  final PatientModel patient;
  const PrescriptionScreen({super.key, required this.patient});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  int selectedTab = 0; // 0 - Active, 1 - Doctor Sent, 2 - Completed

  final int newPrescriptionCount = 2; // Example for new prescriptions

  Color get mainColor => const Color(0xFF0A73B7);
  Color get subColor => const Color(0xFF3ABCC0);
  List<Map<String, dynamic>> doctorSentPrescriptions = [];
  List<ActivePlanModel> activePlans = [];
  bool isLoadingActivePlans = true;
  bool isLoading = true;
  final service = PrescriptionService();
  @override
  void initState() {
    super.initState();
    fetchDoctorSentPrescriptions();
    fetchActivePlans();
  }

  Future<void> fetchDoctorSentPrescriptions() async {
    final prescriptions = await service.getPrescriptionsForPatient(
      widget.patient.pId,
    ); // Replace with actual ID
    setState(() {
      doctorSentPrescriptions = prescriptions;
      isLoading = false;
    });
  }

  Future<void> fetchActivePlans() async {
    setState(() {
      isLoadingActivePlans = true;
    });

    final plans = await service.getActivePlansForPatient(widget.patient.pId);

    setState(() {
      activePlans = plans;
      isLoadingActivePlans = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Active Plans', 'Doctor Sent', 'Completed'];

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text(
          'Prescription Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: ToggleButtonsRow(
              mainColor: mainColor,
              selectedTab: selectedTab,
              tabs: tabs,
              newPrescriptionCount: newPrescriptionCount,
              onTap: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildTabContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return _buildActivePlans();
      case 1:
        return _buildDoctorSent();
      case 2:
        return _buildCompletedPlans();
      default:
        return const SizedBox();
    }
  }

  Widget _buildActivePlans() {
    if (isLoadingActivePlans) {
      return Center(child: CircularProgressIndicator(color: mainColor));
    }

    if (activePlans.isEmpty) {
      return Center(
        key: const ValueKey('noActive'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 80,
                color: mainColor.withOpacity(0.1),
              ),
              const SizedBox(height: 24),
              Text(
                'No Active Medication Plans',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Follow a doctor\'s prescription to get started.',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      key: const ValueKey('activeList'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          activePlans.map((plan) {
            NotificationService.showNotification(
              title: 'Medicine Reminder',
              body: 'Dont forget to take ${plan.medicines} today!.',
            );
            return _buildDetailedActiveCard(
              planId: plan.activePlanId,
              patientId: plan.patientId,
              prescriptionId: plan.prescriptionId,
              title: plan.title,
              totalDoses: plan.totalDoses,
              takenDoses: plan.takenDoses,
              durationDays: plan.durationDays,
              daysPassed: plan.daysPassed,
              medicines: plan.medicines,
            );
          }).toList(),
    );
  }

  Widget _buildDetailedActiveCard({
    required String planId,
    required String patientId,
    required String prescriptionId,
    required String title,
    required int totalDoses,
    required int takenDoses,
    required int durationDays,
    required int daysPassed,
    required List<String> medicines,
  }) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .collection('prescriptions')
              .doc(prescriptionId)
              .collection('activePlans')
              .doc(planId)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final int daysPassed = data['daysPassed'] ?? 0;
        final int takenDoses = data['takenDoses'] ?? 0;
        final int totalDoses = data['totalDoses'] ?? 0;
        final int durationDays = data['durationDays'] ?? 0;
        final bool isCompleted = data['isCompleted'] ?? false;

        double progress = takenDoses / totalDoses;
        int daysLeft = durationDays - daysPassed;

        return Opacity(
          opacity: isCompleted ? 0.4 : 1,
          child: IgnorePointer(
            ignoring: isCompleted,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with circular progress
                    Row(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                strokeWidth: 6,
                                backgroundColor: Colors.grey.shade300,
                                color: mainColor,
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: subColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Duration: $durationDays  ($daysLeft left)",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Doses: $takenDoses / $totalDoses",
                                style: TextStyle(color: mainColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),

                    const Text(
                      "Medicines",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Column(
                      children:
                          medicines.map((med) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.medication_outlined,
                                        size: 20,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          med,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(durationDays, (
                                        i,
                                      ) {
                                        final int currentDayIndex = daysPassed;

                                        final bool isChecked =
                                            i < currentDayIndex;
                                        final bool isCurrent =
                                            i == currentDayIndex;
                                        final bool canCheck = isCurrent;
                                        final int frequency =
                                            (totalDoses / durationDays).round();

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Day ${i + 1}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border:
                                                      canCheck
                                                          ? Border.all(
                                                            color: subColor,
                                                            width: 2,
                                                          )
                                                          : null,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Checkbox(
                                                  value: isChecked,
                                                  onChanged:
                                                      canCheck
                                                          ? (_) async {
                                                            await service
                                                                .updateTakenDoses(
                                                                  patientId:
                                                                      patientId,
                                                                  prescriptionId:
                                                                      prescriptionId,
                                                                  activePlanId:
                                                                      planId,
                                                                  frequency:
                                                                      frequency,
                                                                );
                                                          }
                                                          : null,
                                                  activeColor: mainColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await service.markPlanAsCompleted(
                            patientId: patientId,
                            prescriptionId: prescriptionId,
                            activePlanId: planId,
                          );
                        },
                        icon: const Icon(Icons.done, color: Colors.white),
                        label: const Text(
                          "Mark as Complete",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: subColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorSent() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : doctorSentPrescriptions.isEmpty
        ? const Center(child: Text("No prescriptions found."))
        : Column(
          key: const ValueKey('doctorSent'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              doctorSentPrescriptions.map((data) {
                try {
                  final prescription = PrescriptionModel(
                    prescriptionId: data['prescriptionId'] ?? '',
                    doctorId: data['doctorId'] ?? '',
                    doctorName: data['doctorName'] ?? 'Unknown Doctor',
                    specialization: data['specialization'] ?? 'General',
                    clinicId: data['clinicId'] ?? '',
                    clinicName: data['clinicName'] ?? '',
                    appointmentId: data['appointmentId'] ?? '',
                    issuedAt: data['issuedAt'] ?? Timestamp.now(),
                    medicines:
                        data['medicines'] != null
                            ? List<String>.from(data['medicines'])
                            : [],
                    labTests:
                        data['labTests'] != null
                            ? List<String>.from(data['labTests'])
                            : null,
                    diagnosis: data['diagnosis'] ?? null,
                    notes: data['notes'] ?? null,
                    isActive: data['isActive'] ?? false,
                  );
                  NotificationService.showNotification(
                    title: 'New Prescription',
                    body:
                        'Dr. ${prescription.doctorName} has sent you a new prescription.',
                  );
                  return _buildPrescriptionCard(
                    prescription: prescription,
                    isDoctorSent: true,
                  );
                } catch (e) {
                  return const SizedBox();
                }
              }).toList(),
        );
  }

  Widget _buildCompletedPlans() {
    return FutureBuilder<List<ActivePlanModel>>(
      future: PrescriptionService().getCompletedPlansForPatient(
        widget.patient.pId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No completed plans found.'));
        } else {
          final completedPlans = snapshot.data!;

          return Column(
            key: const ValueKey('completed'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                completedPlans.map((plan) {
                  // Find the matching prescription in doctorSentPrescriptions
                  final matchingPrescription = doctorSentPrescriptions
                      .firstWhere(
                        (doc) => doc['prescriptionId'] == plan.prescriptionId,
                        orElse: () => {},
                      );

                  if (matchingPrescription == null) {
                    return const SizedBox(); // Skip if no match found
                  }

                  // Build PrescriptionModel for the card
                  final prescription = PrescriptionModel(
                    appointmentId: matchingPrescription['appointmentId'] ?? "",
                    prescriptionId: plan.prescriptionId,
                    doctorId: matchingPrescription['doctorId'],
                    doctorName: matchingPrescription['doctorName'],
                    specialization: matchingPrescription['specialization'],
                    clinicId: matchingPrescription['clinicId'],
                    clinicName: matchingPrescription['clinicName'],
                    issuedAt: matchingPrescription['issuedAt'],
                    diagnosis: matchingPrescription['diagnosis'],
                    notes: matchingPrescription['notes'],
                    medicines: List<String>.from(plan.medicines),
                    isActive: false, // Since it's completed
                  );

                  return _buildPrescriptionCard(
                    prescription: prescription,
                    isCompleted: true,
                  );
                }).toList(),
          );
        }
      },
    );
  }

  Widget _buildPrescriptionCard({
    required PrescriptionModel prescription,
    bool isDoctorSent = false,
    bool isCompleted = false,
  }) {
    final int totalDoses = 7; // Replace with real logic if needed
    final int takenDoses = 7; // Replace with real logic if needed

    final double completedPercentage = (takenDoses / totalDoses) * 100;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${prescription.doctorName} - ${prescription.diagnosis ?? prescription.specialization}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (prescription.medicines.isNotEmpty)
              ...prescription.medicines.map((med) => Text("• $med")),
            const SizedBox(height: 12),
            Text(
              "Issued on: ${DateFormat.yMMMd().format(prescription.issuedAt.toDate())}",
              style: const TextStyle(color: Colors.grey),
            ),
            if (prescription.notes != null &&
                prescription.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "Notes: ${prescription.notes}",
                style: const TextStyle(color: Colors.black87),
              ),
            ],
            const SizedBox(height: 12),
            if (!prescription.isActive || isDoctorSent)
              ElevatedButton(
                onPressed: () async {
                  try {
                    // 1. Generate Active Plan
                    await PrescriptionService().generateActivePlan(
                      widget.patient.pId,
                      prescription.prescriptionId,
                      prescription,
                    );

                    // 2. Mark Prescription as Active
                    await PrescriptionService().markPrescriptionActive(
                      widget.patient.pId,
                      prescription.prescriptionId,
                    );

                    // 3. Optionally show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Prescription followed successfully!'),
                      ),
                    );

                    // 4. Refresh UI (if needed)
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error following prescription: $e'),
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Follow Prescription",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (isCompleted) ...[
              Text(
                "Progress: Completed",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: completedPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  minHeight: 6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ToggleButtonsRow extends StatelessWidget {
  final int selectedTab;
  final List<String> tabs;
  final Function(int) onTap;
  final int newPrescriptionCount;
  final Color mainColor;

  const ToggleButtonsRow({
    super.key,
    required this.selectedTab,
    required this.tabs,
    required this.onTap,
    required this.newPrescriptionCount,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(tabs.length, (index) {
        final bool isSelected = index == selectedTab;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? mainColor.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? mainColor : Colors.grey.shade300,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (index == 1 && newPrescriptionCount > 0)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        // decoration: BoxDecoration(
                        //   color: mainColor,
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        // child: Text(
                        //   '$newPrescriptionCount',
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ),
                    ),
                  Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? mainColor : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
