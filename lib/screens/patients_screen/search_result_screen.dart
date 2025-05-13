import 'package:flutter/material.dart';

const Color mainColor = Color(0xFF0A73B7);
const Color subColor = Color(0xFF3ABCC0);

class Doctors {
  final String name;
  final String specialization;
  final String clinic;
  final String image;
  final bool isNearby;

  Doctors({
    required this.name,
    required this.specialization,
    required this.clinic,
    required this.image,
    required this.isNearby,
  });
}

final List<Doctors> mockDoctors = [
  Doctors(
    name: 'Dr. Ayesha Khan',
    specialization: 'Skin Specialist',
    clinic: 'DermaCare, Block A',
    image: 'assets/images/doctor.jpg',
    isNearby: true,
  ),
  Doctors(
    name: 'Dr. Sara Malik',
    specialization: 'Gynecologist',
    clinic: 'City Hospital',
    image: 'assets/images/doctor.jpg',
    isNearby: false,
  ),
  Doctors(
    name: 'Dr. Rizwan Ali',
    specialization: 'Urologist',
    clinic: 'Uro Clinic',
    image: 'assets/images/doctor.jpg',
    isNearby: true,
  ),
  Doctors(
    name: 'Dr. Bilal Noor',
    specialization: 'Consultant Physician',
    clinic: 'General Health Center',
    image: 'assets/images/doctor.jpg',
    isNearby: false,
  ),
  Doctors(
    name: 'Dr. Iqra Qureshi',
    specialization: 'Child Specialist',
    clinic: 'Little Steps Clinic',
    image: 'assets/images/doctor.jpg',
    isNearby: true,
  ),
];

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
    'Skin Specialist',
    'Gynecologist',
    'Urologist',
    'Consultant Physician',
    'Child Specialist',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    specialization = args?['specialization'];
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors =
        mockDoctors.where((doc) {
          final matchesSpecialization =
              selectedCategory == 'All' ||
              doc.specialization == selectedCategory;
          final matchesSearch =
              searchQuery.isEmpty ||
              doc.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doc.clinic.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doc.specialization.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
          return matchesSpecialization && matchesSearch;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          specialization ?? 'All Specializations',
          style: TextStyle(color: Colors.white),
        ),
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
                        hintText: "Search clinics, doctors...",
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
          // Categories filter chips
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
            child: ListView.builder(
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
                        backgroundImage: AssetImage(doc.image),
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
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              doc.clinic,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/book_appointment',
                                    arguments: {'doctor': doc},
                                  );
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(fontSize: 13),
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
