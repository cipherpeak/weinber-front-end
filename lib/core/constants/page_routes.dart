import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/features/AttendancePage/Presentation/Screens/AttendancePage.dart';
import 'package:weinber/features/Homepage/Presentation/Screens/TakeABreakPages/take_a_break_first_page.dart';
import 'package:weinber/features/ReportPage/Presentation/Screens/ReportPage.dart';
import '../../features/Authentication/Login/Presentation/Screens/LoginPage.dart';
import '../../features/BottomNavPage/Presentation/Screens/bottom_nav_screen.dart';
import '../../features/Homepage/Presentation/Screens/CheckInPages/check_in_first_page.dart';
import '../../features/Homepage/Presentation/Screens/CheckOutPages/check_out_first_page.dart';
import '../../features/Homepage/Presentation/Screens/Homepage.dart';
import '../../features/ProfilePage/Presentation/Screens/profile_page.dart';
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
const String routerStartTaskDetailsPage = '/app/task/start';
const String routerCheckInFirstPage = '/app/attendance/check_in_first';
const String routerCheckOutFirstPage = '/app/attendance/check_out_first';
const String routerTakeBreakPage = '/app/attendance/take_a_break_first';

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
  ],
);
