import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinic_booking_app/screens/doctors_screen/appointment_detail_screen.dart';
import '/models/appointment_model.dart';
import '/services/appointment_service.dart';
import '/models/doctor_model.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class AppointmentScreen extends StatefulWidget {
  final String clinicId;
  final Doctor doctor;

  const AppointmentScreen({
    super.key,
    required this.doctor,
    required this.clinicId,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> weekDates = [];
  List<AppointmentModel> allAppointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
    fetchAppointments();
  }

  void _generateWeekDates() {
    DateTime now = selectedDate;
    int weekday = now.weekday;
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

  Future<void> fetchAppointments() async {
    setState(() => isLoading = true);
    final appointmentService = AppointmentService();

    final fetchedAppointments =
        await AppointmentService.fetchAllAppointmentsByClinicAndDoctor(
          clinicId: widget.clinicId,
          doctorId: widget.doctor.id,
        );

    setState(() {
      allAppointments = fetchedAppointments;
      isLoading = false;
    });
  }

  List<AppointmentModel> get filteredAppointments {
    return allAppointments.where((appointment) {
      final date = DateTime.parse(appointment.appointmentDate);
      return date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.blue.shade700;
      case 'ongoing':
        return subColor;
      case 'pending':
        return Colors.red.shade300;
      default:
        return Colors.grey;
    }
  }

  Widget buildAppointmentCard(AppointmentModel appointment) {
    return GestureDetector(
      onTap: () {
        if (appointment.status.toLowerCase() == 'pending') {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
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
              builder: (_) => AppointmentDetailScreen(appointment: appointment),
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
                      "${appointment.appointmentTime}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      appointment.patientName ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      appointment.symptoms ?? '',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    appointment.specialization ?? '',
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
              "Appointments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            SizedBox(height: 12),
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
                              onTap: () => setState(() => selectedDate = day),
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
            buildDateSelector(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat.yMMMMd().format(selectedDate),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredAppointments.isEmpty
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
