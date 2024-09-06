import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        flexibleSpace: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.red, // Setting the app bar background color to red
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Lakshya Vidhee Security Force',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.8, // Adjust the opacity value as needed
                child: Image.asset(
                  'assets/lsf2.jpeg', // Watermark image path
                  fit:
                      BoxFit.cover, // Ensure the image covers the entire screen
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Empowering Security, Ensuring Protection',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'At Lakshya Vidhee Security Force, we are dedicated to safeguarding your interests with professionalism, integrity, and reliability. Our comprehensive security solutions are tailored to meet your unique needs, providing peace of mind in an ever-evolving world.',
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Our Services:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            serviceDescription(
              'Manned Guarding',
              [
                'Trained and licensed security personnel ensure on-site presence, surveillance, and access control.',
                'Security personnel are equipped to handle various security situations effectively.'
              ],
            ),
            serviceDescription(
              'Mobile Patrols',
              [
                'Rapid response mobile units conduct regular inspections and interventions to deter security breaches and ensure the security of premises.',
                'Mobile patrols cover a wide area, enhancing security presence and responsiveness.'
              ],
            ),
            serviceDescription(
              'CCTV Surveillance',
              [
                'State-of-the-art CCTV systems offer continuous monitoring and recording of critical areas.',
                'CCTV surveillance provides real-time monitoring and playback options for security incidents review.'
              ],
            ),
            serviceDescription(
              'Event Security',
              [
                'Strategic planning and crowd management ensure the safety of participants and venues during events, providing a secure environment for all.',
                'Event security includes risk assessment, emergency planning, and coordination with local authorities.'
              ],
            ),
            serviceDescription(
              'Consultation and Risk Assessment',
              [
                'We offer customized security strategies tailored to your specific requirements and concerns, helping you mitigate risks effectively.',
                'Risk assessments identify vulnerabilities and recommend appropriate security measures for comprehensive protection.'
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Our Values:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            valueDescription(
              'Professionalism',
              [
                'Upholding the highest standards in recruitment, training, and service delivery.',
                'Professional conduct in all interactions with clients, employees, and stakeholders.'
              ],
            ),
            valueDescription(
              'Integrity',
              [
                'Transparency, honesty, and ethical conduct are the pillars of our organization.',
                'Maintaining trust and credibility through consistent ethical behavior.'
              ],
            ),
            valueDescription(
              'Reliability',
              [
                'We are committed to providing consistent, responsive, and trustworthy security solutions.',
                'Dependable services ensuring the safety and security of our clients.'
              ],
            ),
            valueDescription(
              'Innovation',
              [
                'Embracing cutting-edge technology to stay ahead of emerging threats.',
                'Continuous improvement and innovation in security solutions for enhanced protection.'
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceDescription(String title, List<String> subpoints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: subpoints
              .map((point) => Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(point),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget valueDescription(String title, List<String> subpoints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: subpoints
              .map((point) => Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(point),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
