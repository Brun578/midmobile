// lib/widgets/sidemenu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/bottom_nav_screen.dart';

class Sidemenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.orange,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Bruno Ray'),
            accountEmail: const Text('brunoray@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/ic.png',)),
            backgroundColor: Colors.white,),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.blueAccent,
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Home", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavScreen(initialIndex: 0),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Add/Edit Book", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavScreen(initialIndex: 1),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Settings", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavScreen(initialIndex: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
