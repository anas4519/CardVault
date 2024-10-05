import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CardVault is your ultimate business card management solution, designed to help professionals effortlessly organize, store, and access their business cards in one secure place.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              'With CardVault, you can scan physical business cards, extract essential details like name, company, and contact information, and save them as digital records for easy retrieval. Whether you want to search for cards by industry, sector, company name, or even personal notes, CardVault’s smart filters and search capabilities ensure that you can quickly find the information you need.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.03),
            const Text(
              'Key features include:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Card Scanning: Capture business cards using your phone\'s camera and automatically extract text.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Smart Organization: Categorize cards by industry, sector, and company for faster access.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Quick Search & Filters: Instantly find cards by name, company, or industry with robust search and filtering options.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Notes & Annotations: Add personal notes and additional information to each card for enhanced context.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              '- Secure & Private: Your card data is safely stored and only accessible to you.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: screenHeight * 0.03),
            const Text(
              'CardVault makes managing your professional network more efficient and helps you stay organized in your business interactions.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
