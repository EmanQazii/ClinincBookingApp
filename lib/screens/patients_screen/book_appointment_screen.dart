import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentScreen extends StatefulWidget {
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

  final List<String> allSlots = [
    '2:00 pm - 3:00 pm',
    '3:00 pm - 4:00 pm',
    '4:00 pm - 5:00 pm',
    '5:00 pm - 6:00 pm',
    '6:00 pm - 7:00 pm',
    '7:00 pm - 8:00 pm',
    '8:00 pm - 9:00 pm',
  ];

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: mainColor,
            secondaryHeaderColor: subColor,
            colorScheme: ColorScheme.light(
              primary: mainColor,
              secondary: subColor,
            ),
            scaffoldBackgroundColor: Colors.white,
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

  void _confirmAppointment() {
    if (selectedSlot.isEmpty) {
      _showDialog('Please select a time slot!');
    } else {
      _showDialog('Your Appointment is Confirmed!');
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
            'Doctor Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Specialization', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(Icons.star_border, color: mainColor),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Experience/Expertise:\nSupporting line text lorem ipsum dolor sit amet, consectetur.',
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
          if (isSelected) {
            selectedSlot = '';
          } else {
            selectedSlot = slot;
          }
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
              Text('Clinic ABC, town, city'),
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
                child: Text('Confirm Appointment'),
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
