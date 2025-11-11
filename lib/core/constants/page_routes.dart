import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/features/AttendancePage/Presentation/Screens/AttendancePage.dart';
import 'package:weinber/features/Authentication/Forgot%20Password/Presentation/Screens/otp_verification_page.dart';
import 'package:weinber/features/Authentication/Forgot%20Password/Presentation/Screens/password_reset_success_page.dart';
import 'package:weinber/features/Authentication/Forgot%20Password/Presentation/Screens/reset_password_page.dart';
import 'package:weinber/features/Homepage/Presentation/Screens/TakeABreakPages/take_a_break_first_page.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/temporary_vehicle_usage.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/vehicle_details_screen.dart';
import 'package:weinber/features/ProfilePage/Presentation/Screens/visa_and_document.dart';
import 'package:weinber/features/ReportPage/Presentation/Screens/ReportPage.dart';
import '../../features/Authentication/Forgot Password/Presentation/Screens/forgot password page.dart';
import '../../features/Authentication/Login/Presentation/Screens/LoginPage.dart';
import '../../features/BottomNavPage/Presentation/Screens/bottom_nav_screen.dart';
import '../../features/BottomNavPage/Presentation/Screens/notification_page.dart';
import '../../features/ProfilePage/Presentation/Screens/employee_information_page.dart';
import '../../features/Homepage/Presentation/Screens/CheckInPages/check_in_first_page.dart';
import '../../features/Homepage/Presentation/Screens/CheckOutPages/check_out_first_page.dart';
import '../../features/Homepage/Presentation/Screens/Homepage.dart';
import '../../features/ProfilePage/Presentation/Screens/personal_information_screen.dart';
import '../../features/ProfilePage/Presentation/Screens/profile_page.dart';
import '../../features/Settings Page/Presentation/Screens/settings_screen.dart';
import '../../features/TaskPage/Presentation/Screens/StartTaskScreen.dart';
import '../../features/TaskPage/Presentation/Screens/TaskScreen.dart';
import '../../features/TaskPage/Presentation/Screens/TaskDetailsScreen.dart';
import '../../features/splash/presentation/Screens/splash_screen.dart';

// 🧭 Route constants

const String routerSplash = '/';
const String routerLoginPage = '/login';
// Shell route

const String routerHomePage = '/app/home';
const String routerTaskPage = '/app/task';
const String routerAttendancePage = '/app/attendance';
const String routerReportPage = '/app/report';
const String routerTaskDetailsPage = '/app/task/details';
const String routerProfilePage = '/app/home/profile';
const String routerNotificationPage = '/app/home/notification';
const String routerStartTaskDetailsPage = '/app/task/start';
const String routerCheckInFirstPage = '/app/attendance/check_in_first';
const String routerCheckOutFirstPage = '/app/attendance/check_out_first';
const String routerSettingsPage = '/app/home/profile/setting';
const String routerTakeBreakPage = '/app/attendance/take_a_break_first';
const String routerEmployeeInformationPage = '/app/home/profile/employee-information';
const String routerPersonalInformationPage =
    '/app/home/profile/personal-information';
const String routerVisaAndDocumentPage =
    '/app/home/profile/visa-and-document';
const String routerVehicleDetailsPage =
    '/app/home/profile/vehicle-details';
const String routerTemporaryVehicleUsagePage = '/app/home/profile/temporary-vehicle-usage';

const routerForgotPassword = '/forgot-password';
const routerOtpVerificationPage = '/otp-verification';
const routerResetPasswordPage = '/reset-password';
const routerPasswordResetSuccessPage = '/password-reset-success';

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
        child: const LoginPage(),
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
          path: routerTaskPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TaskScreen(),
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
                      FadeTransition(opacity: animation, child: child)),
        ),
      ],
    ),

    // --- Task details (outside shell) ---
    GoRoute(
      path: routerTaskDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TaskDetailsPage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerStartTaskDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const StartTaskDetailsScreen(),
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

    // --- Forgot Password Flow ---
    GoRoute(
      path: routerForgotPassword,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: routerOtpVerificationPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OtpVerificationScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: routerResetPasswordPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ResetPasswordScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: routerPasswordResetSuccessPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PasswordResetSuccessScreen(),
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

    // --- Employee Information Screen ---
    GoRoute(
      path: routerEmployeeInformationPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child:  EmployeeInformationScreen(),
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


  ],
);

