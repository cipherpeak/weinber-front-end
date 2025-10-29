import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/features/AttendancePage/Presentation/Screens/AttendancePage.dart';
import 'package:weinber/features/ReportPage/Presentation/Screens/ReportPage.dart';
import '../../features/Authentication/Login/Presentation/Screens/LoginPage.dart';
import '../../features/BottomNavPage/Presentation/Screens/bottom_nav_screen.dart';
import '../../features/Homepage/Presentation/Screens/Homepage.dart';
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
const String routerStartTaskDetailsPage = '/app/task/start';

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
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    // --- Login ---
    GoRoute(
      path: routerLoginPage,
      pageBuilder: (context, state) => CustomTransitionPage(
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
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomepageScreen(),
          ),
        ),
        GoRoute(
          path: routerTaskPage,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TaskScreen(),
          ),
        ),
        GoRoute(
          path: routerAttendancePage,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AttendanceScreen(),
          ),
        ),
        GoRoute(
          path: routerReportPage,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReportScreen(),
          ),
        ),
      ],
    ),

    // --- Task details (outside shell) ---
    GoRoute(
      path: routerTaskDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TaskDetailsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),

    GoRoute(
      path: routerStartTaskDetailsPage,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const StartTaskDetailsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
  ],
);

