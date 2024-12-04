import 'package:flutter/material.dart';
import 'package:light_level_sensing/pages/smart_device_box.dart';
import 'package:light_level_sensing/pages/home_page.dart';
import 'package:light_level_sensing/light/light_home_page.dart';
import 'package:light_level_sensing/motion/motion_detector.dart';
import 'package:light_level_sensing/geofencing.dart';
import 'package:light_level_sensing/pages/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 20;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    ["Light Level Sensing and Automation", "assets/icons/n.png"],
    ["Motion Detection and Security", "assets/icons/kkk.png"],
    ["Location Tracking and Geofencing", "assets/icons/j.png"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Smart Home Monitoring System',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // My Services text with icon
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

              ),
            ),

            const SizedBox(height: 26),

            // grid
            Expanded(
              child: GridView.builder(
                itemCount: mySmartDevices.length,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1 / 0.5, // Adjusted to fit the layout
                  mainAxisSpacing: 30, // Space between rows
                  crossAxisSpacing: 20, // Space between columns
                ),
                itemBuilder: (context, index) {
                  return SmartDeviceBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    onTap: () {
                      if (mySmartDevices[index][0] ==
                          "Light Level Sensing and Automation") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LightHomePage()),
                              (route) => false,
                        );
                      } else if (mySmartDevices[index][0] ==
                          "Motion Detection and Security") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MotionDetectionPage()),
                              (route) => false,
                        );
                      } else if (mySmartDevices[index][0] ==
                          "Location Tracking and Geofencing") {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationPosition()),
                              (route) => false,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
