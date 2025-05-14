import 'package:clinic_booking_app/screens/doctors_screen/session_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinic_booking_app/screens/doctors_screen/record_screen.dart';
import 'package:clinic_booking_app/screens/doctors_screen/appointment_record_screen.dart';
import 'package:clinic_booking_app/screens/doctors_screen/profile_screen.dart';
import 'package:clinic_booking_app/models/doctor_model.dart'; // adjust the path if needed
import '/models/appointment_model.dart';
import 'package:clinic_booking_app/services/doctor_service.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class DoctorDashboardScreen extends StatefulWidget {
  final Doctor doctor;
  final String clinicId;

  const DoctorDashboardScreen({
    super.key,
    required this.doctor,
    required this.clinicId,
  });

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboardScreen> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        return; // Already on dashboard, do nothing
      case 1:
        destination = AppointmentScreen(
          doctor: widget.doctor,
          clinicId: widget.clinicId,
        );
        break;
      case 2:
        destination = RecordsScreen();
        break;
      case 3:
        destination = DoctorProfile();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final clinicId = widget.clinicId;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text(
          "Doctor Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              _DoctorInfo(doctor: doctor),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(title: "Today's Appointments"),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: mainColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AppointmentScreen(
                                doctor: widget.doctor,
                                clinicId: widget.clinicId,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 6),
              TodayAppointments(),
              SizedBox(height: 12),
              _SectionTitle(title: "Upcoming Appointments"),
              SizedBox(height: 10),
              _UpcomingAppointments(doctor: doctor, clinicId: clinicId),
              SizedBox(height: 20),
              _SectionTitle(title: "Doctor Stats"),
              SizedBox(height: 12),
              _SimpleDoctorStats(),
              SizedBox(height: 20),
              _SectionTitle(title: "Medical Updates & News"),
              SizedBox(height: 10),
              _MedicalNews(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensure all labels are shown
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: 'Records',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  final Doctor doctor;

  const _DoctorInfo({required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/doctor.jpg'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            // Text("Cardiologist", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class TodayAppointments extends StatelessWidget {
  const TodayAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final appointments = [
      {
        'time': '09:00 AM - 10:00 AM',
        'name': 'Ayesha Khan',
        'issue': 'Hypertension',
        'type': 'Cardiology Consultation',
        'status': 'Completed',
        'statusColor': Colors.grey,
        'age': 56,
        'gender': 'Female',
      },
      {
        'time': '10:00 AM - 10:30 AM',
        'name': 'Hamza Ahmed',
        'issue': 'Chest Pain',
        'type': 'Follow-up',
        'status': 'Ongoing',
        'statusColor': subColor,
        'age': 42,
        'gender': 'Male',
      },
      {
        'time': '12:00 PM - 01:00 PM',
        'name': 'Fatima Noor',
        'issue': 'Irregular Heartbeat',
        'type': 'Cardiology Consultation',
        'status': 'Pending',
        'statusColor': Colors.redAccent,
        'age': 60,
        'gender': 'Female',
      },
      {
        'time': '02:00 PM - 02:45 PM',
        'name': 'Ali Raza',
        'issue': 'Congenital Heart Defect',
        'type': 'Pediatric Cardiology',
        'status': 'Pending',
        'statusColor': Colors.redAccent,
        'age': 10,
        'gender': 'Male',
      },
    ];

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final appt = appointments[index];
          return Container(
            width: screenWidth * 0.8,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      appt['time'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appt['type'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  appt['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.black45),
                    const SizedBox(width: 4),
                    Text(
                      '${appt['age']} yrs, ${appt['gender']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appt['issue'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (appt['statusColor'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appt['status'] as String,
                      style: TextStyle(
                        color: appt['statusColor'] as Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UpcomingAppointments extends StatelessWidget {
  final String clinicId;
  final Doctor doctor;
  _UpcomingAppointments({required this.doctor, required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppointmentModel>>(
      future: DoctorService().getUpcomingAppointmentsForDoctor(
        clinicId: clinicId,
        doctorId: doctor.id!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return const Center(child: Text('No upcoming appointments'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
              color: Colors.white,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.schedule, color: mainColor),
                title: Text(
                  appointment.patientName,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  "${appointment.appointmentTime} - ${appointment.specialization}",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AppointmentSessionScreen(
                              doctor: doctor,
                              appointment: appointment,
                            ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text("Start"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SimpleDoctorStats extends StatelessWidget {
  const _SimpleDoctorStats();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ProgressBarCard(
          title: "Consultations",
          value: 14,
          maxValue: 20,
          icon: Icons.favorite_border,
        ),
        SizedBox(height: 12),
        _ProgressBarCard(
          title: "Avg Time (mins)",
          value: 15,
          maxValue: 30,
          icon: Icons.timer,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class _ProgressBarCard extends StatelessWidget {
  final String title;
  final int value;
  final int maxValue;
  final IconData icon;

  const _ProgressBarCard({
    required this.title,
    required this.value,
    required this.maxValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percent = value / maxValue;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: subColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                "$value",
                style: const TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[300],
            color: subColor,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class _MedicalNews extends StatelessWidget {
  const _MedicalNews();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: const [
          _NewsCard(
            imagePath: 'assets/images/news1.jpg',
            title: "Advancement in Surgery",
          ),
          _NewsCard(
            imagePath: 'assets/images/news2.jpg',
            title: "AI in Diagnostics",
          ),
          _NewsCard(
            imagePath: 'assets/images/news3.jpg',
            title: "Vaccine Updates",
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String imagePath;
  final String title;
  const _NewsCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              cacheHeight: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRouteToAppointmentScreen(Doctor doctor, String clinicId) {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) =>
            AppointmentScreen(doctor: doctor, clinicId: clinicId),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
