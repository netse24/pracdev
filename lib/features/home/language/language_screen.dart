import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = Get.locale;
    print("Current local code: ${_currentLocale?.languageCode}");
  }

  void _changeLocale(Locale newLocale) {
    // Tell GetX to update the app's language
    Get.updateLocale(newLocale);
    // Update the state of this screen to change the checkboxes
    setState(() {
      _currentLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnglish =
        _currentLocale?.languageCode.startsWith('en') ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text("language".tr),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text("khmerLanguage".tr),
            trailing: Checkbox(
              value: !isEnglish,
              onChanged: (value) {
                if (value == true) {
                  _changeLocale(const Locale('km', 'KH'));
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("englishLanguage".tr),
            trailing: Checkbox(
              value: isEnglish,
              onChanged: (value) {
                if (value == true) {
                  _changeLocale(const Locale('en', 'US'));
                }
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
