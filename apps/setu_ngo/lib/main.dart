import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:setu_ngo/core/theme/app_theme.dart';
import 'package:setu_ngo/features/auth/screens/welcome_screen.dart';

// import your providers
import 'package:setu_ngo/features/dashboard/providers/dashboard_provider.dart';
import 'package:setu_ngo/features/auth/providers/registration_provider.dart';

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
      ],
      child: const MyApp(),
    ),
  );
=======
import 'package:provider/provider.dart';
import 'package:setu_ngo/features/forms/form_controller.dart';
import 'package:setu_ngo/features/dashboard/screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FormController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
>>>>>>> 1950b9be625186982b3281cf2dd1322f4348e535
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}