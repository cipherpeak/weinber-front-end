class NoteDetail {
  final int id;
  final String title;
  final String description;
  final String date;
  final String status;
  final String createdAt;
  final String updatedAt;

  NoteDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteDetail.fromJson(Map<String, dynamic> json) {
    return NoteDetail(
      id: int.parse(json["id"].toString()),
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}
