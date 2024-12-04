import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:light_level_sensing/pages/home_page.dart';

class LocationPosition extends StatefulWidget {
  @override
  _LocationPositionState createState() => _LocationPositionState();
}

class _LocationPositionState extends State<LocationPosition> {
  late GoogleMapController mapController;
  late LatLng currentLocation = LatLng(0.0, 0.0);
  final LatLng targetLocation = LatLng(-1.955454, 30.104421); // Your home location
  final double radius = 100.0; // Radius in meters
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isInTargetArea = false;
  MapType _currentMapType = MapType.satellite; // Default to satellite mode

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _initNotifications();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required to use this app')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Check proximity upon startup
    _checkProximity(currentLocation);

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLocation = newLocation;
      });
      _checkProximity(newLocation);
    });
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Ensure 'app_icon' exists in drawable
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _checkProximity(LatLng location) {
    double distance = Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      targetLocation.latitude,
      targetLocation.longitude,
    );

    if (distance <= radius && !isInTargetArea) {
      isInTargetArea = true;
      _showPopupMessage('You are at Auca');
    } else if (distance > radius && isInTargetArea) {
      isInTargetArea = false;
      _showPopupMessage('You are not at Auca!');
    }
  }



  void _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Tracker', style: TextStyle(color: Colors.purple)),
          content: Text(message, style: TextStyle(fontSize: 23)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.orange)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onMapTypeButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Map Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Default'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.normal;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.satellite),
                title: Text('Satellite'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.satellite;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.terrain),
                title: Text('Terrain'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.terrain;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCoordinates(LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(' Your Current Coordinates',style:TextStyle(color: Colors.purple,fontSize: 20) ,),
          content: Text('Latitude: ${position.latitude}\nLongitude: ${position.longitude}', style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  void _centerMapOnCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
  }

  void _centerMapOnTargetLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(targetLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(
          'Location Tracking and Geofencing',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          currentLocation.latitude == 0.0 && currentLocation.longitude == 0.0
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            mapType: _currentMapType,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(
              <Marker>[
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: currentLocation,
                  onTap: () => _showCoordinates(currentLocation),
                ),

              ],
            ),
            circles: Set<Circle>.of(
              <Circle>[
                Circle(
                  circleId: CircleId('targetLocationCircle'),
                  center: targetLocation,
                  radius: radius,
                  fillColor: Colors.purple.withOpacity(0.2),
                  strokeColor: Colors.purple,
                  strokeWidth: 1,
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 100,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.layers, color: Colors.white),
                  tooltip: 'Change Map Type',
                ),
                SizedBox(height: 20),


                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: _centerMapOnCurrentLocation,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.my_location, color: Colors.white),
                  tooltip: 'Center on Current Location',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
