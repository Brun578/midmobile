import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'motion_graph.dart'; // Import the new file
import 'package:light_level_sensing/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Detection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MotionDetectionPage(),
    );
  }
}

class MotionDetectionPage extends StatefulWidget {
  @override
  _MotionDetectionPageState createState() => _MotionDetectionPageState();
}

class _MotionDetectionPageState extends State<MotionDetectionPage> {
  AccelerometerEvent _accelerometerEvent = AccelerometerEvent(0, 0, 0);
  List<FlSpot> _spots = [];
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late FirebaseMessaging _firebaseMessaging;
  bool _notificationSent = false;


  @override
  void initState() {
    super.initState();
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _firebaseMessaging = FirebaseMessaging.instance;
    _initializeNotifications();

    Sensors().accelerometerEvents.listen((event) {
      setState(() {
        _accelerometerEvent = event;
        _spots.add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), event.x.toDouble()));
        if (_spots.length > 100) {
          _spots.removeAt(0);
        }

        // Increment step count and send notification if motion detected
        if (event.x.abs() > 1.0 && !_notificationSent) {

          _sendNotification();
          _notificationSent = true; // Prevent multiple notifications
        } else if (event.x.abs() <= 1.0) {
          _notificationSent = false; // Reset when no motion is detected
        }
      });
    });

    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _showNotification(notification.title, notification.body);
      }
    });
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _sendNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'motion_detection_channel', // channelId
        'Motion Detection Alerts', // channelName
        channelDescription: 'Channel for motion detection alerts', // Description
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Flutter Message',
      'Motion has been detected by the sensor',
      platformChannelSpecifics,
      payload: 'item x',
    );
    print('Notification sent'); // Debug log
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'motion_detection_channel', // channelId
        'Motion Detection Alerts', // channelName
        channelDescription: 'Channel for motion detection alerts', // Description
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMotionDetected = _accelerometerEvent.x.abs() > 1.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Motion Detection and Security'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 16), // Spacing between step count and motion detection status
                  isMotionDetected
                      ? Image.asset(
                    'assets/icons/oo.png',
                    height: 150,
                    width: 150,
                  )
                      : Image.asset(
                    'assets/icons/nomot.png',
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: 8), // Adjusted spacing
                  Text(
                    isMotionDetected ? ' Motion has been Detected' : 'No Motion detected',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isMotionDetected ? Colors.orange : Colors.orange,
                    ),
                  ),
                  SizedBox(height: 40), // Spacing between text and graph

                ],
              ),
            ),
            Container(
              height: 250, // Height adjusted for the graph
              padding: EdgeInsets.all(8),
              child: MotionGraph(spots: _spots), // Use the new MotionGraph widget
            ),
          ],
        ),
      ),
    );
  }
}
