import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _isDark = Get.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Theme"),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.tab),
            title: Text("Theme Light"),
            trailing: Checkbox(
              value: !_isDark,
              onChanged: (v) {
                Get.changeTheme(ThemeData.light());
                setState(() {
                  _isDark = false;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.tab),
            title: Text("Theme Dark"),
            trailing: Checkbox(
              value: _isDark,
              onChanged: (v) {
                Get.changeTheme(ThemeData.dark());
                setState(() {
                  _isDark = true;
                });
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
