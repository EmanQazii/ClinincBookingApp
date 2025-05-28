import 'package:flutter/material.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class ExperienceScreen extends StatelessWidget {
  final int totalYears = 10;
  final int startYear = 2015;

  final Map<String, int> specialties = {"General Practice": 4, "Cardiology": 6};

  final List<String> milestones = [
    "500+ successful diagnoses",
    "Consultant at XYZ Hospital since 2020",
    "Completed 300+ surgeries",
  ];

  ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "Years of Experience",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.timeline,
              title: "Total Years of Experience",
              content: "$totalYears Years",
            ),
            _buildCard(
              icon: Icons.calendar_today,
              title: "Practicing Since",
              content: "$startYear",
            ),
            _buildSpecialtyCard(context),
            // _buildMilestoneCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: subColor, size: 30),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.stacked_bar_chart, color: subColor),
                SizedBox(width: 8),
                Text(
                  "Specialty Breakdown",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...specialties.entries.map((entry) {
              final percentage = entry.value / totalYears;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${entry.key} (${entry.value} years)",
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        width:
                            MediaQuery.of(context).size.width *
                            percentage *
                            0.9,
                        height: 14,
                        decoration: BoxDecoration(
                          color: subColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
