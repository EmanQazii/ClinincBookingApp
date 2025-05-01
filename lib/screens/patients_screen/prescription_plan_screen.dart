import 'package:flutter/material.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  int selectedTab = 0; // 0 - Active, 1 - Doctor Sent, 2 - Completed

  final int newPrescriptionCount = 2; // Example for new prescriptions

  Color get mainColor => const Color(0xFF0A73B7);
  Color get subColor => const Color(0xFF3ABCC0);

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
    // Replace this with actual data
    final bool hasActivePlans = true;
    if (!hasActivePlans) {
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
                color: mainColor.withOpacity(0.1), // Watermark effect
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
      children: [
        _buildDetailedActiveCard(
          title: "Diabetes Plan",
          totalDoses: 10,
          takenDoses: 4,
          durationDays: 5,
          daysPassed: 2,
          medicines: ["Metformin 500mg", "Glibenclamide 5mg"],
        ),
        _buildDetailedActiveCard(
          title: "Antibiotics",
          totalDoses: 15,
          takenDoses: 10,
          durationDays: 7,
          daysPassed: 5,
          medicines: ["Azithromycin 250mg", "Paracetamol 500mg"],
        ),
      ],
    );
  }

  Widget _buildDetailedActiveCard({
    required String title,
    required int totalDoses,
    required int takenDoses,
    required int durationDays,
    required int daysPassed,
    required List<String> medicines,
  }) {
    final int daysLeft = durationDays - daysPassed;

    return StatefulBuilder(
      builder: (context, setState) {
        bool isCompleted = false;

        Map<String, List<bool>> medicineTracker = {
          for (var med in medicines)
            med: List.generate(durationDays, (i) {
              if (i < daysPassed - 1) return true; // taken
              if (i == daysPassed - 1) return false; // missed
              return false; // current or future
            }),
        };

        int calculateTaken() =>
            medicineTracker.values
                .expand((days) => days)
                .where((taken) => taken)
                .length;

        double progress = calculateTaken() / (durationDays * medicines.length);

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
                                value: progress,
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
                                "Duration: $durationDays days ($daysLeft left)",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Doses: ${calculateTaken()} / ${durationDays * medicines.length}",
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
                                        bool isCurrentDay = i == daysPassed;
                                        bool isPastMissed = i == daysPassed - 1;
                                        bool isFuture = i > daysPassed;

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
                                                      isCurrentDay
                                                          ? Border.all(
                                                            color: subColor,
                                                            width: 2,
                                                          )
                                                          : null,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Checkbox(
                                                  value:
                                                      medicineTracker[med]![i],
                                                  onChanged:
                                                      (!isFuture &&
                                                              (isCurrentDay ||
                                                                  isPastMissed))
                                                          ? (_) {
                                                            setState(() {
                                                              medicineTracker[med]![i] =
                                                                  true; // Always mark as checked
                                                            });
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
                        onPressed: () {
                          setState(() {
                            isCompleted = true;
                          });
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
    return Column(
      key: const ValueKey('doctorSent'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPrescriptionCard(
          title: "Dr. Javaid Iqbal - Pain Relief",
          hasFollowButton: true,
          totalDoses: 7,
          takenDoses: 3,
        ),
        _buildPrescriptionCard(
          title: "Dr. Ayesha - Hypertension",
          hasFollowButton: true,
          totalDoses: 10,
          takenDoses: 5,
        ),
      ],
    );
  }

  Widget _buildCompletedPlans() {
    return Column(
      key: const ValueKey('completed'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPrescriptionCard(
          title: "Completed Plan 1",
          isCompleted: true,
          totalDoses: 10,
          takenDoses: 10,
        ),
        _buildPrescriptionCard(
          title: "Completed Plan 2",
          isCompleted: true,
          totalDoses: 8,
          takenDoses: 8,
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard({
    required String title,
    bool isActive = false,
    bool isCompleted = false,
    bool hasFollowButton = false,
    required int totalDoses,
    required int takenDoses,
  }) {
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
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "• Paracetamol 500mg – Twice a day\n• Azithromycin 250mg – Morning",
            ),
            const SizedBox(height: 12),
            const Text(
              "Duration: 7 days",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (hasFollowButton)
              ElevatedButton(
                onPressed: () {
                  // Create plan
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
            if (isActive)
              Text(
                "Progress: $takenDoses/$totalDoses doses taken",
                style: TextStyle(color: Colors.grey),
              ),
            if (isCompleted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Completed",
                        style: TextStyle(
                          color: Color.fromARGB(255, 94, 107, 94),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${completedPercentage.toInt()}%',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
              ),
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
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$newPrescriptionCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
