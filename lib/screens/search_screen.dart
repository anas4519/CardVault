import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/screens/card_details.dart';
import 'package:business_card_manager/models/card_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  

  static List<CardModel> displayList = List.from(Constants.dummyList);

  void updateList(String value) {
    setState(() {
      displayList = Constants.dummyList
          .where((card) =>
              card.name.toLowerCase().contains(value.toLowerCase()) ||
              card.companyName.toLowerCase().contains(value.toLowerCase()) ||
              card.industry.toLowerCase().contains(value.toLowerCase()) ||
              (card.designation?.toLowerCase() ?? '')
                  .contains(value.toLowerCase()) ||
              card.sector.toLowerCase().contains(value.toLowerCase()) ||
              (card.category?.toLowerCase() ?? '')
                  .contains(value.toLowerCase()) ||
              card.venue.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.005),
            const Text(
              'Search for a Card',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Container(
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                    border: Border.all(color: Colors.teal, width: 2)),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search_rounded, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => updateList(value),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for name, company, industry...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(displayList[index].name),
                    subtitle: Text(displayList[index].companyName),
                    trailing: Text(displayList[index].venue),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => CardDetails(
                            name: displayList[index].name,
                            industry: displayList[index].industry,
                            sector: displayList[index].sector,
                            companyName: displayList[index].companyName,
                            designation: displayList[index].designation,
                            companyAddress: displayList[index].companyAddress,
                            personalAddress: displayList[index].personalAddress,
                            email: displayList[index].email,
                            website: displayList[index].website,
                            telephone: displayList[index].telephone,
                            mobile: displayList[index].mobile,
                            whatsapp: displayList[index].whatsapp,
                            date: displayList[index].date,
                            venue: displayList[index].venue,
                            category: displayList[index].category,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
