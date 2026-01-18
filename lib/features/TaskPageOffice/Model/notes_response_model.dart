class NotesResponse {
  final List<OfficeNote> todayNotes;
  final List<OfficeNote> futureNotes;
  final List<OfficeNote> completedNotes;

  NotesResponse({
    required this.todayNotes,
    required this.futureNotes,
    required this.completedNotes,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    List safeList(dynamic v) {
      if (v is List) return v;
      return [];
    }

    return NotesResponse(
      todayNotes: safeList(json["today_notes"])
          .map((e) => OfficeNote.fromJson(e))
          .toList(),

      futureNotes: safeList(json["future_notes"])
          .map((e) => OfficeNote.fromJson(e))
          .toList(),

      completedNotes: safeList(json["completed_notes"])
          .map((e) => OfficeNote.fromJson(e))
          .toList(),
    );
  }

}

class OfficeNote {
  final int id;
  final String title;
  final String description;
  final String date;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfficeNote({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfficeNote.fromJson(Map<String, dynamic> json) {
    return OfficeNote(
      id: int.parse(json["id"].toString()),
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
