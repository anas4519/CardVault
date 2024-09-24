import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/models/card_model.dart';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/business_card_scanner.dart';
import 'package:business_card_manager/screens/card_details.dart';
import 'package:business_card_manager/screens/search_screen.dart';
import 'package:business_card_manager/services/api_service.dart';
import 'package:business_card_manager/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void signOut(BuildContext context) {
  AuthService().signOut(context);
}

bool _isFiltered = false;


class _HomeScreenState extends State<HomeScreen> {

  Future<void> _refreshCards() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CardVault',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 26,
            
          ),
        ),
        // backgroundColor: Colors.teal,
        centerTitle: true,
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.notes_rounded)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const SearchScreen()));
              },
              icon: const Icon(
                Icons.search_sharp,
                size: 30,
                color: Colors.black,
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
      body: RefreshIndicator(
        onRefresh: _refreshCards,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Saved Cards',
                      style: TextStyle(fontSize: 22),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isFiltered = !_isFiltered;
                        });
                      },
                      icon: Icon(_isFiltered
                          ? Icons.filter_list_off_rounded
                          : Icons.filter_list_rounded))
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                FutureBuilder<List<CardModel>>(
                  future: ApiService().fetchUserCards(
                    Provider.of<UserProvider>(context, listen: false).user.id,
                  ), // Ensure this returns Future<List<Blog>>
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.teal,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text(
                        'No cards added yet.',
                      ));
                    } else {
                      final cards = snapshot.data!;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cards.map((card) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03),
                                      // border: Border.all(
                                      //     color: Colors.teal, width: 3),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth *
                                              0.03), // Same as the container's border radius
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (ctx) => CardDetails(
                                                        id: card.id,
                                                        name: card.name,
                                                        industry: card.industry,
                                                        sector: card.sector,
                                                        companyName:
                                                            card.companyName,
                                                        date: card.date,
                                                        venue: card.venue,
                                                        cardImage:
                                                            '${Constants.uri}${card.cardImage}',
                                                        companyAddress:
                                                            card.companyAddress,
                                                        designation:
                                                            card.designation,
                                                        category: card.category,
                                                        personalAddress:
                                                            card.personalAddress,
                                                        website: card.website,
                                                        email: card.email,
                                                        mobile: card.mobile,
                                                        telephone: card.telephone,
                                                        whatsapp: card.whatsapp,
                                                        initalNotes: card.initialNotes,
                                                        additionalNotes: card.additionalNotes,
                                                      )));
                                        },
                                        child: Image.network(
                                          '${Constants.uri}${card.cardImage}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
