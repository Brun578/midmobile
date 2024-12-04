import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/theme_provider.dart';
import 'package:light_level_sensing/light/automation_service.dart';
import 'package:light_level_sensing/Onboboarding/onboarding_view.dart';
import 'package:firebase_core/firebase_core.dart';// Adjust import path
import 'package:light_level_sensing/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AutomationService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: HomePage(), // Use FabTabs here
          );
        },
      ),
    );
  }
}