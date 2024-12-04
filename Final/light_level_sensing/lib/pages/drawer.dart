import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:light_level_sensing/pages/home_page.dart';
import 'package:light_level_sensing/light/light_home_page.dart';
import 'package:light_level_sensing/motion/motion_detector.dart';
import 'package:light_level_sensing/geofencing.dart';
import 'package:light_level_sensing/pages/settings_screen.dart';

class Sidemenu extends StatefulWidget {
  const Sidemenu({Key? key}) : super(key: key);

  @override
  State<Sidemenu> createState() => _SidemenuState();
}

class _SidemenuState extends State<Sidemenu> {
  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode using GetX
    bool isDarkMode = Get.isDarkMode;

    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.purple,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Joan Niragire'),
            accountEmail: const Text('joan@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/icons/prof.jpg')),
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.red,

            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Home", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Light Level Sensing and Automation", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LightHomePage()),
                    (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_run, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Motion Detection and Security", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MotionDetectionPage()),
                    (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on_sharp, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Location Tracking and Geofencing", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LocationPosition()),
                    (route) => false,
              );
            },
          ),       ListTile(
            leading: Icon(Icons.color_lens, color: isDarkMode ? Colors.white : Colors.black),
            title: Text("Switch Theme", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
                    (route) => false,
              );
            },
          ),

        ],
      ),
    );
  }
}
