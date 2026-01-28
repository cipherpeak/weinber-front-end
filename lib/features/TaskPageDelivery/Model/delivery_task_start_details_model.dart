class DeliveryTaskStartDetails {
  final String deliveryId;
  final String customerName;
  final String customerPhone;
  final String dueTime;
  final String location;
  final String status;
  final String priority;

  DeliveryTaskStartDetails({
    required this.deliveryId,
    required this.customerName,
    required this.customerPhone,
    required this.dueTime,
    required this.location,
    required this.status,
    required this.priority,
  });

  factory DeliveryTaskStartDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryTaskStartDetails(
      deliveryId: json["DeliveryId"] ?? "",
      customerName: json["customer_name"] ?? "",
      customerPhone: json["customer_phone"] ?? "",
      dueTime: json["due_time"] ?? "",
      location: json["delivery_location"] ?? "",
      status: json["task_status"] ?? "",
      priority: json["task_priority"] ?? "",
    );
  }
}
