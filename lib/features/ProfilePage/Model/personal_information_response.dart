class PersonalInfoResponse {
  final String proPic;
  final String mobNumber;
  final String email;
  final String address;
  final String dob;
  final String nationality;
  final List<EmergencyContact> emergencyContacts;

  PersonalInfoResponse({
    required this.proPic,
    required this.mobNumber,
    required this.email,
    required this.address,
    required this.dob,
    required this.nationality,
    required this.emergencyContacts,
  });

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) {
    return PersonalInfoResponse(
      proPic: json["pro_pic"] ?? "",
      mobNumber: json["mob_number"] ?? "",
      email: json["email"] ?? "",
      address: json["employee_home_address"] ?? "",
      dob: json["dob"] ?? "",
      nationality: json["nationality"] ?? "",
      emergencyContacts: (json["emergency_contact_info"] as List? ?? [])
          .map((e) => EmergencyContact.fromJson(e))
          .toList(),
    );
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relation;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json["emergency_contacts_full_name"] ?? "",
      phone: json["mob_number"] ?? "",
      relation: json["relation_with_employee"] ?? "",
    );
  }
}
