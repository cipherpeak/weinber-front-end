class MeetingModel {
  final int id;
  final String title;
  final String date;
  final String time;
  final String location;

  MeetingModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: int.parse(json["id"].toString()),
      title: json["title"] ?? "",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      location: json["location"] ?? "",
    );
  }
}
