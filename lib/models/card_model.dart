class CardModel {
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
  final String? cardImage;
  final String id;
  final String? initialNotes;
  final String? additionalNotes;

  CardModel({
    required this.id,
    required this.name,
    required this.industry,
    required this.sector,
    required this.companyName,
    required this.date,
    required this.venue,
    this.designation,
    this.companyAddress,
    this.personalAddress,
    this.email,
    this.website,
    this.mobile,
    this.telephone,
    this.category,
    this.whatsapp,
    this.cardImage,
    this.initialNotes,
    this.additionalNotes
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: json['name'],
      industry: json['industry'],
      sector: json['sector'],
      companyName: json['companyName'],
      designation: json['designation'],
      companyAddress: json['companyAddress'],
      personalAddress: json['personalAddress'],
      email: json['email'],
      website: json['website'],
      telephone: json['telephone'],
      mobile: json['mobile'],
      whatsapp: json['whatsapp'],
      date: DateTime.parse(json['date']), // Assuming date is a String in ISO format
      venue: json['venue'],
      category: json['category'],
      cardImage: json['cardImage'],
      id: json['_id'],
      initialNotes: json['initialNotes'],
      additionalNotes: json['additionalNotes']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'industry': industry,
      'sector': sector,
      'companyName': companyName,
      'designation': designation,
      'companyAddress': companyAddress,
      'personalAddress': personalAddress,
      'email': email,
      'website': website,
      'telephone': telephone,
      'mobile': mobile,
      'whatsapp': whatsapp,
      'date': date.toIso8601String(), // Convert DateTime to ISO String
      'venue': venue,
      'category': category,
      'cardImage': cardImage,
      'initalNotes' : initialNotes,
      'additionalNotes' : additionalNotes
    };
  }
}
