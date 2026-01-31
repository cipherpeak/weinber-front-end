import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/features/AttendancePage/Presentation/Screens/AttendancePage.dart';
import 'package:weinber/features/BottomNavPage/Presentation/Screens/scheduleMeetingScreen.dart';
import 'package:weinber/features/Homepage/Presentation/Screens/TakeABreakPages/take_a_break_first_page.dart';
import 'package:weinber/features/Homepage/Presentation/Screens/announcementDetailsPage.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/Leave/LeavePage.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/Vehicle%20details/fine%20details%20page.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/Vehicle%20details/reportVehicleIssuePage.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/Vehicle%20details/reportedVehicleIssueDetailsPage.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/temporary_vehicle_usage.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/Vehicle%20details/vehicle_details_screen.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/visa_and_document.dart';
import 'package:weinber/features/ReportPage/Presentation/Screens/ReportPage.dart';
import 'package:weinber/features/TaskPageAdvantage/Presentation/Screens/advantageTaskInProgressPage.dart';
import 'package:weinber/features/TaskPageDax/Presentation/Screens/daxCreateTaskPage.dart';
import 'package:weinber/features/TaskPageTechnician/Presentation/Screens/technicianTaskDetailsPage.dart';
import 'package:weinber/features/TaskPageTechnician/Presentation/Screens/technicianTaskInProgressPage.dart';
import '../../features/Authentication/Login/Presentation/Screens/LoginPage.dart';
import '../../features/BottomNavPage/Presentation/Screens/bottom_nav_screen.dart';
import '../../features/BottomNavPage/Presentation/Screens/notification_page.dart';
import '../../features/ProfilePage/Presentation/Screens/Leave/LeaveDetailsScreen.dart';
import '../../features/ProfilePage/Presentation/Screens/Leave/leave_apply_page.dart';
import '../../features/ProfilePage/Presentation/Screens/Vehicle details/fines and penalties.dart';
import '../../features/ProfilePage/Presentation/Screens/employee_information_page.dart';
import '../../features/Homepage/Presentation/Screens/CheckInPages/check_in_first_page.dart';
import '../../features/Homepage/Presentation/Screens/CheckOutPages/check_out_first_page.dart';
import '../../features/Homepage/Presentation/Screens/Homepage.dart';
import '../../features/ProfilePage/Presentation/Screens/personal_information_screen.dart';
import '../../features/ProfilePage/Presentation/Screens/profile_page.dart';
import '../../features/Settings Page/Presentation/Screens/settings_screen.dart';

import '../../features/TaskPageAdvantage/Presentation/Screens/advantageCreateTaskPage.dart';
import '../../features/TaskPageAdvantage/Presentation/Screens/advantageTaskDetailsPage.dart';
import '../../features/TaskPageAdvantage/Presentation/Screens/advantageTaskPage.dart';
import '../../features/TaskPageDax/Presentation/Screens/daxTaskDetailsPage.dart';
import '../../features/TaskPageDax/Presentation/Screens/daxTaskInProgressPage.dart';
import '../../features/TaskPageDax/Presentation/Screens/daxTaskPage.dart';
import '../../features/TaskPageDelivery/Presentation/Screens/deliveryTaskDetailsPage.dart';
import '../../features/TaskPageDelivery/Presentation/Screens/deliveryTaskPage.dart';
import '../../features/TaskPageDelivery/Presentation/Screens/deliveryTaskStartTaskPage.dart';
import '../../features/TaskPageDelivery/Presentation/Screens/delivery_task_complete_screen.dart';
import '../../features/TaskPageOffice/Presentation/Screens/add_notes_screen.dart';
import '../../features/TaskPageOffice/Presentation/Screens/notes_details_screen.dart';
import '../../features/TaskPageOffice/Presentation/Screens/notes_screen.dart';
import '../../features/TaskPageTechnician/Presentation/Screens/technicianTaskCreatePage.dart';
import '../../features/TaskPageTechnician/Presentation/Screens/technicianTaskPage.dart';
import '../../features/splash/presentation/Screens/splash_screen.dart';

// 🧭 Route constants
const String routerSplash = '/';
const String routerLoginPage = '/login';

// Shell route
const String routerHomePage = '/app/home';
const String routerAnnouncementDetailsPage = '/app/home/announcement';

//Attendance
const String routerAttendancePage = '/app/attendance';
const String routerCheckInFirstPage = '/app/attendance/check_in_first';
const String routerCheckOutFirstPage = '/app/attendance/check_out_first';
const String routerTakeBreakPage = '/app/attendance/take_a_break_first';

