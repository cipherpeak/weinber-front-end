class ServiceSelection {
  String? service;
  String? subService;
  String? subSubService;

  ServiceSelection({
    this.service,
    this.subService,
    this.subSubService,
  });
}

class CreateTaskModel {
  String? detailingSite;
  List<ServiceSelection> services;
  String? remarks;
  String? chassisNumber;
  String? vehicleModel;
  bool proofOfInvoice;

  CreateTaskModel({
    this.detailingSite,
    required this.services,
    this.remarks,
    this.chassisNumber,
    this.vehicleModel,
    required this.proofOfInvoice,
  });
}
final List<String> detailingSites = [
  "MG Dubai Showroom (SZR)",
  "Al Quoz Detailing Center",
  "Sharjah Industrial Area",
  "Abu Dhabi Main Branch",
];


final Map<String, List<String>> serviceMap = {
  "Tinting": ["Standard Tinting", "Premium Tinting"],
  "Ceramic Coating": ["1 Layer", "2 Layer", "3 Layer"],
  "Detailing": ["Interior", "Exterior"],
};

final Map<String, List<String>> subServiceMap = {
  "Standard Tinting": ["30%", "50%", "70%"],
  "Premium Tinting": ["30%", "50%", "70%"],
  "1 Layer": ["Exterior Only"],
  "2 Layer": ["Exterior + Interior"],
  "3 Layer": ["Complete Protection"],
  "Interior": ["Seats", "Dashboard"],
  "Exterior": ["Wash", "Polish"],
};
