import 'package:flutter/material.dart';
import 'package:clinic_booking_app/models/clinic_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clinic_booking_app/models/reviews_model.dart';
import 'package:clinic_booking_app/services/reviews_service.dart';
import 'package:clinic_booking_app/models/doctor_model.dart';
import 'package:clinic_booking_app/services/doctor_service.dart';
import '../patients_screen/book_appointment_screen.dart';

class ClinicDetailScreen extends StatefulWidget {
  final Clinic clinic;

  const ClinicDetailScreen({super.key, required this.clinic});

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
            Text(
              widget.clinic.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.location_on_outlined, color: mainColor),
                SizedBox(width: 8),
                Expanded(child: Text(widget.clinic.location)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, color: mainColor),
                SizedBox(width: 8),
                Expanded(child: Text(widget.clinic.phone)),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Map Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                final lat = widget.clinic.mapLocation.latitude;
                final lng = widget.clinic.mapLocation.longitude;
                final url = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
                );
                launchUrl(url);
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  "assets/images/dummy_map.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Open Hours',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 30,
              runSpacing: 12,
              children:
                  widget.clinic.hours.entries.map((entry) {
                    return _buildHoursColumn(entry.key, entry.value);
                  }).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Doctors Available',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 270,
              child: StreamBuilder<List<Doctor>>(
                stream: DoctorService().getDoctorsForClinic(widget.clinic.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final doctors = snapshot.data;

                  if (doctors == null || doctors.isEmpty) {
                    return const Center(child: Text('No doctors available'));
                  }

                  return ListView.builder(
                    scrollDirection:
                        Axis.horizontal, // Make the ListView horizontal
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(context, doctors[index]);
                    },
                  );
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

            buildReviewTile(widget.clinic.id),
            //_buildReviewTile(),
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

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Container(
      width: 200, // 2 cards visible within screen width ~360+
      height: 350, // Set a fixed height to match the design
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Image
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:
                    doctor.imageUrl.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(doctor.imageUrl),
                          fit: BoxFit.cover,
                        )
                        : DecorationImage(
                          image: AssetImage('assets/images/doctor.jpg'),
                          fit: BoxFit.cover,
                        ),
                color: Colors.grey.shade200,
              ),
              child:
                  doctor.imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 36, color: Colors.grey)
                      : null,
            ),
            const SizedBox(height: 4),

            // Doctor Name
            Text(
              doctor.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),

            // Specialization
            Text(
              doctor.specialization,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            // Consultation Fee (more highlighted)
            Text(
              'Rs. ${doctor.consultationFee.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: subColor, // Making it standout with subColor
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 3),

            // Wait Time, Experience, Rating Row
            Column(
              children: [
                // Experience displayed prominently
                Text(
                  'Experience: ${doctor.experience} yrs',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Rating Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < doctor.averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      size: 14,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isBookTapped = true),
                onTapUp: (_) => setState(() => _isBookTapped = false),
                onTapCancel: () => setState(() => _isBookTapped = false),
                child: AnimatedScale(
                  scale: _isBookTapped ? 0.92 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BookAppointmentScreen(
                                doctor: doctor,
                                clinic: widget.clinic,
                              ),
                        ),
                      );
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

  Widget buildReviewTile(String clinicId) {
    return StreamBuilder<List<Review>>(
      stream: ReviewService().getReviews(
        targetType: 'clinics',
        targetId: clinicId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data ?? [];
        print('Reviews fetched: ${reviews.length}'); // Debug line

        if (reviews.isEmpty) {
          return const Text('No reviews yet.');
        }

        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.patientName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"${review.comment}"',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < double.parse(review.rating).round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