//Report
const String routerReportPage = '/app/report';

//Notification
const String routerNotificationPage = '/app/home/notification';

//Meeting
const String routerScheduleMeetingPage =
    '/app/home/notification/schedule-meeting';

//Profile
const String routerProfilePage = '/app/home/profile';
const String routerSettingsPage = '/app/home/profile/setting';
const String routerEmployeeInformationPage =
    '/app/home/profile/employee-information';
const String routerPersonalInformationPage =
    '/app/home/profile/personal-information';
const String routerVisaAndDocumentPage = '/app/home/profile/visa-and-document';
const String routerVehicleDetailsPage = '/app/home/profile/vehicle-details';
const String routerReportVehicleIssuePage =
    '/app/home/profile/vehicle-details/report-vehicle-issue';
const String routerReportedVehicleDetailsPage =
    '/app/home/profile/vehicle-details/reported-vehicle-details';
const String routerTemporaryVehicleUsagePage =
    '/app/home/profile/temporary-vehicle-usage';
const String routerFinesAndPenaltiesPage =
    '/app/home/profile/vehicle-details/fines-and-penalties';
const String routerFinesAndPenaltiesDetailsPage =
    '/app/home/profile/vehicle-details/fines-and-penalties/details';
const String routerLeavePage = '/app/home/profile/leave';

const String routerLeaveApplyPage = '/app/home/profile/leave-apply';

const String routerLeaveDetailsPage = '/app/home/profile/leave/details';

//Dax Task
const String routerDaxTaskPage = '/app/task-dax';
const String routerDaxTaskInProgressPage = '/app/task-dax/details/start';
const String routerDaxTaskDetailsPage = '/app/task-dax/details';
const String routerDaxCreateTaskPage = '/app/task-dax/create-task';

//Advantage Task

const String routerAdvantageTaskPage = '/app/task-advantage';
const String routerAdvantageTaskDetailsPage = '/app/task-advantage/details';
const String routerAdvantageTaskInProgressPage =
    '/app/task-advantage/details/in-progress';
const String routerAdvantageCreateTaskPage = '/app/task-advantage/create-task';

// Office Task
const String routerNotesPage = '/app/notes';
const String routerNotesDetailsPage = '/app/notes/details';
const String routerAddNotesPage = '/app/notes/add-notes';

//Delivery Task
const String routerDeliveryTaskPage = '/app/delivery-task';
const String routerDeliveryTaskDetailsPage = '/app/delivery-task/details';
const String routerDeliveryTaskStartTaskPage =
    '/app/delivery-task/details/start';
const String routerDeliveryTaskCompletePage =
    '/app/delivery-task/details/complete';

//Technician Task
const String routerTechnicianTaskPage = '/app/technician-task';
const String routerTechnicianCreateTaskPage =
    '/app/technician-task/create-task';
