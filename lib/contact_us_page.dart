import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        flexibleSpace: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.red, // Setting the app bar background color to red
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20), // Add padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactInfo(
                    icon: Icons.location_on,
                    title: 'Our Office Address',
                    content:
                        'Shop No 2 A Wing Krishna Mai Park, Near Dwarka School, Nandiwali, Kalyan East, Kalyan, Maharashtra 421306',
                  ),
                  SizedBox(height: 20), // Add spacing between sections
                  _buildContactInfo(
                    icon: Icons.email,
                    title: 'General Enquiries',
                    content: 'lakshyagroups7@gmail.com',
                  ),
                  SizedBox(height: 20), // Add spacing between sections
                  _buildContactInfo(
                    icon: Icons.phone,
                    title: 'Call Us',
                    content: '+919004002337',
                  ),
                  SizedBox(height: 20), // Add spacing between sections
                  _buildContactInfo(
                    icon: Icons.access_time,
                    title: 'Our Timings',
                    content:
                        'Mon - Sun : 12:00 PM - 12:00 PM / 12:00 AM - 12:00 AM',
                  ),
                ],
              ),
            ),
          ),
          // Watermark with transparency below the app bar
          Positioned(
            top: kToolbarHeight, // Position below the app bar
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.2, // Set the transparency to 0.2
              child: Image.asset(
                'assets/lsf2.jpeg', // Watermark image path
                fit: BoxFit.cover, // Ensure the image covers the entire screen
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        SizedBox(width: 10), // Add spacing between icon and text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5), // Add spacing between title and content
              Text(
                content,
                softWrap: true, // Allow text to wrap
              ),
            ],
          ),
        ),
      ],
    );
  }
}
