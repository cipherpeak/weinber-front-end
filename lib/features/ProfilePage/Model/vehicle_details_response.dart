class VehicleDetailsResponse {
  final VehicleData? currentVehicle;
  final VehicleData? temporaryVehicle;

  VehicleDetailsResponse({
    required this.currentVehicle,
    required this.temporaryVehicle,
  });

  factory VehicleDetailsResponse.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsResponse(
      currentVehicle: json["current_vehicle"] != null
          ? VehicleData.fromJson(json["current_vehicle"])
          : null,
      temporaryVehicle: json["temporary_vehicle"] != null
          ? VehicleData.fromJson(json["temporary_vehicle"])
          : null,
    );
  }
}

class VehicleData {
  final String? vehicleImage;
  final String? vehicleNumber;
  final String? model;
  final String? vehicleType;
  final String? assignedDate;
  final String? endingDate;
  final String? insuranceExpiryDate;
  final String? fuelType;
  final String? odometerStartKm;
  final String? odometerEndKm;
  final List<VehicleIssue> reportedIssues;

  VehicleData({
    required this.vehicleImage,
    required this.vehicleNumber,
    required this.model,
    required this.vehicleType,
    required this.assignedDate,
    required this.endingDate,
    required this.insuranceExpiryDate,
    required this.fuelType,
    required this.odometerStartKm,
    required this.odometerEndKm,
    required this.reportedIssues,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      vehicleImage: json["vehicle_image"],
      vehicleNumber: json["vehicle_number"],
      model: json["model"],
      vehicleType: json["vehicle_type"],
      assignedDate: json["assigned_date"],
      endingDate: json["ending_date"],
      insuranceExpiryDate: json["insurance_expiry_date"],
      fuelType: json["fuel_type"],
      odometerStartKm: json["odometer_start_km"]?.toString(),
      odometerEndKm: json["odometer_end_km"]?.toString(),
      reportedIssues: (json["reported_vehicle_issues"] as List? ?? [])
          .map((e) => VehicleIssue.fromJson(e))
          .toList(),
    );
  }
}

class VehicleIssue {
  final String title;
  final String status;
  final String reportedBy;
  final String date;

  VehicleIssue({
    required this.title,
    required this.status,
    required this.reportedBy,
    required this.date,
  });

  factory VehicleIssue.fromJson(Map<String, dynamic> json) {
    return VehicleIssue(
      title: json["title"] ?? "",
      status: json["status"] ?? "",
      reportedBy: json["reported_by"] ?? "",
      date: json["date"] ?? "",
    );
  }
}
