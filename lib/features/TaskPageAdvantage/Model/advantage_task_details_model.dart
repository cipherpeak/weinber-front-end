class AdvantageTaskDetails {
  final int id;
  final String detailingSite;
  final String plu;
  final String category;
  final String subService;
  final String chassisNumber;
  final String? image;

  AdvantageTaskDetails({
    required this.id,
    required this.detailingSite,
    required this.plu,
    required this.category,
    required this.subService,
    required this.chassisNumber,
    this.image,
  });

  factory AdvantageTaskDetails.fromJson(Map<String, dynamic> json) {
    return AdvantageTaskDetails(
      id: json['id'],
      detailingSite: json['detailing_site'],
      plu: json['plu'],
      category: json['category'],
      subService: json['sub_service'],
      chassisNumber: json['chassis_number'],
      image: json['image'],
    );
  }
}
