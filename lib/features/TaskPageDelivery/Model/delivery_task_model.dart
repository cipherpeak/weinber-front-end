class DeliveryTaskModel {
  final int id;
  final String deliveryId;
  final String customerName;
  final String location;
  final String priority;

  DeliveryTaskModel({
    required this.id,
    required this.deliveryId,
    required this.customerName,
    required this.location,
    required this.priority,
  });

  factory DeliveryTaskModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTaskModel(
      id: json["id"] ?? 0,
      deliveryId: json["DeliveryId"] ?? "",
      customerName: json["customer_name"] ?? "",
      location: json["delivery_location"] ?? "",
      priority: json["task_priority"] ?? "",
    );
  }

  bool get isHighPriority =>
      priority.toLowerCase() == "urgent" ||
          priority.toLowerCase() == "high";
}
