import 'package:flutter/material.dart';
import 'package:light_level_sensing/pages/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:light_level_sensing/pages/home_page.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          'Theme Mode',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
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
      body: ListTile(
        title: Text('Light or Dark Mode',style: TextStyle(fontSize: 20),),
        trailing: Switch(
          value: Provider.of<ThemeProvider>(context).isDarkMode,
          onChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
      ),

    );
  }
}