import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:setu_ngo/core/theme/app_theme.dart';
import 'package:setu_ngo/features/auth/screens/welcome_screen.dart';
import '../../../features/dashboard/screens/dashboard_screen.dart';
import '../../../features/navigation/screens/main_navigation_screen.dart';

// import your providers
import 'package:setu_ngo/features/dashboard/core/providers/dashboard_provider.dart';
import 'package:setu_ngo/features/auth/providers/registration_provider.dart';
import 'package:setu_ngo/features/forms/form_controller.dart';
import 'package:setu_ngo/features/campaigns/campaign_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => FormController()..seedDemoData()),
        ChangeNotifierProvider(create: (_) => CampaignController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}