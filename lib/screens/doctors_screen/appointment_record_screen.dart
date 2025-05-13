import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinic_booking_app/screens/doctors_screen/appointment_detail_screen.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class Appointment {
  final String time;
  final String name;
  final String issue;
  final String type;
  final String status;
  final DateTime date;
  final String gender;

  Appointment({
    required this.time,
    required this.name,
    required this.issue,
    required this.type,
    required this.status,
    required this.date,
    required this.gender,
  });
}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> weekDates = [];

  List<Appointment> allAppointments = [
    Appointment(
      time: '09:00 AM - 10:00 AM',
      name: 'Ayesha Khan',
      issue: 'Hypertension',
      type: 'Cardiology Consultation',
      status: 'Completed',
      date: DateTime.now(),
      gender: 'Female',
    ),
    Appointment(
      time: '10:30 AM - 11:30 AM',
      name: 'Hamza Ahmed',
      issue: 'Chest Pain',
      type: 'Follow-up',
      status: 'Completed',
      date: DateTime.now(),
      gender: 'Male',
    ),
    Appointment(
      time: '12:00 PM - 01:00 PM',
      name: 'Fatima Noor',
      issue: 'Irregular Heartbeat',
      type: 'Cardiology Consultation',
      status: 'Ongoing',
      date: DateTime.now(),
      gender: 'Female',
    ),
    Appointment(
      time: '01:30 PM - 02:30 PM',
      name: 'Ali Raza',
      issue: 'Congenital Heart Defect',
      type: 'Pediatric Cardiology',
      status: 'Pending',
      date: DateTime.now().add(Duration(days: 1)),
      gender: 'Male',
    ),
    Appointment(
      time: '03:00 PM - 04:00 PM',
      name: 'Zara Sheikh',
      issue: 'Arrhythmia',
      type: 'Cardiology Consultation',
      status: 'Pending',
      date: DateTime.now().add(Duration(days: 1)),
      gender: 'Female',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
  }

  void _generateWeekDates() {
    DateTime now = selectedDate;
    int weekday = now.weekday; // 1 = Monday, 7 = Sunday
    DateTime sunday = now.subtract(Duration(days: weekday % 7));
    weekDates = List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  void _changeWeek(bool forward) {
    setState(() {
      selectedDate =
          forward
              ? selectedDate.add(Duration(days: 7))
              : selectedDate.subtract(Duration(days: 7));
      _generateWeekDates();
    });
  }

  List<Appointment> get filteredAppointments {
    return allAppointments
        .where(
          (appointment) =>
              appointment.date.year == selectedDate.year &&
              appointment.date.month == selectedDate.month &&
              appointment.date.day == selectedDate.day,
        )
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.blue.shade700;
      case 'Ongoing':
        return subColor;
      case 'Pending':
        return Colors.red.shade300;
      default:
        return Colors.grey;
    }
  }

  Widget buildAppointmentCard(Appointment appointment) {
    return GestureDetector(
      onTap: () {
        if (appointment.status == 'Pending') {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Session Not Available"),
                  content: Text("This session is not held yet."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK", style: TextStyle(color: mainColor)),
                    ),
                  ],
                ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      AppointmentDetailScreen(appointment: appointment),
            ),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: subColor.withOpacity(0.2),
                child: Icon(Icons.person, color: mainColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      appointment.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      appointment.issue,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    appointment.type,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(
                        appointment.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: getStatusColor(appointment.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateSelector() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Appointments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            SizedBox(height: 12),
            // //SizedBox(height: 4),
            // Text(
            //   DateFormat.yMMMMd().format(selectedDate),
            //   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            // ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 14,
                    color: Colors.black54,
                  ),
                  onPressed: () => _changeWeek(false),
                  constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        weekDates.map((day) {
                          bool isSelected =
                              day.day == selectedDate.day &&
                              day.month == selectedDate.month &&
                              day.year == selectedDate.year;

                          return Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = day;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? mainColor
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat.E().format(day),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      DateFormat.d().format(day),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.black54,
                  ),
                  onPressed: () => _changeWeek(true),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            SizedBox(height: 6),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                      _generateWeekDates();
                    });
                  }
                },
                icon: Icon(Icons.calendar_today, size: 16),
                label: Text("Pick a Date", style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Appointments",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: mainColor,
        ),
        body: Column(
          children: [
            buildDateSelector(), // your calendar widget inside a Card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //   "Today's Appointments",
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMMd().format(selectedDate),
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  filteredAppointments.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 12),
                              Text(
                                "No appointments for this day.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredAppointments.length,
                        itemBuilder: (context, index) {
                          return buildAppointmentCard(
                            filteredAppointments[index],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
