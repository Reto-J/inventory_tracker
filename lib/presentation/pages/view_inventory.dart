import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databaseHelper.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/toastification/sucess.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';
import 'package:provider/provider.dart';

class ViewInventoryPage extends StatefulWidget {
  final Map<String, dynamic> iconz;
  final Map<String, dynamic> dataz;
  const ViewInventoryPage({
    super.key,
    required this.iconz,
    required this.dataz,
  });

  @override
  State<ViewInventoryPage> createState() => _ViewInventoryPageState();
}

class _ViewInventoryPageState extends State<ViewInventoryPage> {
  List<Map<String, dynamic>> rest = [];
  @override
  void initState() {
    loadinven();
    super.initState();
  }

  void loadinven() async {
    rest = await DatabaseHelper().selectWhere("inventory", {
      "productid": widget.dataz["id"],
    });
  }

  TextEditingController quantityController = TextEditingController();

  void saveQuantity() async {
    if (quantityController.text == "") {
      showErrorMessage(context, "Please input a quantity");
    } else if (int.tryParse(quantityController.text) == null) {
      showErrorMessage(context, "Invalid quantity");
    } else {
      try {
        int newquan =
            rest.first["quantity"] + int.parse(quantityController.text);
        DatabaseHelper().update(
          "inventory",
          {"quantity": newquan},
          {"productid": widget.dataz["id"]},
        );

        showSuccessMessage(context, "Quantity saved 👍");
        var itemsprovider = Provider.of<ItemsProvider>(context, listen: false);
        itemsprovider.loadItems();
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        showErrorMessage(context, "Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ItemsProvider>(
        builder: (context, ip, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "View Inventory",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      CircleAvatar(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.cancel),
                        ),
                      ),
                    ],
                  ),
                  invenInfo("Product Name", widget.dataz["name"]),
                  invenInfo(
                    "Unit cost of product",
                    "₦${widget.dataz["unitcost"].toString()}",
                  ),
                  invenInfo("Suplier details", widget.dataz["suplierdetails"]),
                  invenInfo("Description", widget.dataz["description"]),
                  invenInfo(
                    "Quantity",
                    ip.inventory
                            .where(
                              (cat) => cat["productid"] == widget.dataz["id"],
                            )
                            .firstOrNull?["quantity"]
                            .toString() ??
                        "",
                  ),
                  Spacer(),
                  Custombutton(
                    text: "Add Quantity",
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                              width: 250,
                              height: 250,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Text("Add Quantity"),
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Customtextfield(
                                      text: "Quantity",
                                      controller: quantityController,
                                    ),
                                    SizedBox(height: 20),
                                    Custombutton(
                                      text: "Save",
                                      onPressed: () {
                                        saveQuantity();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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

Widget invenInfo(String title, String Info) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(Info),
            ],
          ),
        ),
      ),
    ),
  );
}
