import 'package:clinic_booking_app/screens/patients_screen/appointments_history_screen.dart';
import 'package:clinic_booking_app/screens/patients_screen/patient_profile_screen.dart';
import 'package:clinic_booking_app/screens/patients_screen/prescription_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinic_booking_app/models/patient_model.dart';
import 'package:clinic_booking_app/models/clinic_model.dart';
import 'package:clinic_booking_app/services/clinic_service.dart';

class PatientDashboard extends StatefulWidget {
  final PatientModel patient;
  const PatientDashboard({super.key, required this.patient});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _currentIndex = 0;
  bool _isBookTapped = false;
  Color mainColor = Color(0xFF0A73B7);
  Color subColor = const Color(0xFF3ABCC0);
  List<Clinic> _clinics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClinics();
  }

  void _fetchClinics() async {
    final service = ClinicService();
    final clinics = await service.getClinics();
    setState(() {
      _clinics = clinics;
      _isLoading = false;
    });
  }

  void _navigateWithAnimation(BuildContext context, String route) {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    _getPageByRoute(route),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              var beginOffset = const Offset(1.0, 0.0); // Slide from right
              var endOffset = Offset.zero;
              var curve = Curves.fastOutSlowIn; // Faster feeling curve

              var tween = Tween(
                begin: beginOffset,
                end: endOffset,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300), // faster
          ),
        )
        .then((_) {
          setState(() {
            _currentIndex = 0;
          });
        });
  }

  Widget _getPageByRoute(String route) {
    switch (route) {
      case '/appointments_history':
        return CombinedAppointmentsScreen(patient: widget.patient);
      case '/prescriptions':
        return PrescriptionScreen();
      case '/profile':
        return ProfileScreen();
      default:
        return PatientDashboard(patient: widget.patient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _sectionTitle("Clinics Near me"),
            const SizedBox(height: 12),
            _buildHorizontalCards(context),
            const SizedBox(height: 24),
            _sectionTitle("Promotions"),
            const SizedBox(height: 12),
            _buildPromotionCarousel(),
            const SizedBox(height: 24),
            _buildSpecializationsCard(context),

            const SizedBox(height: 20),
            _sectionTitle("Recommended Doctors for you"),
            const SizedBox(height: 12),
            _buildHorizontalCards(context, isDoctor: true),
            const SizedBox(height: 24),
            _sectionTitle("Health Tips"),
            const SizedBox(height: 12),
            _buildHealthTipsSection(),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        widget.patient.name != null
            ? "Hi, ${widget.patient.name}"
            : "Cure Connect",
        style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () => _openNotificationPanel(context),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  void _openNotificationPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: const Center(
            child: Text(
              "You have no new notifications.",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 103, 150, 159),
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search nearby clinics, doctors...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xFF3ABCC0),
            ), // Modern, brighter search icon
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHorizontalCards(BuildContext context, {bool isDoctor = false}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = isDoctor ? List.filled(5, null) : _clinics;
    return SizedBox(
      height: isDoctor ? 230 : 210, // Different height based on type
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return isDoctor
              ? _buildDoctorCard(context)
              : _buildClinicCard(context, clinic: _clinics[index]);
        },
      ),
    );
  }

  Widget _buildClinicCard(BuildContext context, {required Clinic clinic}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/clinic_details', arguments: clinic);
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                clinic.image,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/clinic.png',
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    clinic.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(clinic.rating.toStringAsFixed(1)),
                      const Spacer(),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF2C7DA0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/doctor.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Doctor Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Specialization",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Icon(Icons.location_on, size: 18, color: Color(0xFF2C7DA0)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            child: _buildAnimatedBookButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBookButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isBookTapped = true),
      onTapUp: (_) => setState(() => _isBookTapped = false),
      onTapCancel: () => setState(() => _isBookTapped = false),
      child: AnimatedScale(
        scale: _isBookTapped ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/book_appointment');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: subColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.04,
              horizontal: screenWidth * 0.08,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Text('Book Appointment'),
        ),
      ),
    );
  }

  Widget _buildPromotionCarousel() {
    final List<String> promoImages = [
      'assets/images/promo1.jpg',
      'assets/images/promo2.jpg',
      'assets/images/promo3.jpg',
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: promoImages.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(promoImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthTipsSection() {
    List<Map<String, dynamic>> tips = [
      {
        'icon': Icons.water_drop_outlined,
        'text': 'Stay hydrated by drinking plenty of water.',
      },
      {
        'icon': Icons.fastfood_outlined,
        'text': 'Maintain a balanced and nutritious diet.',
      },
      {
        'icon': Icons.directions_run_outlined,
        'text': 'Exercise regularly to stay fit.',
      },
      {
        'icon': Icons.nightlight_round,
        'text': 'Ensure 7-8 hours of quality sleep.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? mainColor : subColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(tips[index]['icon'], size: 32, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      tips[index]['text'],
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: _currentIndex,
      selectedItemColor: const Color(0xFF2C7DA0),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      showUnselectedLabels: true,

      onTap: (index) {
        setState(() => _currentIndex = index);

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/patient_dashboard');
            //_navigateWithAnimation(context, '/patient_dashboard');
            break;
          case 1:
            _navigateWithAnimation(context, '/appointments_history');
            break;
          case 2:
            _navigateWithAnimation(context, '/prescriptions');
            break;
          case 3:
            _navigateWithAnimation(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "My Appointments",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication),
          label: "Prescriptions",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

Widget _buildSpecializationsCard(BuildContext context) {
  final List<Map<String, String>> specializations = [
    {"title": "Skin Specialist", "image": "assets/icons/skin.png"},
    {"title": "Gynecologist", "image": "assets/icons/gyno.png"},
    {"title": "Urologist", "image": "assets/icons/urologist.png"},
    {"title": "Child Specialist", "image": "assets/icons/child.png"},
    {"title": "Orthopedic Surgeon", "image": "assets/icons/ortho.png"},
    {"title": "Consultant Physician", "image": "assets/icons/physician.png"},
  ];

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: const Offset(2, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "I am looking for",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specializations.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final title = specializations[index]['title']!;
              final image = specializations[index]['image']!;

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/search_results',
                    arguments: {'specialization': title},
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: AssetImage(image),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/search_results');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF3ABCC0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "All Specializations",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
