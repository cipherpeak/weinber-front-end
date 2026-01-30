class AdvantageTaskModel {
  final int id;
  final String detailingSite;
  final String category;
  final String status;

  AdvantageTaskModel({
    required this.id,
    required this.detailingSite,
    required this.category,
    required this.status,
  });

  factory AdvantageTaskModel.fromJson(Map<String, dynamic> json) {
    return AdvantageTaskModel(
      id: json['id'],
      detailingSite: json['detailing_site'],
      category: json['category'],
      status: json['status'],
    );
  }
}
