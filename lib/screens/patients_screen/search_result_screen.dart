import 'package:flutter/material.dart';
import 'package:clinic_booking_app/models/doctor_model.dart';
import 'package:clinic_booking_app/services/doctor_service.dart';
import 'package:clinic_booking_app/screens/patients_screen/book_appointment_screen.dart';

const Color mainColor = Color(0xFF0A73B7);
const Color subColor = Color(0xFF3ABCC0);

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String searchQuery = '';
  String? specialization;
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Dermatologist',
    'Gynecologist',
    'Urologist',
    'Consultant Physician',
    'Child Specialist',
  ];
  List<Doctor> allDoctors = [];
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    specialization = args?['specialization'];

    if (specialization != null && selectedCategory == 'All') {
      setState(() {
        selectedCategory = specialization!;
      });
    }

    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    setState(() => isLoading = true);
    final service = DoctorService();

    if (selectedCategory == 'All') {
      allDoctors = await service.getRecommendedDoctors();
    } else {
      allDoctors = await service.getDoctorsBySpecialization(selectedCategory);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final service = DoctorService();
    final filteredDoctors =
        allDoctors.where((doc) {
          final matchesSearch =
              searchQuery.isEmpty ||
              doc.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doc.specialization.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

          return matchesSearch;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(selectedCategory, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: subColor.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: subColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search doctors, specialization...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children:
                  categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                            fetchDoctors();
                          });
                        },
                        selectedColor: subColor,
                        backgroundColor: mainColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Doctor Cards List
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doc = filteredDoctors[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: subColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  "assets/images/doctor.jpg",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doc.specialization,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Rs ${doc.consultationFee.toString()}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final clinic = await service
                                              .findClinicForDoctor(doc.id);

                                          if (clinic != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        BookAppointmentScreen(
                                                          doctor: doc,
                                                          clinic: clinic,
                                                        ),
                                              ),
                                            );
                                          } else {
                                            // Show error: clinic not found
                                          }
                                        },

                                        icon: const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        label: const Text("Book Appointment"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: subColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
