class DeliveryTaskDetails {
  final String deliveryId;
  final String customerName;
  final String customerPhone;
  final String dueTime;
  final String notes;
  final String location;
  final String priority;

  DeliveryTaskDetails({
    required this.deliveryId,
    required this.customerName,
    required this.customerPhone,
    required this.dueTime,
    required this.notes,
    required this.location,
    required this.priority,
  });

  factory DeliveryTaskDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryTaskDetails(
      deliveryId: json["DeliveryId"] ?? "",
      customerName: json["customer_name"] ?? "",
      customerPhone: json["customer_phone"] ?? "",
      dueTime: json["due_time"] ?? "",
      notes: json["delivery_notes"] ?? "",
      location: json["delivery_location"] ?? "",
      priority: json["task_priority"] ?? "",
    );
  }
}
