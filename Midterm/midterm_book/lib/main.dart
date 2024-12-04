// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/book_provider.dart';
import './providers/theme_provider.dart';
import './widgets/bottom_nav_screen.dart';
import 'data_access_layer/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database; // Ensure database is initialized

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: BottomNavScreen(),
          );
        },
      ),
    );
  }
}
