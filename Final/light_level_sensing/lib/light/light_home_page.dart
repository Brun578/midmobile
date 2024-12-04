import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:light/light.dart';
import 'dart:async';

import 'dart:math';


import 'package:light_level_sensing/light/automation_service.dart';
import 'package:light_level_sensing/pages/home_page.dart';

class LightHomePage extends StatefulWidget {
  @override
  _LightHomePageState createState() => _LightHomePageState();
}

class _LightHomePageState extends State<LightHomePage> {
  late Light _light;
  String _luxString = 'unknown';
  late StreamSubscription _subscription;

  void onData(int luxValue) async {
    setState(() {
      _luxString = "$luxValue";
    });

    final automationService = Provider.of<AutomationService>(context, listen: false);
    automationService.adjustSmartLights(context, luxValue);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    double nivel = double.tryParse(_luxString) ?? 0.0;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Light Sensing and Automation'),
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 1.0), // Spacing between title and indicator
            Consumer<AutomationService>(
              builder: (context, automationService, child) {
                return CustomPaint(
                  size: Size(screenWidth * 0.3, screenWidth * 0.45), // Adjusted height
                  painter: HalfCirclePainter(
                    percentage: (nivel <= 10000) ? nivel / 10000 : 0.0,
                    theme: theme,
                    luxString: _luxString,
                    lightStatus: automationService.lightStatus,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/light-bulb.png', // Replace with your asset path
                      height: 150, // Adjusted height
                      width: 80, // Adjusted width
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final double percentage;
  final ThemeData theme;
  final String luxString;
  final String lightStatus;

  HalfCirclePainter({
    required this.percentage,
    required this.theme,
    required this.luxString,
    required this.lightStatus,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    final Paint progressPaint = Paint()
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height * 2); // Adjusted position

    // Draw the background half circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,
      3.14,
      false,
      paint,
    );

    // Draw the progress half circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,
      3.14 * percentage,
      false,
      progressPaint,
    );

    // Draw the lux level text in the middle of the half circle
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$luxString lux',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 60.0,
          color: Colors.purple,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - radius -160), // Adjusted position
    );

    // Draw the light status text below the lux level text
    final TextPainter statusPainter = TextPainter(
      text: TextSpan(

        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    statusPainter.layout();
    statusPainter.paint(
      canvas,
      Offset(center.dx - statusPainter.width / 2, center.dy - radius - 10), // Adjusted position
    );

// Draw the needle
  final Paint needlePaint = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  final double needleAngle = pi * (1 + percentage);
  final double needleLength = radius * 0.8;

  final Offset needleEnd = Offset(
    center.dx + needleLength * cos(needleAngle),
    center.dy + needleLength * sin(needleAngle),
  );

  canvas.drawLine(center, needleEnd, needlePaint);
}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
