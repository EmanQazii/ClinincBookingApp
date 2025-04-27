import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PatientDashboard(),
    ),
  );
}

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // Navigate back to the login screen
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "Cure Connect",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            // Open notification panel
            _openNotificationPanel(context);
          },
        ),
        const SizedBox(width: 16),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  void _openNotificationPanel(BuildContext context) {
    // Simple notification panel example
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Notifications"),
            content: const Text("You have no new notifications."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search nearby clinics, doctors...",
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.mic, color: Colors.grey),
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
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to detailed page for clinic/doctor
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(isDoctor: isDoctor),
                ),
              );
            },
            child: Container(
              width: 140,
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
                      color: const Color(0xFF2C7DA0),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/150'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isDoctor ? "Specialization" : "Description",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Color(0xFF2C7DA0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromotionCarousel() {
    final List<String> promoImages = [
      'https://via.placeholder.com/400x150/2C7DA0/ffffff?text=Promo+1',
      'https://via.placeholder.com/400x150/eeeeee/333333?text=Promo+2',
      'https://via.placeholder.com/400x150/cccccc/111111?text=Promo+3',
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: promoImages.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(promoImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        "Drink plenty of water and maintain a balanced diet!",
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF2C7DA0),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        // Implement navigation to respective pages
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "My Appointments",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

class DetailsPage extends StatelessWidget {
  final bool isDoctor;

  const DetailsPage({Key? key, required this.isDoctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isDoctor ? "Doctor Details" : "Clinic Details"),
      ),
      body: Center(child: Text(isDoctor ? "Doctor Details" : "Clinic Details")),
    );
  }
}
