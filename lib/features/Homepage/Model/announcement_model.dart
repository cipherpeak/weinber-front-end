class AnnouncementModel {
  final int id;
  final String heading;
  final String description;
  final DateTime date;

  AnnouncementModel({
    required this.id,
    required this.heading,
    required this.description,
    required this.date,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json["id"],
      heading: json["heading"] ?? "",
      description: json["description"] ?? "",
      date: DateTime.parse(json["date"]),
    );
  }
}
