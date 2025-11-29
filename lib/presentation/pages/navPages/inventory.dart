import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databaseHelper.dart';
import 'package:inventory_tracker/presentation/pages/additem.dart';
import 'package:inventory_tracker/presentation/pages/view_inventory.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/providers/themeprovider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/widgets/data/iconlist.dart';
import 'package:inventory_tracker/theme/apptheme.dart';
import 'package:provider/provider.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  void initState() {
    loadItems();
    super.initState();
  }

  void loadItems() async {
    try {
      var transactionsProvider = Provider.of<ItemsProvider>(
        context,
        listen: false,
      );
      transactionsProvider.loadItems();
      setState(() {});
    } catch (e) {
      print(e);
      showErrorMessage(context, "Something went wrong");
    }
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(
        context,
        listen: false,
      );
    return Consumer<ItemsProvider>(
      builder: (context, ip, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Inventory",
                    style: themeProvider.currentTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              prefix: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Search",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.tune_outlined),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Items"), Text("View all")],
                  ),
                  SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: ip.data.length,
                      itemBuilder: (context, index) {
                        var dataz = ip.data[ip.data.length - (index + 1)];
                        var inven = ip.inventory
                            .where((cat) => cat["productid"] == dataz["id"])
                            .firstOrNull?["quantity"]
                            .toString();
                        var iconz = iconList.where((cat) => cat["name"] == dataz["icon"]).toList()[0];
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewInventoryPage(
                                      iconz: iconz,
                                      dataz: dataz,
                                    ),
                                  ),
                                );
                              },
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: ((iconz["color"]) as Color).withAlpha(
                                    50,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  iconz["icon"],
                                  size: 40,
                                  color: iconz["color"],
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    dataz["name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "(${dataz["category"]})",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    inven ?? "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "in stock",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AdditemPage()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
