import 'package:flutter/material.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  List<Map<String, dynamic>> appointments = [
    {
      'doctorName': 'Dr. Javaid Iqbal',
      'specialization': 'Cardiologist',
      'clinic': 'City Heart Clinic',
      'date': 'May 2, 2025',
      'time': '10:00 AM',
      'image': 'assets/images/doctor.png',
      'phone': '+1234567890',
    },
    {
      'doctorName': 'Dr. Sarah Khan',
      'specialization': 'Dermatologist',
      'clinic': 'Skin Care Center',
      'date': 'May 4, 2025',
      'time': '2:30 PM',
      'image': 'assets/images/doctor.png',
      'phone': '+0987654321',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C7DA0),
        title: const Text(
          'My Appointments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 103, 150, 159),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(appointment['image']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['doctorName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment['specialization'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF3ABCC0),
                      ),
                      onPressed: () {
                        // Open detail screen or show dialog if needed
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Color(0xFF2C7DA0),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${appointment['date']} at ${appointment['time']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(0xFF2C7DA0),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      appointment['clinic'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showCallDialog(context, appointment['phone']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3ABCC0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.call,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Call',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _showCancelDialog(context, index);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF3ABCC0),
                        side: const BorderSide(color: Color(0xFF3ABCC0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.cancel,
                        size: 18,
                        color: Color(0xFF3ABCC0),
                      ),
                      label: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCallDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Place Call'),
          backgroundColor: Colors.white, // White background
          content: Text('Do you want to call $phoneNumber?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF2C7DA0),
                ), // Theme color for text
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Add call functionality here
                print('Calling $phoneNumber...');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFF2C7DA0,
                ), // Theme color for button background
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          backgroundColor: Colors.white, // White background
          content: const Text('Do you really want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Color(0xFF2C7DA0),
                ), // Theme color for text
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  appointments.removeAt(index);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFF2C7DA0,
                ), // Theme color for button background
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
