import 'package:flutter/material.dart';
import 'package:procdev/data/file_storage_data.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullName;
  int _cartTotal = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartOrder();
  }

  Future<void> _loadCartOrder() async {
    // Option 1
    //List<String> data = await FileStorageData.readDataFromFile();

    // Option 2
    await FileStorageData.readDataFromFile().then((List<String> data) {
      setState(() {
        _cartTotal = data.length;
      });
    }).then((error) {
      print("Error loading data");
    });
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
        title: Text('Hi, $fullName'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            showBadge: true,
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
            badgeContent: Text(
              "$_cartTotal",
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView(
        children: [_searchWidget, _bookTitle, _bookListWidget],
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

  Widget get _bookListWidget {
    List<Widget> _bookItems = List.generate(
      10,
      (index) => _bookCartItem(index),
    ).toList();

    // Option 1  : Using ListView

    // return SizedBox(
    //     height: 220,
    //     child: ListView(
    //       scrollDirection: Axis.horizontal,
    //       children: _bookItems,
    //     ));

    // Option 2 : Using Row
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: _bookItems),
    );
  }

  Widget get _bookTitle {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Top Book"), Icon(Icons.navigate_next)],
        ));
  }

  Widget _bookCartItem(int bookId) {
    return Card(
      child: Column(
        children: [
          Image.asset("assets/images/book.png", height: 180),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    if (fullName == "Guest") {
                      AppRoute.key.currentState?.pushNamed(AppRoute.login);
                    } else {
                      final alert = AlertDialog(
                        title: Icon(Icons.check_circle,
                            color: Colors.green, size: 40),
                        content: Text(
                            "You have added this book to the cart successfully!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                      _orderBook(
                          bookId: bookId,
                          price: 2000.0,
                          qty: 1,
                          discount: 200.0);

                      showDialog(context: context, builder: (context) => alert);
                    }
                  },
                  child: Icon(Icons.add)),
              Text("1"),
              TextButton(onPressed: () {}, child: Icon(Icons.remove)),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _orderBook(
      {int? bookId, double? price, int? qty, double? discount}) async {
    String data = "bookId=$bookId,price=$price,qty=$qty,discount=$discount";
    await FileStorageData.writeDataToFile(data);
  }
}
