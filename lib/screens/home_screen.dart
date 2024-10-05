import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/models/card_model.dart';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/business_card_scanner.dart';
import 'package:business_card_manager/screens/card_details.dart';
import 'package:business_card_manager/screens/search_screen.dart';
import 'package:business_card_manager/services/api_service.dart';
import 'package:business_card_manager/widgets/drawer_child.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refreshCards() async {
    setState(() {
      _fetchCards();
    });
  }

  List<CardModel> _cards = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final fetchedCards =
          await ApiService().fetchUserCards(userProvider.user.id);
      setState(() {
        _cards = fetchedCards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load cards: $e';
        _isLoading = false;
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'CardVault',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        // backgroundColor: Colors.teal,
        centerTitle: true,
        leading: 
        // Padding(
        //   padding: EdgeInsets.only(left: screenWidth * 0.02),
        //   child: GestureDetector(
        //     onTap: () {
        //       _scaffoldKey.currentState?.openDrawer();
        //     },
        //     child: CircleAvatar(
        //       backgroundColor: Colors.transparent,
        //       radius: 20.0,
        //       child: ClipOval(
        //         child: Image.asset(
        //           'assets/icons/launcher_icon.png',
        //           fit: BoxFit.cover,
        //           width: 50.0,
        //           height: 50,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.notes_rounded,
              size: 30,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SearchScreen(
                          cards: _cards,
                        )));
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
      drawer: Drawer(
          backgroundColor: Colors.teal[50],
          child: DrawerChild(
            cards: _cards,
          )),
      body: RefreshIndicator(
        onRefresh: _refreshCards,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.005),
                const Text(
                  'Saved Cards',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildCardList(context, screenWidth, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardList(
      BuildContext context, double screenWidth, double screenHeight) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    } else if (_error != null) {
      return Center(child: Text(_error!));
    } else if (_cards.isEmpty) {
      return const Center(child: Text('No cards added yet.'));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _cards
            .map((card) =>
                _buildCardItem(card, context, screenWidth, screenHeight))
            .toList(),
      );
    }
  }

  Widget _buildCardItem(CardModel card, BuildContext context,
      double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CardDetails(
                      id: card.id,
                      name: card.name,
                      industry: card.industry,
                      sector: card.sector,
                      companyName: card.companyName,
                      date: card.date,
                      venue: card.venue,
                      cardImage: '${Constants.uri}${card.cardImage}',
                      companyAddress: card.companyAddress,
                      designation: card.designation,
                      category: card.category,
                      personalAddress: card.personalAddress,
                      website: card.website,
                      email: card.email,
                      mobile: card.mobile,
                      telephone: card.telephone,
                      whatsapp: card.whatsapp,
                      initalNotes: card.initialNotes,
                      additionalNotes: card.additionalNotes,
                    ),
                  ));
                },
                child: CachedNetworkImage(
                  imageUrl: '${Constants.uri}${card.cardImage}',
                  fit: BoxFit.cover,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}
