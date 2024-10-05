import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/screens/card_details.dart';
import 'package:business_card_manager/models/card_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final List<CardModel> cards;
  const SearchScreen({super.key, required this.cards});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<CardModel> displayList = [];
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    displayList = widget.cards;
  }

  void updateList(String value) {
    setState(() {
      _isFiltered = true;
      displayList = widget.cards.where((card) {
        return card.name.toLowerCase().contains(value.toLowerCase()) ||
            card.companyName.toLowerCase().contains(value.toLowerCase()) ||
            card.industry.toLowerCase().contains(value.toLowerCase()) ||
            (card.designation?.toLowerCase() ?? '').contains(value.toLowerCase()) ||
            card.sector.toLowerCase().contains(value.toLowerCase()) ||
            (card.category?.toLowerCase() ?? '').contains(value.toLowerCase()) ||
            (card.initialNotes?.toLowerCase() ?? '').contains(value.toLowerCase()) ||
            (card.additionalNotes?.toLowerCase() ?? '').contains(value.toLowerCase()) ||
            card.venue.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  void _showFilterMenu(BuildContext context, String filterType, List<String> options) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: options.map((option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _isFiltered = true;
          displayList = widget.cards.where((card) {
            switch (filterType) {
              case 'Industry':
                return card.industry.toLowerCase().contains(value.toLowerCase());
              case 'Sector':
                return card.sector.toLowerCase().contains(value.toLowerCase());
              case 'Category':
                return (card.category?.toLowerCase() ?? '').contains(value.toLowerCase());
              default:
                return false;
            }
          }).toList();
        });
      }
    });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
      displayList = widget.cards;
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
            Row(
              children: [
                const Text(
                  'Search for a Card',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'RemoveFilter',
                        child: const Text('Remove Filter'),
                        onTap: _removeFilter, // Resets the filter
                      ),
                      PopupMenuItem<String>(
                        value: 'Sector',
                        child: const Text('Filter by Sector'),
                        onTap: () {
                          _showFilterMenu(context, 'Sector', Constants.sectors);
                        },
                      ),
                      PopupMenuItem<String>(
                        value: 'Category',
                        child: const Text('Filter by Category'),
                        onTap: () {
                          _showFilterMenu(context, 'Category', Constants.categories);
                        },
                      ),
                      PopupMenuItem<String>(
                        value: 'Industry',
                        child: const Text('Filter by Industry'),
                        onTap: () {
                          _showFilterMenu(context, 'Industry', Constants.industries);
                        },
                      ),
                    ];
                  },
                  icon: _isFiltered
                      ? const Icon(Icons.filter_list_off_rounded)
                      : const Icon(Icons.filter_list_rounded),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Container(
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
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
                            initalNotes: displayList[index].initialNotes,
                            additionalNotes: displayList[index].additionalNotes,
                            cardImage: '${Constants.uri}${displayList[index].cardImage!}',
                            id: displayList[index].id,
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
