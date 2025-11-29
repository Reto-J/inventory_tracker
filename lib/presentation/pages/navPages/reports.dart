import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/pages/navPages/purchase.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/providers/themeprovider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/toastification/info.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/data/iconlist.dart';
import 'package:provider/provider.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  bool selected = false;
  Map<String, dynamic> selectedwithIndex = {};

  @override
  void initState() {
    loadavailItems();
    super.initState();
  }

  void loadavailItems() async {
    try {
      var transactionsProvider = Provider.of<ItemsProvider>(
        context,
        listen: false,
      );
      transactionsProvider.loadavailItems();
      setState(() {});
    } catch (e) {
      print(e);
      showErrorMessage(context, "Something went wrong");
    }
  }

  void purchaceItems() {
    var itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    itemsProvider.loadselectedItems();
    itemsProvider.loadselectedInven();
    if (selectedwithIndex.isEmpty) {
      showErrorMessage(context, "Please add items to be purchased");
    } else if (itemsProvider.NotAllAvailable()) {
      itemsProvider.clearSelectedItems();
      showInfoMessage(
        context,
        "The quantity of some products is more than availale",
      );
    } else {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => Purchasepage()));
      // selectedwithIndex = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Consumer<ItemsProvider>(
          builder: (context, ip, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Text(
                      "Make Sales",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(),
                        Text("Products available"),
                        SizedBox(
                          height: 30,
                          width: 83,
                          child: Custombutton(
                            text: "Clear",
                            onPressed: () {
                              setState(() {
                                selectedwithIndex = {};
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        itemCount: ip.data.length,
                        itemBuilder: (context, index) {
                          var dataz = ip.data[ip.data.length - (index + 1)];
                          bool isSelected =
                              selectedwithIndex[dataz["id"].toString()] !=
                                  null &&
                              selectedwithIndex[dataz["id"].toString()] > 0;
                          var inven = ip.inventory
                              .where((cat) => cat["productid"] == dataz["id"])
                              .firstOrNull?["quantity"]
                              .toString();
                          var iconz = iconList
                              .where((cat) => cat["name"] == dataz["icon"])
                              .toList()
                              .first;
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: Card(
                              shape: isSelected
                                  ? themeProvider.currentTheme.cardTheme.shape
                                  : null,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(4),
                                onTap: () {
                                  setState(() {
                                    selectedwithIndex.addAll({
                                      dataz["id"].toString(): isSelected
                                          ? 0
                                          : 1,
                                    });
                                    print(selectedwithIndex);
                                  });
                                },
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: ((iconz["color"]) as Color)
                                        .withAlpha(50),
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
                                trailing: isSelected
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      (selectedwithIndex[dataz["id"]
                                                          .toString()]++);
                                                    });
                                                  },
                                                  icon: Icon(Icons.add),
                                                ),
                                                Text(
                                                  (selectedwithIndex[dataz["id"]
                                                          .toString()])
                                                      .toString(),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedwithIndex[dataz["id"]
                                                          .toString()]--;
                                                    });
                                                  },
                                                  icon: Icon(Icons.remove),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Custombutton(
                    text: "Purchase",
                    onPressed: () {
                      selectedwithIndex.removeWhere((key, value) => value == 0);
                      ip.selectedwithIndex = selectedwithIndex;
                      purchaceItems();
                      setState(() {});
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
