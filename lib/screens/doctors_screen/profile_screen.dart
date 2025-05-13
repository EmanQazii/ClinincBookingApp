import 'package:flutter/material.dart';
import 'experience_screen.dart';
// import 'license_detail_screen.dart';
import 'affiliation_screen.dart';
import 'doctor_review_screen.dart';
//import 'education_screen.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class DoctorProfile extends StatelessWidget {
  final Map<String, dynamic> doctorData = {
    'name': 'Dr. Ali Khan',
    'gender': 'Male',
    'specialization': 'Cardiologist',
    'qualification': 'MBBS, FCPS',
    'experience': 10,
    'consultationFee': 1500,
    'averageRating': 4.5,
    'weeklyAvailability': {
      'Monday': {'start': '09:00', 'end': '17:00'},
      'Wednesday': {'start': '10:00', 'end': '16:00'},
      'Friday': {'start': '09:00', 'end': '13:00'},
    },
    'imageUrl': 'assets/images/doctor.jpg',
    'email': 'alikhan@clinic.com',
    'phone': '+92 300 1234567',
  };

  final List<Map<String, dynamic>> reviews = [
    {
      'patientId': 'user789',
      'patientName': 'Sara Khan',
      'rating': 5,
      'comment': 'Highly recommend this doctor.',
      'timestamp': DateTime.now(),
    },
    {
      'patientId': 'user456',
      'patientName': 'Ahmed Ali',
      'rating': 4,
      'comment': 'Very attentive and knowledgeable.',
      'timestamp': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'patientId': 'user123',
      'patientName': 'Zainab Malik',
      'rating': 5,
      'comment': 'Excellent consultation and care.',
      'timestamp': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'patientId': 'user321',
      'patientName': 'Usman Tariq',
      'rating': 3,
      'comment': 'Good, but the wait time was long.',
      'timestamp': DateTime.now().subtract(Duration(days: 3)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    double rating = doctorData['averageRating'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "Doctor Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(doctorData['imageUrl']),
            ),
            SizedBox(height: 12),
            Text(
              doctorData['name'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              doctorData['specialization'],
              style: TextStyle(fontSize: 16, color: subColor),
            ),
            SizedBox(height: 20),

            _buildSummaryInfoCard(),

            _buildContactCard(doctorData['email'], doctorData['phone']),
            _buildAvailabilityCard(doctorData['weeklyAvailability']),
            _buildNavigationCard(
              context,
              icon: Icons.star,
              title: "Average Rating",
              destination: DoctorReviewsScreen(
                reviews: reviews,
                averageRating: rating,
              ),
            ),
            // _buildNavigationCard(
            //   context,
            //   title: "Medical License",
            //   icon: Icons.card_membership,
            //   destination: LicenseDetailScreen(),
            // ),
            _buildNavigationCard(
              context,
              title: "Years of Experience",
              icon: Icons.timeline,
              destination: ExperienceScreen(),
            ),
            _buildNavigationCard(
              context,
              title: "Hospital Affiliation",
              icon: Icons.local_hospital,
              destination: AffiliationScreen(),
            ),
            // _buildNavigationCard(
            //   context,
            //   title: "Education Background",
            //   icon: Icons.menu_book,
            //   destination: EducationScreen(),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
  //   return Card(
  //     elevation: 2,
  //     margin: EdgeInsets.symmetric(vertical: 6),
  //     child: ListTile(
  //       leading: Icon(icon, color: mainColor),
  //       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
  //       subtitle: Text(value),
  //     ),
  //   );
  // }
  Widget _buildSummaryInfoCard() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryItem(
              icon: Icons.school,
              label: "Qualification",
              value: doctorData['qualification'],
            ),
            _buildSummaryItem(
              icon: Icons.workspace_premium,
              label: "Experience",
              value: "${doctorData['experience']} yrs",
            ),
            _buildSummaryItem(
              icon: Icons.money,
              label: "Fee",
              value: "PKR ${doctorData['consultationFee']}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: mainColor),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAvailabilityCard(Map<String, Map<String, String>> availability) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(Icons.schedule, color: mainColor),
        title: Text(
          "Available Timings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children:
            availability.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: Text(
                  "${entry.value['start']} - ${entry.value['end']}",
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildContactCard(String email, String phone) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.contact_phone, color: mainColor),
        title: Text(
          "Contact Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text("Email: $email"),
            SizedBox(height: 2),
            Text("Phone: $phone"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget destination,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: mainColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => destination),
            ),
      ),
    );
  }
}
