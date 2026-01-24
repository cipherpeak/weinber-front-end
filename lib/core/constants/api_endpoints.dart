class ApiEndpoints {
  static const String baseUrl = _demoBaseUrl;


  static const String _liveBaseUrl = 'https://www.cipher-peak.com/api';

  static const String _demoBaseUrl = 'https://admin.emphubhr.com/api';

  static const String mediaBaseUrl = 'https://admin.emphubhr.com';

  // static String refresh = '';

  static const String login = '/auth/login/';
  static const String home = '/home/';
  static const String notification = '/home/notifications/';
  static const String meetingList = '/office/meetings/list/';
  static const String createMeeting = '/office/meetings/create/';
  static const String employeeListForMeeting = '/office/employees/list/';
  static const companyAnnouncements = "/home/company-announcements/";
  static const String logout = '/logout/';
  static const String profile = '/profile/';
  static const String personalInformation = '/profile/personal-information/';
  static const String personalInformationEdit = '/profile/personal-information/update/';

  static const String visaDocument = '/profile/visa-documents/';
  static const String employeeInformation = '/profile/employee-information/';
  static const String visaDocumentUpdate = '/profile/visa-documents/update/';
  static const vehicleDetails = "/profile/vehicle-details/";
  static const reportedVehicleDetails = "/profile/vehicle-report-details/";
  static const reportVehicleIssue = "/profile/vehicle-report/";

  static const createTemporaryVehicle =
      "/profile/create-temporary-vehicle/";
  static const leaveList = "/home/leave-list/";
  static const leaveApply =  "/home/leave-apply/";
  static const leaveDetails = "/home/leave/";
  static const reportIssue = "/profile/report-issue/";
  static const startBreak = "/home/break/start/";
  static const endBreak = "/home/break/end/";
  static const extendBreak = "/home/break/extend/";
  static const String checkIn = "/home/checkin/";
  static const String checkOut = "/home/checkout/";
  static const String monthlyReview = "/home/monthly-review/";



  // Office
  static const notes = "/office/notes/";


}
