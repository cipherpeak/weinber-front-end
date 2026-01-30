class AdvantageTaskStartDetails {
  final String taskId;
  final String detailingSite;
  final String plu;
  final String category;
  final String subService;
  final String chassisNumber;
  final String startedAt;
  final String status;
  final String? image;


  AdvantageTaskStartDetails({
    required this.taskId,
    required this.detailingSite,
    required this.plu,
    required this.category,
    required this.subService,
    required this.chassisNumber,
    required this.startedAt,
    required this.status,
    this. image
  });

  factory AdvantageTaskStartDetails.fromJson(Map<String, dynamic> json) {
    return AdvantageTaskStartDetails(
      taskId: json['task_id'],
      detailingSite: json['detailing_site'],
      plu: json['plu'],
      category: json['category'],
      subService: json['sub_service'],
      chassisNumber: json['chassis_number'],
      startedAt: json['started_at'],
      status: json['status'],
      image: json['image'],
    );
  }
}
