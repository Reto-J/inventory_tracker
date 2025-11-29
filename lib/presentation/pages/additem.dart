import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databaseHelper.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/toastification/sucess.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/customRowContent.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';
import 'package:inventory_tracker/presentation/widgets/data/iconlist.dart';
import 'package:provider/provider.dart';

class AdditemPage extends StatefulWidget {
  const AdditemPage({super.key});

  @override
  State<AdditemPage> createState() => _AdditemPageState();
}

class _AdditemPageState extends State<AdditemPage> {
  void saveItem()async{
    if (_selectedIcon == null) {
      showErrorMessage(context, "Please chose an Icon");
    } else if (itemnameController.text.isEmpty) {
      showErrorMessage(context, "Please add the item's name");
    } else if (double.tryParse(unitcostController.text) == null) {
      showErrorMessage(context, "Please add a valid unit cost");
    } else if (categoryController.text.isEmpty) {
      showErrorMessage(context, "Please add the items category");
    } else if (suplierController.text.isEmpty) {
      showErrorMessage(context, "Please add the item's Suplier Details");
    } else if (descriptionController.text.isEmpty) {
      showErrorMessage(context, "Please the item's description");
    } else {
      try {
        DatabaseHelper().insert("items", {
          "icon": iconName,
          "name": itemnameController.text,
          "unitcost": double.tryParse(unitcostController.text),
          "category": categoryController.text,
          "suplierdetails": suplierController.text,
          "description": descriptionController.text,
        });
        var num = await DatabaseHelper().getlastindex();
        DatabaseHelper().insert("inventory", {
          "productid" : int.parse(num),
          "quantity" : 0
        });
        showSuccessMessage(context, "Item saved successfuly");
        var itemsprovider = Provider.of<ItemsProvider>(context, listen: false);
        itemsprovider.loadItems();
        itemsprovider.loadData();
        itemsprovider.loadselectedItems();
        itemsprovider.loadavailItems();
        itemsprovider.loadUsers();
      } catch (e) {
        print(e);
        showErrorMessage(context, "Something went wrong");
      }
    }
  }

  IconData? _selectedIcon;
  String? iconName;
  Color? iconColor;

  TextEditingController itemnameController = TextEditingController();
  TextEditingController unitcostController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController suplierController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  Text("Add Item"),
                  CircleAvatar(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final Map<String, dynamic>?
                  pickedIcon = (await showDialog<Map<String, dynamic>?>(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: SizedBox(
                          height: 250,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 30),
                                  Text("Pick an Icon"),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.cancel),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: GridView.builder(
                                  itemCount: iconList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                  itemBuilder: (context, index) {
                                    final icon = iconList[index];
                                    return GridTile(
                                      child: Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(icon);
                                            },
                                            icon: Icon(
                                              iconList[index]["icon"],
                                              color: iconList[index]["color"],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(iconList[index]["name"]),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ))!;
                  if (pickedIcon != null) {
                    setState(() {
                      _selectedIcon = pickedIcon["icon"];
                      iconName = pickedIcon["name"];
                      iconColor = pickedIcon["color"];
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 90,
                  width: double.infinity,
                  child: Center(
                    child: _selectedIcon == null
                        ? Text("Chose Icon")
                        : Icon(_selectedIcon, size: 50, color: iconColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomRowContent(
                fristName: "Item Name",
                secondName: "Unit Cost",
                firstController: itemnameController,
                secondController: unitcostController,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Category", style: TextStyle(fontWeight: FontWeight.bold),),
                          Customtextfield(
                            controller: categoryController,
                            removeBorder: true,
                            hintText: categoryController.text == ""
                                ? "Category"
                                : categoryController.text,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Suplier Details",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Customtextfield(
                    removeBorder: true,
                    hintText: suplierController.text == ""
                        ? "Suplier Details"
                        : suplierController.text,
                    controller: suplierController,
                  ),
                ],
              ),
              SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Customtextfield(
                    removeBorder: true,
                    maxLine: 2,
                    hintText: descriptionController.text,
                    controller: descriptionController,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Custombutton(
                      text: "Cancle",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      fgColor: Colors.blue,
                      brColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Custombutton(
                      text: "Save",
                      onPressed: () {
                        saveItem();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
