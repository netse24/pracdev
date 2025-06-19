import 'package:flutter/material.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sharedPref = await SharedPreferences.getInstance();
    String? username = await sharedPref.getString(SharedPrefData.fullNameKey);
    String? email = await sharedPref.getString(SharedPrefData.emailKey);

    setState(() {
      fullName = username ?? email ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Hi, $fullName'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          _searchWidget,
        ],
      ),
    );
  }

  Widget get _searchWidget {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.tune)),
        onChanged: (value) {
          // Handle search logic here
        },
      ),
    );
  }
}
