import 'package:flutter/material.dart';

class AutomationService with ChangeNotifier {
  String _lightStatus = "Normal";

  String get lightStatus => _lightStatus;

  void adjustSmartLights(BuildContext context, int luxValue) {
    String newStatus;
    if (luxValue < 10) {
      newStatus = "Low light level";
    } else if (luxValue >= 10 && luxValue < 50) {
      newStatus = "Medium light level";
    } else if (luxValue >= 50 && luxValue < 500) {
      newStatus = "Normal light level";
    } else {
      newStatus = "High light level";
    }

    if (newStatus != _lightStatus) {
      _lightStatus = newStatus;
      notifyListeners();
      showCustomToast(context, " $_lightStatus");
    }
  }

  void showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 290.0, // Adjust this value to position the toast
        left: 30,
        right: 30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
