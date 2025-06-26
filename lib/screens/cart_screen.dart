import 'package:flutter/material.dart';
import 'package:procdev/data/file_storage_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        elevation: 0.5,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
          future: FileStorageData.readDataFromFile(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<String>> asyncSnapshot,
          ) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text("Error: ${asyncSnapshot.error}"));
            }
            if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
              return const Center(child: Text("No items in the cart"));
            }
            List<String> cartItems = asyncSnapshot.data as List<String>;
            return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  String data = cartItems[index];
                  List<String> dataOrder = data.split(",");
                  String bookId = dataOrder[0].split("=")[1];
                  double price = double.parse(dataOrder[1].split("=")[1]);

                  return Card(
                      elevation: 0.5,
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text("BookId : $bookId"),
                        trailing: Text("$price USD"),
                        subtitle: Text("25-06-2025"),
                        onTap: () {
                          // Handle item tap and add functionality to remove the item from the cart
                        },
                      ));
                });
          }),
    );
  }
}
