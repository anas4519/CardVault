import 'dart:convert';
import 'dart:io';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/home_screen.dart';
import 'package:business_card_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/models/card_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ApiService {
  Future<List<CardModel>> fetchUserCards(String userID) async {
    final response =
        await http.get(Uri.parse('${Constants.uri}/card/user/$userID'));
    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);
      print(data);
      return data.map((json) => CardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<void> postData(
    String name,
    String industry,
    String sector,
    String companyName,
    String venue,
    DateTime date, // Date is now DateTime, convert to string later
    File image,
    BuildContext context, {
    String? designation,
    String? companyAddress,
    String? personalAddress,
    String? email,
    String? website,
    String? telephone,
    String? mobile,
    String? whatsapp,
    String? category,
  }) async {
    final url =
        Uri.parse('${Constants.uri}/card/'); // Replace with your actual URL

    try {
      var request = http.MultipartRequest('POST', url);
      var user = Provider.of<UserProvider>(context, listen: false).user;

      // Add text fields to the request
      request.fields['name'] = name;
      request.fields['industry'] = industry;
      request.fields['sector'] = sector;
      request.fields['companyName'] = companyName;
      request.fields['venue'] = venue;
      request.fields['date'] =
          date.toIso8601String(); // Convert DateTime to ISO string
      request.fields['user_id'] = user.id; // Ensure user ID is added

      // Optionally add nullable fields
      if (designation != null) request.fields['designation'] = designation;
      if (companyAddress != null)
        request.fields['companyAddress'] = companyAddress;
      if (personalAddress != null)
        request.fields['personalAddress'] = personalAddress;
      if (email != null) request.fields['email'] = email;
      if (website != null) request.fields['website'] = website;
      if (telephone != null) request.fields['telephone'] = telephone;
      if (mobile != null) request.fields['mobile'] = mobile;
      if (whatsapp != null) request.fields['whatsapp'] = whatsapp;
      if (category != null) request.fields['category'] = category;

      // Add the image file to the request
      var multipartFile = await http.MultipartFile.fromPath(
        "cardImage", // Use the correct field name as per your Node.js schema
        image.path,
        filename: basename(image.path), // Ensure the file name is sent
      );

      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        showSnackBar(context, 'Card added successfully!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const HomeScreen()),
          (route) => false,
        );
      } else {
        showSnackBar(
            context, 'Failed to add card. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }
}
