import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardDetails extends StatefulWidget {
  final String name;
  final String industry;
  final String sector;
  final String companyName;
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
    this.category,
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
      Spacer(),
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
              child: Image.asset('assets/IMG-20240917-WA0011~2.jpg'),
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
          ],
        ),
      ),
    );
  }
}
