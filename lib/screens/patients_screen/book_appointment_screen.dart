import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinic_booking_app/models/doctor_model.dart';
import 'package:clinic_booking_app/models/clinic_model.dart';
import 'package:clinic_booking_app/services/appointment_service.dart';
import '/models/appointment_model.dart';
import '/models/patient_model.dart';
import '/services/patient_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  final Clinic clinic;

  const BookAppointmentScreen({
    Key? key,
    required this.doctor,
    required this.clinic,
  }) : super(key: key);

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  Color mainColor = const Color(0xFF2C7DA0);
  Color subColor = const Color(0xFF3ABCC0);

  DateTime selectedDate = DateTime.now();
  String selectedSlot = '';
  bool showAllSlots = false;
  bool _isConfirmTapped = false;
  bool _isCancelTapped = false;

  String patientId = ''; // Store patientId here
  PatientModel? patient; // Store patient details

  final List<String> allSlots = [
    '2:00 pm - 3:00 pm',
    '3:00 pm - 4:00 pm',
    '4:00 pm - 5:00 pm',
    '5:00 pm - 6:00 pm',
    '6:00 pm - 7:00 pm',
    '7:00 pm - 8:00 pm',
    '8:00 pm - 9:00 pm',
  ];
  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    try {
      // Get the currently logged-in user's UID
      final user = FirebaseAuth.instance.currentUser!;
      if (user.uid != null) {
        print("user id nowwwww${user.uid}");
        final patientData = await PatientService().getPatientById(user.uid);

        if (patientData != null) {
          setState(() {
            patient = patientData;
            patientId = user.uid; // Using user UID as the patientId
          });
          print('Patient Data: ${patientData.name}'); // ✅ safe now
        }
      }
    } catch (e) {
      print("Error fetching patient data: $e");
    }
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: mainColor,
              secondary: subColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _confirmAppointment() async {
    if (selectedSlot.isEmpty) {
      _showDialog('Please select a time slot!');
      return;
    }

    if (patient == null) {
      _showDialog('Error: Unable to fetch patient data.');
      return;
    }

    setState(() => _isConfirmTapped = true);

    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      final docRef =
          FirebaseFirestore.instance.collection('appointments').doc();
      String appointmentId = docRef.id;

      AppointmentModel appointment = AppointmentModel(
        appointmentId: appointmentId,
        doctorId: widget.doctor.id,
        doctorName: widget.doctor.name,
        specialization: widget.doctor.specialization,
        clinicId: widget.clinic.id,
        clinicName: widget.clinic.name,
        appointmentDate: formattedDate,
        appointmentTime: selectedSlot,
        patientId: patientId,
        patientName: patient!.name,
        patientPhone: patient!.phone,
        symptoms: "Fever",
        labTestsRequested: ["Blood Test"],
        diagnosis: "Flu",
        prescription: ["Paracetamol"],
        status: 'Pending',
        bookedAt: Timestamp.now(),
        notes: '',
      );

      await AppointmentService.bookAppointment(appointment);

      if (mounted) {
        _showDialog('Your Appointment is Confirmed!');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context); // Go back to the previous screen
        });
      }
    } catch (e) {
      _showDialog('Error confirming appointment. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isConfirmTapped = false);
      }
    }
  }

  void _cancelAppointment() {
    setState(() {
      selectedSlot = '';
    });
    _showDialog('Appointment Cancelled!');
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            message,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: mainColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedSlots = showAllSlots ? allSlots : allSlots.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: Text('Book Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDoctorCard(),
            SizedBox(height: 20),
            _buildDateSelector(),
            SizedBox(height: 20),
            _buildSlotSelector(displayedSlots),
            SizedBox(height: 20),
            _buildAppointmentDetails(),
            SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    final doctor = widget.doctor;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: subColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: subColor,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            doctor.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(doctor.specialization, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(Icons.star, color: mainColor, size: 20),
            ),
          ),
          SizedBox(height: 10),
          Text(
            doctor.qualification,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: mainColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
                Icon(Icons.calendar_today, color: mainColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotSelector(List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Slots:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showAllSlots = !showAllSlots;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: mainColor,
                backgroundColor: subColor.withOpacity(0.1),
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(showAllSlots ? 'Hide' : 'View All'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) => _buildSlotChip(slot)).toList(),
        ),
      ],
    );
  }

  Widget _buildSlotChip(String slot) {
    final isSelected = slot == selectedSlot;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = isSelected ? '' : slot;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? mainColor : Colors.white,
          border: Border.all(color: mainColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          slot,
          style: TextStyle(color: isSelected ? Colors.white : mainColor),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    final clinic = widget.clinic;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: subColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on, color: mainColor),
              SizedBox(width: 10),
              Expanded(child: Text(clinic.name)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.date_range, color: mainColor),
              SizedBox(width: 10),
              Text(DateFormat('EEEE, d MMM, yyyy').format(selectedDate)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, color: mainColor),
              SizedBox(width: 10),
              Text(selectedSlot.isNotEmpty ? selectedSlot : 'Select Time Slot'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isConfirmTapped = true),
            onTapUp: (_) => setState(() => _isConfirmTapped = false),
            onTapCancel: () => setState(() => _isConfirmTapped = false),
            child: AnimatedScale(
              scale: _isConfirmTapped ? 0.95 : 1.0,
              duration: Duration(milliseconds: 150),
              child: ElevatedButton(
                onPressed: _confirmAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    _isConfirmTapped
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text('Confirm Appointment'),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isCancelTapped = true),
            onTapUp: (_) => setState(() => _isCancelTapped = false),
            onTapCancel: () => setState(() => _isCancelTapped = false),
            child: AnimatedScale(
              scale: _isCancelTapped ? 0.95 : 1.0,
              duration: Duration(milliseconds: 150),
              child: OutlinedButton(
                onPressed: _cancelAppointment,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: mainColor),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel Appointment',
                  style: TextStyle(color: mainColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
