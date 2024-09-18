import 'dart:io';

import 'package:flutter/material.dart';

class SavedCards extends StatelessWidget {
  const SavedCards(
      {super.key,
      required this.image,
      required this.category,
      required this.name,
      required this.industry,
      required this.sector,
      required this.companyName,
      required this.designation,
      required this.address,
      required this.telephone,
      required this.date,
      required this.venue});
  final File image;
  final String category;
  final String name;
  final String industry;
  final String sector;
  final String companyName;
  final String designation;
  final String address;
  final String telephone;
  final DateTime date;
  final String venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Cards'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(image),
            SizedBox(height: 20),
            Text('Category = ${category}'),
            SizedBox(height: 12),
            Text('Name = ${name}'),
            SizedBox(height: 12),
            Text('Industry = ${industry}'),
            SizedBox(height: 12),
            Text('Sector = ${sector}'),
            SizedBox(height: 12),
            Text('Company Name = ${companyName}'),
            SizedBox(height: 12),
            Text('Designation = ${designation}'),
            SizedBox(height: 12),
            Text('Address = ${address}'),
            SizedBox(height: 12),
            Text('Telephone = ${telephone}'),
            SizedBox(height: 12),
            Text('Date recieved = ${date.toString()}'),
            SizedBox(height: 12),
            Text('Category = ${category}'),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
