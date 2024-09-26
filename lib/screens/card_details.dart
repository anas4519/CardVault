import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/screens/home_screen.dart';
import 'package:business_card_manager/services/api_service.dart';
import 'package:business_card_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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
  final String? initalNotes;
  final String? additionalNotes;

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
    this.initalNotes,
    this.additionalNotes,
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // You can show an error message if the call can't be initiated
      print('Could not launch $callUri');
    }
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SelectableText(value),
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

  Future<void> _generateAndViewPDF() async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    final response = await http.get(Uri.parse(widget.cardImage));
    final image = pw.MemoryImage(response.bodyBytes);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(image, width: 300, height: 200)),
              pw.SizedBox(height: 20),
              pw.Text('Name:   ${widget.name}', style: pw.TextStyle(font: ttf)),
              pw.Text('Industry:   ${widget.industry}',
                  style: pw.TextStyle(font: ttf)),
              pw.Text('Sector:   ${widget.sector}',
                  style: pw.TextStyle(font: ttf)),
              pw.Text('Company Name:   ${widget.companyName}',
                  style: pw.TextStyle(font: ttf)),
              if (widget.designation != null)
                pw.Text('Designation:   ${widget.designation}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.companyAddress != null)
                pw.Text('Company Address:   ${widget.companyAddress}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.personalAddress != null)
                pw.Text('Personal Address:   ${widget.personalAddress}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.email != null)
                pw.Text('Email:   ${widget.email}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.website != null)
                pw.Text('Website:   ${widget.website}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.telephone != null)
                pw.Text('Telephone:   ${widget.telephone}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.mobile != null)
                pw.Text('Mobile:   ${widget.mobile}',
                    style: pw.TextStyle(font: ttf)),
              if (widget.whatsapp != null)
                pw.Text('WhatsApp:   ${widget.whatsapp}',
                    style: pw.TextStyle(font: ttf)),
              pw.Text(
                  'Card Received Date:   ${widget.date.day}-${widget.date.month}-${widget.date.year}',
                  style: pw.TextStyle(font: ttf)),
              pw.Text('Card Received Venue:   ${widget.venue}',
                  style: pw.TextStyle(font: ttf)),
              if (widget.category != null)
                pw.Text('Category:   ${widget.category}',
                    style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text('Initial Notes:\n${_initialnotesController.text}',
                  style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text('Additional Notes:\n${_additionalNotesController.text}',
                  style: pw.TextStyle(font: ttf)),
            ],
          ),
        ],
      ),
    );

    // Save the PDF file temporarily
    final output = await getTemporaryDirectory();
    final filePath = "${output.path}/business_card_${widget.name}.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Attempt to open the PDF
    final result = await OpenFile.open(file.path);

    // Check for detailed result info
    if (result.type != ResultType.done) {
    } else {
      print("PDF opened successfully!");
    }
  }

  bool _isInitialEditable = false;
  final TextEditingController _initialnotesController = TextEditingController();
  bool _isEditable = false;
  final TextEditingController _additionalNotesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initalNotes != null) {
      _initialnotesController.text = widget.initalNotes!;
    }
    if (widget.additionalNotes != null) {
      _additionalNotesController.text = widget.additionalNotes!;
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _initialnotesController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.companyName,
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                  onLongPress: () {}, child: Image.network(widget.cardImage)),
            ),
            SizedBox(height: screenHeight * 0.04),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailColumn('Name', widget.name),
                  const Divider(
                    color: Colors.teal,
                  ),
                  _buildDetailColumn('Industry', widget.industry),
                  const Divider(
                    color: Colors.teal,
                  ),
                  _buildDetailColumn('Sector', widget.sector),
                  const Divider(
                    color: Colors.teal,
                  ),
                  _buildDetailColumn('Company Name', widget.companyName),
                  const Divider(
                    color: Colors.teal,
                  ),
                  if (widget.designation?.isNotEmpty ?? false) ...[
                    _buildDetailColumn('Designation', widget.designation!),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.companyAddress?.isNotEmpty ?? false) ...[
                    _buildDetailColumn(
                        'Company Address', widget.companyAddress!),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.personalAddress?.isNotEmpty ?? false) ...[
                    _buildDetailColumn(
                        'Personal Address', widget.personalAddress!),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.email?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        _buildDetailColumn('Email', widget.email!),
                        const Spacer(),
                        IconButton(
                            onPressed: () => _sendEmail(widget.email!),
                            icon: const Icon(
                              Icons.email,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.website?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        _buildDetailColumn('Website', widget.website!),
                        const Spacer(),
                        IconButton(
                            onPressed: () => _launchURL(widget.website!),
                            icon: const Icon(
                              Icons.public,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.telephone?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        _buildDetailColumn('Telephone', widget.telephone!),
                        const Spacer(),
                        IconButton(
                            onPressed: () => _makePhoneCall(widget.telephone!),
                            icon: const Icon(
                              Icons.call,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.mobile?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        _buildDetailColumn('Mobile Number', widget.mobile!),
                        const Spacer(),
                        IconButton(
                            onPressed: () => _makePhoneCall(widget.mobile!),
                            icon: const Icon(
                              Icons.call,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    const Divider(color: Colors.teal),
                  ],
                  if (widget.whatsapp?.isNotEmpty ?? false) ...[
                    Row(
                      children: [
                        _buildDetailColumn('WhatsApp Number', widget.whatsapp!),
                        const Spacer(),
                        IconButton(
                            onPressed: () => _launchURL(widget.whatsapp!),
                            icon: const Icon(
                              Icons.call,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    const Divider(color: Colors.teal),
                  ],
                  _buildDetailColumn('Card Recieved Date',
                      "${widget.date.day}-${widget.date.month}-${widget.date.year}"),
                  const Divider(color: Colors.teal),
                  _buildDetailColumn('Card Recieved Venue', widget.venue),
                  if (widget.category?.isNotEmpty ?? false) ...[
                    const Divider(color: Colors.teal),
                    _buildDetailColumn('Category', widget.category!),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Initial Notes',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextField(
              controller: _initialnotesController,
              enabled: _isInitialEditable,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.teal[100],
                contentPadding: EdgeInsets.all(screenWidth * 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isInitialEditable =
                            !_isInitialEditable; // Toggles edit mode
                      });
                    },
                    icon: Icon(
                      _isInitialEditable ? Icons.lock_open : Icons.edit,
                    )),
                IconButton(
                  onPressed: () {
                    ApiService().updateInitialNotes(
                        _initialnotesController.text, widget.id, context);
                    if (_isEditable) {
                      setState(() {
                        _isEditable = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Additional Notes',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextField(
              controller: _additionalNotesController,
              enabled: _isEditable,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.teal[100],
                contentPadding: EdgeInsets.all(screenWidth * 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isEditable = !_isEditable; // Toggles edit mode
                      });
                    },
                    icon: Icon(
                      _isEditable ? Icons.lock_open : Icons.edit,
                    )),
                IconButton(
                  onPressed: () {
                    if (_isEditable) {
                      ApiService().updateAdditionalNotes(
                          _additionalNotesController.text, widget.id, context);
                      setState(() {
                        _isEditable = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: TextButton(
                onPressed: () async {
                  _generateAndViewPDF();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.teal),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.download),
                    SizedBox(width: screenWidth * 0.02),
                    const Text('Download as PDF',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            SizedBox(
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
          ],
        ),
      ),
    );
  }
}
