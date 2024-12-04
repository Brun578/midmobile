import 'package:flutter/material.dart';

class SmartDeviceBox extends StatelessWidget {
  final String smartDeviceName;
  final String iconPath;
  final VoidCallback? onTap;  // Added onTap callback

  const SmartDeviceBox({
    required this.smartDeviceName,
    required this.iconPath,
    this.onTap,  // Added onTap parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple[500]!,
            Colors.purple[500]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Text vertically aligned on the left
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  smartDeviceName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onTap,  // Set onTap for the button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Start',
                        style: TextStyle(fontSize: 17,color: Colors.indigo),
                      ),
                      SizedBox(width: 11), // Space between text and icon

                    ],
                  ),
                ),
              ],
            ),
          ),
          // Icon on the top right
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              iconPath,
              width: 80,
              height: 75,
            ),
          ),
        ],
      ),
    );
  }
}
