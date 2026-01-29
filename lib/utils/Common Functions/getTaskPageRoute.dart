import '../../core/constants/page_routes.dart';

String getTaskRoute(String? employeeType, String? company) {
  final type = employeeType?.toLowerCase().trim();
  final comp = company?.toLowerCase().trim();

  // 🔧SERVICE LOGIC (company-based)
  if (type == "service") {
    if (comp == "dax") {
      return routerDaxTaskPage;
    } else if (comp == "advantage") {
      return routerAdvantageTaskPage;
    } else {
      // any other company but service employee
      return routerDaxTaskPage;
    }
  }

  //  DELIVERY (same for all companies)
  if (type == "deliver") {
    return routerDeliveryTaskPage;
  }

  //  OFFICE
  if (type == "office") {
    return routerNotesPage;
  }

  //  MECHANIC
  if (type == "mechanic") {
    return routerTechnicianTaskPage;
  }

  //  fallback safety
  return routerAdvantageTaskPage;
}