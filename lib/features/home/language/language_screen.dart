import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool _isEnglish = true;

  @override
  void initState() {
    super.initState();
    var locale = Get.deviceLocale;
    print(locale);
    _isEnglish = locale?.languageCode == "en_US";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("language".tr),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text("khmerLanguage".tr),
            trailing: Checkbox(
              value: !_isEnglish,
              onChanged: (v) {
                Get.updateLocale(Locale('km', 'KH'));
                setState(() {
                  _isEnglish = false;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("englishLanguage".tr),
            trailing: Checkbox(
              value: _isEnglish,
              onChanged: (v) {
                Get.updateLocale(Locale('en', 'US'));
                setState(() {
                  _isEnglish = true;
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
