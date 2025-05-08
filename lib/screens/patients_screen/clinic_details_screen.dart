import 'package:flutter/material.dart';

class ClinicDetailScreen extends StatefulWidget {
  const ClinicDetailScreen({super.key});

  @override
  _CliClinicDetailScreenState createState() => _CliClinicDetailScreenState();
}

class _CliClinicDetailScreenState extends State<ClinicDetailScreen> {
  static const Color mainColor = Color(0xFF2C7DA0);
  static const Color subColor = Color(0xFF3ABCC0);
  bool _isBookTapped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Info',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: mainColor),
            label: const Text('Help', style: TextStyle(color: mainColor)),
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clinic Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: const [
                Icon(Icons.location_on_outlined, color: mainColor),
                SizedBox(width: 8),
                Expanded(child: Text('Clinic ABC, town, city')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.phone_outlined, color: mainColor),
                SizedBox(width: 8),
                Expanded(child: Text('+92XXXXXXXXXX')),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Map Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Image.asset(
                "assets/images/dummy_map.png",
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Open Hours',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHoursColumn('Mon-Fri', '10:00 am - 11:00 pm'),
                _buildHoursColumn('Sat-Sun', '12:00 pm - 10:00 pm'),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Doctors Available',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Example count
                itemBuilder: (context, index) {
                  return _buildDoctorCard(context);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Ratings and Reviews
            const Text(
              'Ratings and Reviews',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildReviewTile(),
          ],
        ),
      ),
    );
  }

  static Widget _buildHoursColumn(String dayRange, String timing) {
    return Column(
      children: [
        Text(dayRange, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: subColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            timing,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return Container(
      width: 180,
      height: 340,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Image or Placeholder
            Container(
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/doctor.png', fit: BoxFit.cover),
            ),
            const SizedBox(height: 5),

            // Doctor Name
            const Text(
              'Dr. Javaid Iqbal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),

            // Specialization
            const Text(
              'Cardiologist',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),

            // Fees
            const Text(
              '\$50 Consultation',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isBookTapped = true),
                onTapUp: (_) => setState(() => _isBookTapped = false),
                onTapCancel: () => setState(() => _isBookTapped = false),
                child: AnimatedScale(
                  scale: _isBookTapped ? 0.92 : 1.0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/book_appointment');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Book Appointment',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildReviewTile() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Comment line text lorem ipsum dolor sit amet, consectetur."',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) =>
                          const Icon(Icons.star_border, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
