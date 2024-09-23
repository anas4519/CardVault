import 'dart:convert';
import 'package:business_card_manager/services/api_service.dart';
import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class BusinessCardScanner extends StatefulWidget {
  const BusinessCardScanner({super.key});

  @override
  State<BusinessCardScanner> createState() => _BusinessCardScannerState();
}

class _BusinessCardScannerState extends State<BusinessCardScanner> {
  final ImagePicker _picker = ImagePicker();
  File? _image; // Store the selected image
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _personalAddressController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _cardRecievedVenueCotroller =
      TextEditingController();
  final TextEditingController _initialNotesController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCategory;
  String? _selectedIndustry;
  String? _selectedSector;
  String? _selectedDesignation;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path); // Update the state with the selected image
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path); // Update the state with the captured image
      });
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: const CropAspectRatio(ratioX: 3.0, ratioY: 2.0),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
            lockAspectRatio: false,
            cropFrameColor: Colors.blue,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
              child: const Text('Take Photo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage();
              },
              child: const Text('Pick from Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    await classifyAndFillControllers(text);
  }

  Future<void> classifyAndFillControllers(String text) async {
    final gemini = Gemini.instance;

    // Prepare the prompt for Gemini
    String prompt = '''
    Classify the following text from a business card into these categories:
    1. Name
    2. Industry from the this list : ${Constants.industries.join(', ')}
    3. Company Name
    4. Sector from this list : ['Government', 'Semi Government', 'Private']
    5. Company Address
    6. Personal Address
    7. Email
    8. Website
    9. Telephone
    10. Mobile Phone
    11. WhatsApp
    12. Designation from this list : ${Constants.designations.join(', ')}
    
    If a category is not found, leave it blank. Here's the text:
    $text
    
    Respond in JSON format without any markdown formatting.
    ''';

    try {
      // Get the response from Gemini
      final response = await gemini.text(prompt);

      if (response != null && response.output!.isNotEmpty) {
        // Preprocess the response to remove Markdown formatting
        String processedResponse = preprocessResponse(response.output!);

        // Try to parse the JSON response
        Map<String, dynamic> classifiedData;
        try {
          classifiedData = jsonDecode(processedResponse);
          print(classifiedData);
        } catch (e) {
          classifiedData = extractInfoManually(processedResponse);
        }

        setState(() {
          _nameController.text = classifiedData['Name'] ?? '';
          _companyNameController.text = classifiedData['Company Name'] ?? '';
          _companyAddressController.text =
              classifiedData['Company Address'] ?? '';
          _personalAddressController.text =
              classifiedData['Personal Address'] ?? '';
          _emailController.text = classifiedData['Email'] ?? '';
          _websiteController.text = classifiedData['Website'] ?? '';
          _telephoneController.text = classifiedData['Telephone'] ?? '';
          _mobilePhoneController.text = classifiedData['Mobile Phone'] ?? '';
          _whatsappController.text = classifiedData['WhatsApp'] ?? '';
          _selectedIndustry = classifiedData['Industry'] != null &&
                  Constants.industries.contains(classifiedData['Industry'])
              ? classifiedData['Industry']
              : null;
          _selectedSector = classifiedData['Sector'] != null &&
                  Constants.sectors.contains(classifiedData['Sector'])
              ? classifiedData['Sector']
              : null;
          _selectedDesignation = classifiedData['Designation'] != null &&
                  Constants.designations.contains(classifiedData['Designation'])
              ? classifiedData['Designation']
              : null;
        });
      } else {
        print('No data returned from Gemini or empty response.');
      }
    } catch (e) {
      print('Error occurred while processing Gemini response: $e');
    }
  }

  String preprocessResponse(String response) {
    response = response.replaceAll(RegExp(r'```json\n?'), '');
    response = response.replaceAll(RegExp(r'\n?```'), '');
    response = response.trim();
    return response;
  }

  Map<String, String> extractInfoManually(String text) {
    Map<String, String> result = {};
    final patterns = {
      'Name': RegExp(r'"Name":\s*"([^"]*)"'),
      'Company Name': RegExp(r'"Company Name":\s*"([^"]*)"'),
      'Company Address': RegExp(r'"Company Address":\s*"([^"]*)"'),
      'Personal Address': RegExp(r'"Personal Address":\s*"([^"]*)"'),
      'Email': RegExp(r'"Email":\s*"([^"]*)"'),
      'Website': RegExp(r'"Website":\s*"([^"]*)"'),
      'Telephone': RegExp(r'"Telephone":\s*"([^"]*)"'),
      'Mobile Phone': RegExp(r'"Mobile Phone":\s*"([^"]*)"'),
      'WhatsApp': RegExp(r'"WhatsApp":\s*"([^"]*)"'),
    };

    patterns.forEach((key, pattern) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        result[key] = match.group(1)!;
      }
    });

    return result;
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Card'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (_image != null)
                  Column(
                    children: [
                      Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: _cropImage,
                            icon: const Icon(Icons.crop),
                          ),
                          TextButton(
                            onPressed: () => _extractText(_image!),
                            style: TextButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0), // Border color and width
                            ),
                            child: const Text(
                              'Autofill with AI',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                else
                  Container(
                    height: 200, // Adjust as needed
                    width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      color: Colors.teal[50],
                    ), // Light background color
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => _showImageSourceDialog(context),
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 50, // Adjust size as needed
                                color: Colors.teal,
                              )),
                          const Text('No image selected')
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Form starts here
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        value: _selectedCategory,
                        items: Constants.categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name *',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Industry *',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        value: _selectedIndustry,
                        items: Constants.industries.map((String industry) {
                          return DropdownMenuItem<String>(
                            value: industry,
                            child: Text(industry),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedIndustry = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an industry';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Sector *',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        value: _selectedSector,
                        items: Constants.sectors.map((String sector) {
                          return DropdownMenuItem<String>(
                            value: sector,
                            child: Text(sector),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSector = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a sector';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      TextFormField(
                        controller: _companyNameController,
                        decoration: InputDecoration(
                          labelText: 'Company Name *',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Designation',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        value: _selectedDesignation,
                        items: Constants.designations.map((String designation) {
                          return DropdownMenuItem<String>(
                            value: designation,
                            child: Text(designation),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDesignation = newValue;
                          });
                        },
                        // validator: (value) {
                        //   if (value == null) {
                        //     return 'Please select a designation';
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _companyAddressController,
                        decoration: InputDecoration(
                          labelText: 'Company Address',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter the company address';
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _personalAddressController,
                        decoration: InputDecoration(
                          labelText: 'Personal Address',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _websiteController,
                        decoration: InputDecoration(
                          labelText: 'Website',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _telephoneController,
                        decoration: InputDecoration(
                          labelText: 'Telephone',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _mobilePhoneController,
                        decoration: InputDecoration(
                          labelText: 'Mobile No.',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _whatsappController,
                        decoration: InputDecoration(
                          labelText: 'WhatsApp No.',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),

                      // Date Picker
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No date selected *'
                                  : 'Selected Date * : ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                            ),
                          ),
                          IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _cardRecievedVenueCotroller,
                        decoration: InputDecoration(
                          labelText: 'Card Recieved Venue *',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the venue where card was recieved';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _initialNotesController,
                        decoration: InputDecoration(
                          labelText: 'Initial Notes',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _additionalNotesController,
                        decoration: InputDecoration(
                          labelText: 'Additional Notes',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                SizedBox(
                  width: screenWidth * 0.8, // 80% of screen width
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_image != null) {
                          ApiService().postData(
                              _nameController.text,
                              _selectedIndustry!,
                              _selectedSector!,
                              _companyNameController.text,
                              _cardRecievedVenueCotroller.text,
                              _selectedDate!,
                              _image!,
                              context,
                              designation: _selectedDesignation,
                              companyAddress:
                                  _companyAddressController.text.isNotEmpty
                                      ? _companyAddressController.text
                                      : null,
                              personalAddress:
                                  _personalAddressController.text.isNotEmpty
                                      ? _personalAddressController.text
                                      : null,
                              email: _emailController.text.isNotEmpty
                                  ? _emailController.text
                                  : null,
                              website: _websiteController.text.isNotEmpty
                                  ? _websiteController.text
                                  : null,
                              telephone: _telephoneController.text.isNotEmpty
                                  ? _telephoneController.text
                                  : null,
                              mobile: _mobilePhoneController.text.isNotEmpty
                                  ? _mobilePhoneController.text
                                  : null,
                              whatsapp: _whatsappController.text.isNotEmpty
                                  ? _whatsappController.text
                                  : null,
                              category: _selectedCategory);
                        } else {
                          showSnackBar(context, 'Please select an image');
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.teal),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Smaller border radius
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 15.0), // Increase button height
                      ),
                    ),
                    child:
                        const Text('Add Card', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
