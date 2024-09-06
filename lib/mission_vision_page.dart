import 'package:flutter/material.dart';

class MissionVisionPage extends StatelessWidget {
  const MissionVisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission & Vision'),
        flexibleSpace: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.red, // Setting the app bar background color to red
          ),
        ),
      ),
      body: Stack(
        children: [
          const SingleChildScrollView(
            padding: EdgeInsets.all(20), // Add padding around the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/mission.jpeg'),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mission:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  10), // Add spacing between mission and text
                          Text(
                            'At Lakshya Vidhee Security Force, our mission is to empower security and ensure protection for our clients by delivering uncompromising professionalism, integrity, and reliability in every aspect of our service. We are committed to safeguarding lives, property, and assets through strategic security solutions tailored to the unique needs of each client. With unwavering dedication and the highest ethical standards, we strive to be the trusted partner in security, providing peace of mind in an ever-changing world.',
                            textAlign:
                                TextAlign.justify, // Align text to justify
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Add spacing between mission and vision
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/vision.jpeg'),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      // Wrap the Row containing Vision in Expanded widget
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vision:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  10), // Add spacing between vision and text
                          Text(
                            'Our vision at Lakshya Vidhee Security Force is to redefine excellence in the security industry, setting the benchmark for quality, innovation, and customer satisfaction. We aspire to be recognized as the premier provider of comprehensive security solutions, known for our proactive approach, advanced technology integration, and unparalleled commitment to client safety and security. Through continuous improvement and strategic growth, we aim to be the go-to choice for individuals and organizations seeking reliable and effective security services.',
                            textAlign:
                                TextAlign.justify, // Align text to justify
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Watermark with transparency below the app bar
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // Set the transparency to 0.3
              child: Image.asset(
                'assets/lsf_photo.jpeg', // Watermark image path
                fit: BoxFit.cover, // Ensure the image covers the entire screen
              ),
            ),
          ),
        ],
      ),
    );
  }
}
