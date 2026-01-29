class DeliveryTaskModel {
  final int id;
  final String deliveryId;
  final String customerName;
  final String location;
  final String priority;
  final String status;

  DeliveryTaskModel({
    required this.id,
    required this.deliveryId,
    required this.customerName,
    required this.location,
    required this.priority,
    required this.status
  });

  factory DeliveryTaskModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTaskModel(
      id: json["id"] ?? 0,
      deliveryId: json["DeliveryId"] ?? "",
      customerName: json["customer_name"] ?? "",
      location: json["delivery_location"] ?? "",
      priority: json["task_priority"] ?? "",
      status: json["status"] ?? "",
    );
  }

  bool get isHighPriority =>
      priority.toLowerCase() == "urgent" ||
          priority.toLowerCase() == "high";
}
