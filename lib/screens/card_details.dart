import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/screens/home_screen.dart';
import 'package:business_card_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CardDetails extends StatefulWidget {
  final String name;
  final String industry;
  final String sector;
  final String companyName;
  final String cardImage;
  final String? designation;
  final String? companyAddress;
  final String? personalAddress;
  final String? email;
  final String? website;
  final String? telephone;
  final String? mobile;
  final String? whatsapp;
  final DateTime date;
  final String venue;
  final String? category;
  final String id;

  const CardDetails({
    super.key,
    required this.name,
    required this.industry,
    required this.sector,
    required this.companyName,
    this.designation,
    this.companyAddress,
    this.personalAddress,
    this.email,
    this.website,
    this.telephone,
    this.mobile,
    this.whatsapp,
    required this.date,
    required this.venue,
    required this.id,
    this.category,
    required this.cardImage,
  });

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse('https://$url');
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        // Flexible widget to allow value to wrap and align properly
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteCard() async {
    final response = await http.delete(
      Uri.parse(
          '${Constants.uri}/card/${widget.id}'), // Adjust the URL as needed
    );

    if (response.statusCode == 200) {
      // Optionally, show a success message
      showSnackBar(context, 'Card deleted successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      // Show an error message
      showSnackBar(context, 'Failed to delete card');
    }
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this card?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed Yes
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteCard(); // Call the delete function if confirmed
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(widget.cardImage),
            ),
            SizedBox(height: screenHeight * 0.04),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Name', widget.name),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Industry', widget.industry),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Sector', widget.sector),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Company Name', widget.companyName),
                  const Divider(color: Colors.grey),
                  if (widget.designation?.isNotEmpty ?? false) ...[
                    _buildDetailRow('Designation', widget.designation!),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.companyAddress?.isNotEmpty ?? false) ...[
                    _buildDetailRow('Company Address', widget.companyAddress!),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.personalAddress?.isNotEmpty ?? false) ...[
                    _buildDetailRow(
                        'Personal Address', widget.personalAddress!),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.email?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        const Text('Email', style: TextStyle(fontSize: 14)),
                        const Spacer(),
                        InkWell(
                          onTap: () => _sendEmail(widget.email!),
                          child: Text(
                            widget.email!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.website?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        const Text('Website', style: TextStyle(fontSize: 14)),
                        const Spacer(),
                        InkWell(
                          onTap: () => _launchURL(widget.website!),
                          child: Text(
                            widget.website!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.telephone?.isNotEmpty ?? false) ...[
                    _buildDetailRow('Telephone No', widget.telephone!),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.mobile?.isNotEmpty ?? false) ...[
                    _buildDetailRow('Mobile No', widget.mobile!),
                    const Divider(color: Colors.grey),
                  ],
                  if (widget.whatsapp?.isNotEmpty ?? false) ...[
                    _buildDetailRow('WhatsApp No', widget.whatsapp!),
                    const Divider(color: Colors.grey),
                  ],
                  _buildDetailRow('Card Recieved Date',
                      "${widget.date.day}-${widget.date.month}-${widget.date.year}"),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Card Recieved Venue', widget.venue),
                  if (widget.category?.isNotEmpty ?? false) ...[
                    const Divider(color: Colors.grey),
                    _buildDetailRow('Category', widget.category!),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.8, // 80% of screen width
                child: TextButton(
                  onPressed: () {
                    _confirmDelete();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Smaller border radius
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 15.0), // Increase button height
                    ),
                  ),
                  child:
                      const Text('Delete Card', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