const String routerTechnicianTaskDetailsPage = '/app/technician-task/details';
const String routerTechnicianTaskInProgressPage =
    '/app/technician-task/details/in-progress';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: routerSplash,
  debugLogDiagnostics: true,
  routes: [
    // --- Splash ---
    GoRoute(
      path: routerSplash,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Login ---
    GoRoute(
      path: routerLoginPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Main App Shell ---
    ShellRoute(
      parentNavigatorKey: rootNavigatorKey,
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => BottomNavScreen(child: child),
      routes: [
        GoRoute(
          path: routerHomePage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomepageScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: routerNotesPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const NotesScreen(),
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: routerDaxTaskPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DaxTaskScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: routerAdvantageTaskPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AdvantageTaskScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: routerDeliveryTaskPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DeliveryTaskScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: routerTechnicianTaskPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TechnicianTaskScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: routerAttendancePage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AttendanceScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: routerReportPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ReportScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
      ],
    ),

    GoRoute(
      path: routerAnnouncementDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AnnouncementDetailsPage(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerTechnicianCreateTaskPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TechnicianCreateTaskScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerTechnicianTaskDetailsPage,
      pageBuilder: (context, state) {
        final taskId = state.extra as int;
        return CustomTransitionPage(
          key: state.pageKey,
          child: TechnicianTaskDetailsScreen(taskId: taskId),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    GoRoute(
      path: routerTechnicianTaskInProgressPage,
      pageBuilder: (context, state) {
        final taskId = state.extra as int;
        return CustomTransitionPage(
          key: state.pageKey,
          child: TechnicianTaskInProgressScreen(taskId: taskId),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    GoRoute(
      path: routerDeliveryTaskDetailsPage,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return CustomTransitionPage(
          key: state.pageKey,
          child: DeliveryTaskDetailsScreen(
            taskId: data["id"],
            isCompleted: data["isCompleted"],
            status: data["status"], // ✅ correct
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    GoRoute(
      path: routerDeliveryTaskStartTaskPage,
      pageBuilder: (context, state) {
        final taskId = state.extra as int;
        return CustomTransitionPage(
          key: state.pageKey,
          child: DeliveryTaskStartTaskScreen(taskId: taskId),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    GoRoute(
      path: routerDeliveryTaskCompletePage,
      pageBuilder: (context, state) {
        final taskId = state.extra as int;
        return CustomTransitionPage(
          key: state.pageKey,
          child: DeliveryTaskCompleteScreen(taskId: taskId),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    GoRoute(
      path: routerAddNotesPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AddNoteScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerNotesDetailsPage,
      pageBuilder: (context, state) {
        final raw = state.extra;

        final int noteId = int.parse(raw.toString());
        return CustomTransitionPage(
          key: state.pageKey,
          child: NoteDetailsScreen(noteId: noteId),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    // --- Task details (outside shell) ---
    GoRoute(
      path: routerDaxTaskDetailsPage,
      pageBuilder: (context, state) {

        final data = state.extra as Map<String, dynamic>;
        final int taskId = data["taskId"];
        final String status = data["status"];
        return CustomTransitionPage(
        key: state.pageKey,
        child:  DaxTaskDetailsScreen(taskId: taskId, status: status,),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ); }
    ),

    GoRoute(
      path: routerDaxTaskInProgressPage,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final int taskId = data["taskId"];

        return CustomTransitionPage(
          key: state.pageKey,
          child: DaxTaskInProgressScreen(taskId: taskId),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    GoRoute(
      path: routerDaxCreateTaskPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DaxCreateTaskScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerAdvantageTaskDetailsPage,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final int taskId = data["taskId"];
        final String status = data["status"];

        return CustomTransitionPage(
          key: state.pageKey,
          child: AdvantageTaskDetailsScreen(
            taskId: taskId,
            status: status,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),


    GoRoute(
      path: routerAdvantageTaskInProgressPage,
      pageBuilder: (context, state) {
        final taskId = state.extra as int;
        return  CustomTransitionPage(
          key: state.pageKey,
          child:  AdvantageTaskInProgressScreen(taskId: taskId,),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}
    ),

    GoRoute(
      path: routerAdvantageCreateTaskPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AdvantageCreateTaskScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerCheckInFirstPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CheckInFirstPage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerCheckOutFirstPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CheckOutFirstPage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerTakeBreakPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TakeABreakFirstPage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Profile Page (outside shell) ---
    GoRoute(
      path: routerProfilePage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProfileScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Notification Page (outside shell) ---
    GoRoute(
      path: routerNotificationPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotificationScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerScheduleMeetingPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ScheduleMeetingScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Setting Screen ---
    GoRoute(
      path: routerSettingsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerLeavePage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: LeaveScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerLeaveApplyPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: LeaveApplyPage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerLeaveDetailsPage,
      pageBuilder: (context, state) {
        final leaveId = state.extra is int ? state.extra as int : 0;
        return CustomTransitionPage(
          key: state.pageKey,
          child: LeaveDetailsScreen(leaveId: leaveId),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),

    // --- Employee Information Screen ---
    GoRoute(
      path: routerEmployeeInformationPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: EmployeeInformationScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Personal Information Screen ---
    GoRoute(
      path: routerPersonalInformationPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PersonalInformationScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    // --- Visa and Document Screen ---
    GoRoute(
      path: routerVisaAndDocumentPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const VisaAndDocument(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    // --- Vehicle Details Screen ---
    GoRoute(
      path: routerVehicleDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const VehicleDetailsScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerReportVehicleIssuePage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ReportVehicleIssuePage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerReportedVehicleDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ReportedVehicleDetailsPage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: routerFinesAndPenaltiesPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const FinesAndPenaltiesScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerFinesAndPenaltiesDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const FineDetailsScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Temporary Vehicle Usage ---
    GoRoute(
      path: routerTemporaryVehicleUsagePage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TemporaryVehicleUsage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Notes Screen ---
  ],
);

extension on Object? {
  operator [](String other) {}
}
