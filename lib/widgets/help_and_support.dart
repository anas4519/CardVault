import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _sendEmail(String email) async {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need assistance with CardVault?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              'We’re here to help! Whether you’re having trouble scanning a card, searching for saved cards, or need any other guidance, our support team is available to assist you.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.03),
            const Text(
              'Common Issues:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Trouble scanning a card? Make sure the camera is focused and the card is in good lighting.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Can’t find a saved card? Try using the search filters to narrow down your results.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Unsure how to use a feature? Check out our in-app guide or reach out to support for assistance.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.03),
            const Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              'If you need further help, or want to report any bugs, feel free to reach out to us:',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                const SelectableText(
                    'Email: versevibe45@gmail.com',
                    style: TextStyle(fontSize: 16, height: 1.5,),
                  ),
                  const Spacer(),
                  IconButton(onPressed: ()=> _sendEmail('versevibe45@gmail.com'), icon: const Icon(Icons.email, color: Colors.teal,))
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
