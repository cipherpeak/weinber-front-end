class LeaveDetailResponse {
  final bool success;
  final String message;
  final LeaveDetail data;

  LeaveDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaveDetailResponse.fromJson(Map<String, dynamic> json) {
    return LeaveDetailResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: LeaveDetail.fromJson(json["data"] ?? {}),
    );
  }
}

class LeaveDetail {
  final int id;
  final String category;
  final String startDate;
  final String endDate;
  final String totalDays;
  final String reason;
  final String status;
  final String employeeName;
  final String employeeId;
  final String passportFrom;
  final String passportTo;
  final String addressDuringLeave;
  final String? ticketEligibility;
  final String? attachmentUrl;
  final String? signatureUrl;
  final String? approvedByName;
  final String rejectionReason;

  LeaveDetail({
    required this.id,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    required this.employeeName,
    required this.employeeId,
    required this.passportFrom,
    required this.passportTo,
    required this.addressDuringLeave,
    this.ticketEligibility,
    this.attachmentUrl,
    this.signatureUrl,
    this.approvedByName,
    required this.rejectionReason,
  });

  factory LeaveDetail.fromJson(Map<String, dynamic> json) {
    return LeaveDetail(
      id: json["id"] ?? 0,
      category: json["category"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      totalDays: json["total_days"] ?? "0",
      reason: json["reason"] ?? "",
      status: json["status"] ?? "",
      employeeName: json["employee_name"] ?? "",
      employeeId: json["employee_id"] ?? "",
      passportFrom: json["passport_required_from"] ?? "",
      passportTo: json["passport_required_to"] ?? "",
      addressDuringLeave: json["address_during_leave"] ?? "",
      ticketEligibility: json["ticket_eligibility"],
      attachmentUrl: json["attachment_url"],
      signatureUrl: json["signature_url"],
      approvedByName: json["approved_by_name"],
      rejectionReason: json["rejection_reason"] ?? "",
    );
  }
}
