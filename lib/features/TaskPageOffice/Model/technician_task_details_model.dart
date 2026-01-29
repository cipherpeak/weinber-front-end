class TechnicianTaskDetails {
  final String? heading;
  final String siteNumber;
  final String machineType;
  final String bayNumber;
  final String machineSerialNumber;
  final String sparePartDetails;
  final int quantity;
  final String jobDescription;
  final String partNumber;
  final String item;
  final String status;

  TechnicianTaskDetails({
    required this.heading,
    required this.siteNumber,
    required this.machineType,
    required this.bayNumber,
    required this.machineSerialNumber,
    required this.sparePartDetails,
    required this.quantity,
    required this.jobDescription,
    required this.partNumber,
    required this.item,
    required this.status,
  });

  factory TechnicianTaskDetails.fromJson(Map<String, dynamic> json) {
    return TechnicianTaskDetails(
      heading: json["heading"],
      siteNumber: json["Site_number"] ?? "",
      machineType: json["Machine_type"] ?? "",
      bayNumber: json["bay_number"] ?? "",
      machineSerialNumber: json["Machine_serial_number"] ?? "",
      sparePartDetails: json["spare_part_details"] ?? "",
      quantity: json["quantity"] ?? 0,
      jobDescription: json["job_description"] ?? "",
      partNumber: json["part_number"] ?? "",
      item: json["item"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
