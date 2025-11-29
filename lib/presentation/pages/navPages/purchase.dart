import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/toastification/sucess.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/data/iconlist.dart';
import 'package:provider/provider.dart';

class Purchasepage extends StatefulWidget {
  const Purchasepage({super.key});

  @override
  State<Purchasepage> createState() => _PurchasepageState();
}

class _PurchasepageState extends State<Purchasepage> {
  void initState() {
    loadselectedItems();
    super.initState();
  }

  void confPurchase() {
    try {
      var itemsprovider = Provider.of<ItemsProvider>(context, listen: false);
      itemsprovider.saveSales();
      showSuccessMessage(context, "Sale saved sucessfuly👍");
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      showErrorMessage(context, "Something went wrong");
    }
  }

  void loadselectedItems() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    } catch (e) {
      print(e);
    }
  }

  void saveSales() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ItemsProvider>(
        builder: (context, ip, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ip.eachItemTotal = [];
                      ip.selectedItems = [];
                      ip.totalofselected = 0;
                    },
                    icon: Icon(Icons.cancel),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: ip.selectedItems.length,
                      itemBuilder: (context, index) {
                        var dataz = ip.data
                            .where(
                              (d) =>
                                  d["name"] ==
                                  ip.selectedItems[ip.selectedItems.length -
                                      (index + 1)]["name"],
                            )
                            .toList()
                            .first;
                        var iconz = iconList
                            .where(
                              (cat) =>
                                  cat["name"] ==
                                  ip.selectedItems[ip.selectedItems.length -
                                      (index + 1)]["icon"],
                            )
                            .toList()[0];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(6),
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: ((iconz["color"]) as Color).withAlpha(
                                    50,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  iconz["icon"],
                                  size: 40,
                                  color: iconz["color"],
                                ),
                              ),
                              title: Text(
                                dataz["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ip.selectedwithIndex.values
                                        .toList()[ip.selectedItems.length -
                                            (index + 1)]
                                        .toString(),
                                  ),
                                  Text("₦${dataz["unitcost"]}"),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    "Item total : ₦${dataz["unitcost"] * ip.selectedwithIndex.values.toList()[ip.selectedItems.length - (index + 1)]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      print("yes");
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total :",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₦${ip.totalofselected}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Custombutton(
                                  text: "Confirm purchase",
                                  onPressed: () {
                                    confPurchase();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
