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
  final String? imageURL;

  CardModel(
      {required this.name,
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
      this.imageURL});
}
