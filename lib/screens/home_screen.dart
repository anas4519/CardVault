import 'package:business_card_manager/screens/business_card_scanner.dart';
import 'package:business_card_manager/screens/card_details.dart';
import 'package:business_card_manager/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Card Vault',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => SearchScreen()));
              },
              icon: const Icon(
                Icons.search_sharp,
                size: 30,
              )),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: screenHeight * 0.05, right: screenWidth * 0.03),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const BusinessCardScanner()));
          },
          backgroundColor: Colors.teal,
          foregroundColor: Colors.grey[200],
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saved Cards',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  border: Border.all(color: Colors.teal, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth *
                      0.03), // Same as the container's border radius
                  child: InkWell(
                    child: Image.asset(
                      'assets/IMG-20240917-WA0011~2.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
