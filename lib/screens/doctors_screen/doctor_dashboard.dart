import 'package:clinic_booking_app/screens/doctors_screen/session_appointment_screen.dart';
import 'package:flutter/material.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: mainColor,  // Changed to main color
        elevation: 0,
        title: const Text("Doctor Dashboard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const _DoctorInfo(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionTitle(title: "Today's Appointments"),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios, size: 16, color: mainColor))  // Added color to arrow
                ],
              ),
              const SizedBox(height: 6),
              const TodayAppointments(),
              const SizedBox(height: 12),
              const _SectionTitle(title: "Upcoming Appointments"),
              const SizedBox(height: 10),
              const _UpcomingAppointments(),
              const SizedBox(height: 20),
              const _SectionTitle(title: "Doctor Stats"),
              const SizedBox(height: 12),
              const _SimpleDoctorStats(),
              const SizedBox(height: 20),
              const _SectionTitle(title: "Medical Updates & News"),
              const SizedBox(height: 10),
              const _MedicalNews(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  const _DoctorInfo();

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
          children: const [
            Text("Dr. Ali Khan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            SizedBox(height: 4),
            // Text("Cardiologist", style: TextStyle(color: Colors.grey)),
          ],
        )
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black));
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
        'name': 'Emma Wilson',
        'issue': 'Behavioral Issues',
        'type': 'Family Counseling',
        'status': 'Completed',
        'statusColor': Colors.grey,
        'age': 32,
        'gender': 'Female',
      },
      {
        'time': '10:00 AM - 10:30 AM',
        'name': 'Ethan James',
        'issue': 'Anxiety Disorder',
        'type': 'Individual Therapy',
        'status': 'Ongoing',
        'statusColor': subColor,
        'age': 28,
        'gender': 'Male',
      },
      {
        'time': '12:00 PM - 01:00 PM',
        'name': 'Sophia Davis',
        'issue': 'Communication Difficulties',
        'type': 'Family Counseling',
        'status': 'Pending',
        'statusColor': Colors.redAccent,
        'age': 45,
        'gender': 'Female',
      },
      {
        'time': '02:00 PM - 02:45 PM',
        'name': 'Liam Thompson',
        'issue': 'ADHD',
        'type': 'Family Counseling',
        'status': 'Pending',
        'statusColor': Colors.redAccent,
        'age': 12,
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
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_hospital, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appt['type'] as String,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
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
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.psychology, size: 14, color: Colors.black45),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appt['issue'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
  const _UpcomingAppointments();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.schedule, color: mainColor),
        title: const Text("Patient 5", style: TextStyle(color: Colors.black)),
        subtitle: const Text("12:00 PM - Consultation", style: TextStyle(color: Colors.grey)),
        trailing: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AppointmentSessionScreen()));
          },
          icon: const Icon(Icons.play_arrow,color: Colors.white,),
          label: const Text("Start"),
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}


class _SimpleDoctorStats extends StatelessWidget {
  const _SimpleDoctorStats();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ProgressBarCard(title: "Consultations", value: 14, maxValue: 20, icon: Icons.favorite_border),
        SizedBox(height: 12),
        _ProgressBarCard(title: "Avg Time (mins)", value: 15, maxValue: 30, icon: Icons.timer),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              const Spacer(),
              Text("$value", style: const TextStyle(color: subColor, fontWeight: FontWeight.bold)),
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
          _NewsCard(imagePath: 'assets/images/news1.jpg', title: "Advancement in Surgery"),
          _NewsCard(imagePath: 'assets/images/news2.jpg', title: "AI in Diagnostics"),
          _NewsCard(imagePath: 'assets/images/news3.jpg', title: "Vaccine Updates"),
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
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}