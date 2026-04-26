import 'package:flutter/material.dart';
import 'app_routes.dart';

import '../features/auth/screens/welcome_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';

// Main Screens
import '../features/home/screens/home_screen.dart';
import '../features/discover/screens/discover_screen.dart';
import '../features/report/screens/report_issue_screen.dart';
import '../features/heatmap/screens/heatmap_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return _fade(const WelcomeScreen());

      case AppRoutes.login:
        return _fade(const LoginScreen());

      case AppRoutes.signup:
        return _fade(const SignupScreen());

      case AppRoutes.onboarding:
        return _slide(const OnboardingScreen());

      // 🔥 Main Navigation
      case AppRoutes.home:
        return _slide(const HomeScreen());

      case AppRoutes.discover:
        return _slide(const DiscoverScreen());

      case AppRoutes.report:
  return _slide(const ReportIssueScreen());

      case AppRoutes.heatmap:
        return _slide(const HeatmapScreen());

      default:
        return _fade(const WelcomeScreen());
    }
  }

  // Fade Transition
  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      );

  // Slide Transition
  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      );
}