import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/Authentication/Login/Presentation/Screens/LoginPage.dart';
import '../../features/Homepage/Presentation/Screens/bottom_nav_screen.dart';
import '../../features/splash/presentation/Screens/splash_screen.dart';

const String routerSplash = '/';
const String routerLoginPage = '/login';
const String routerHomePage = '/home';
const String routerBottomNav = '/bottomNavScreen';


final GoRouter router = GoRouter(
  initialLocation: routerSplash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: routerSplash,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    GoRoute(
      path: routerLoginPage,
      pageBuilder:
          (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 1400),
        key: state.pageKey,
        child: const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    GoRoute(
      path: routerBottomNav,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const BottomNavScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);
