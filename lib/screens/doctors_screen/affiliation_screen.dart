import 'package:flutter/material.dart';

const mainColor = Color(0xFF0A73B7);
const subColor = Color(0xFF3ABCC0);

class AffiliationScreen extends StatelessWidget {
  final String hospitalName = "ABC Hospital";
  final String hospitalLocation = "123 Health St., City, Country";
  final String doctorRole = "Senior Dermatologist";
  final String hospitalLogoPath =
      'assets/images/clinic_logo.png'; // Add your logo image path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "Hospital Affiliation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hospital Logo
            Center(
              child: Image.asset(
                hospitalLogoPath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Hospital Name
            _buildInfoCard(Icons.business, "Hospital Name", hospitalName),

            // Hospital Location
            _buildInfoCard(
              Icons.location_on,
              "Hospital Location",
              hospitalLocation,
            ),

            // Doctor's Role
            _buildInfoCard(Icons.person, "Role at Hospital", doctorRole),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: subColor, size: 30),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
