import 'package:business_card_manager/models/card_model.dart';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/business_card_scanner.dart';
import 'package:business_card_manager/screens/search_screen.dart';
import 'package:business_card_manager/services/auth_service.dart';
import 'package:business_card_manager/widgets/about_App.dart';
import 'package:business_card_manager/widgets/help_and_support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerChild extends StatelessWidget {
  final List<CardModel> cards;
  const DrawerChild({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    void signOut(BuildContext context) {
      AuthService().signOut(context);
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.height;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Padding(
      padding: EdgeInsets.only(
          top: screenHeight * 0.1,
          left: screenWidth * 0.02,
          right: screenWidth * 0.02,
          bottom: screenWidth * 0.02),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Text(
            user.name,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            user.email,
            style: const TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          const Divider(
            color: Colors.teal,
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: Colors.teal,
            ),
            title: const Text(
              'Home',
              style: const TextStyle(fontSize: 16),
            ),
            onTap: Navigator.of(context).pop,
          ),
          ListTile(
            leading: const Icon(
              Icons.document_scanner_rounded,
              color: Colors.teal,
            ),
            title: const Text(
              'Scan a Card',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const BusinessCardScanner()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.search_rounded,
              color: Colors.teal,
            ),
            title: const Text(
              'Search',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => SearchScreen(
                        cards: cards,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.teal,
            ),
            title: const Text(
              'About App',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const AboutApp()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.support_agent_rounded,
              color: Colors.teal,
            ),
            title: const Text(
              'Help and Support',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const HelpAndSupport()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.teal,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
