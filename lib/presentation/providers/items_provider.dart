import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databaseHelper.dart';
import 'package:inventory_tracker/presentation/data/week.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> salesitems = [];
  List<Map<String, dynamic>> sales = [];
  List<double> eachItemTotal = [];
  double totalofselected = 0;
  List<Map<String, dynamic>> selectedInven = [];
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> selectedItems = [];
  List<Map<String, dynamic>> inventory = [];
  Map<String, dynamic> selectedwithIndex = {};
  int outOfstock = 0;
  int instock = 0;
  int total = 0;
  SharedPreferences? prefs;

  Map<String, dynamic> get getSalesPerDay {
    // Map<String, dynamic> salesPerDay = {};
    Map<String, dynamic> qtyPerDay = {};
    for (var day in daysOfWeek) {
      // salesPerDay[day] = sales
      //     .where(
      //       (s) =>
      //           DateTime.parse(s['date']).weekday ==
      //           daysOfWeek.indexOf(day) + 1,
      //     )
      //     .fold<double>(0, (p, e) => p + (e['complete_total'] as double));

      var salesPerDay = sales.where(
        (s) => DateTime.parse(s['date']).weekday == daysOfWeek.indexOf(day) + 1,
      );
      var totalQtyForDay = 0.0;
      for (var sale in salesPerDay) {
        totalQtyForDay += salesitems
            .where((si) => si['sales_id'] == sale['id'])
            .fold<double>(0, (p, e) => p + (e['quantity'] as int));
      }


      qtyPerDay[day] = totalQtyForDay;
    }
    return qtyPerDay;
  }

  ItemsProvider() {
    getPrefs();
    loadUsers();
  }

  Map<String, dynamic> get currentUser {
    String email = prefs!.getString("email")!;
    var user = users.firstWhere((cat) => cat["email"] == email);
    return user;
  }

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loadItems() async {
    try {
      inventory = await DatabaseHelper().select("inventory");
      data = await DatabaseHelper().select("items");
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void loadData() async {
    try {
      inventory = await DatabaseHelper().select("inventory");

      outOfstock = inventory.where((cat) => cat["quantity"] == 0).length;
      instock = inventory.where((cat) => cat["quantity"] != 0).length;
      total = outOfstock + instock;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void loadselectedItems() async {
    try {
      for (var i = 0; i < selectedwithIndex.length; i++) {
        selectedItems.add(
          data.firstWhere(
            (cat) =>
                cat["id"].toString() ==
                selectedwithIndex.keys.toList()[i].toString(),
          ),
        );
      }

      for (var i = 0; i < selectedItems.length; i++) {
        eachItemTotal.add(
          selectedItems[i]["unitcost"] * selectedwithIndex.values.toList()[i],
        );
      }
      totalofselected = eachItemTotal.fold<double>(
        0,
        (previousValue, e) => e + previousValue,
      );
      print(eachItemTotal);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void loadavailItems() async {
    try {
      inventory = await DatabaseHelper().select("inventory");

      data = List<Map<String, dynamic>>.from(
        await DatabaseHelper().select("items"),
      );

      // data.removeWhere(
      //   (cat) =>
      //       cat["id"].toString() ==
      //       inventory
      //           .where(
      //             (inv) => inv["quantity"] == 0 || inv["quantity"] == null,
      //           )
      //           .first["productid"]
      //           .toString(),
      // );

      data.removeWhere((e) {
        var inv = inventory.where(
          (i) => i["productid"].toString() == e["id"].toString(),
        );
        if (inv.isEmpty) {
          return false;
        }
        return inv.first["quantity"] == 0 || inv.first["quantity"] == null;
      });

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void loadUsers() async {
    try {
      users = await DatabaseHelper().select("account");
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void loadselectedInven() {
    selectedInven.clear();
    for (var i = 0; i < selectedItems.length; i++) {
      selectedInven.add(
        inventory
            .where(
              (cat) =>
                  cat["productid"].toString() ==
                  selectedItems[i]["id"].toString(),
            )
            .toList()
            .first,
      );
    }
    print("result : ${selectedInven}");
  }

  bool NotAllAvailable() {
    // List<Map<String, dynamic>> test = [];
    // for (var i = 0; i < selectedInven.length; i++) {
    //   test.add(
    //     selectedInven
    //         .firstWhere(
    //           (cat) =>
    //               cat["quantity"] <
    //               selectedwithIndex.values.toList().first,
    //               orElse: () => {},
    //         )
    //   );
    // }

    bool isNotAvailable = false;

    for (var selectedInv in selectedInven) {
      if (selectedInv["quantity"] <
          selectedwithIndex[selectedInv["productid"].toString()]) {
        isNotAvailable = true;
      }
    }
    // test.removeWhere((item) => item.isEmpty);
    // print("test :${test}");
    // if (test.isEmpty) {
    //   return false;
    // } else {
    //   return true;
    // }

    return isNotAvailable;
  }

  void confPurchase() {
    int newquantity;
    for (var value in selectedInven) {
      newquantity =
          value["quantity"] - selectedwithIndex[value["productid"].toString()];
      try {
        DatabaseHelper().update(
          "inventory",
          {"quantity": newquantity},
          {"productid": value["productid"]},
        );
      } catch (e) {
        print("Error : ${e}");
      }
    }
    selectedInven.clear();
    selectedItems.clear();
    selectedwithIndex.clear();
    eachItemTotal.clear();
    notifyListeners();
  }

  void clearSelectedItems() {
    selectedItems = [];
    notifyListeners();
  }

  void saveSales() async {
    try {
      DatabaseHelper().insert("sales", {
        "date": DateTime.now().toString(),
        "complete_total": totalofselected,
      });
      var num = await DatabaseHelper().getlastindex();
      int i = 0;
      for (var elem in selectedItems) {
        int quan = selectedwithIndex[elem["id"].toString()];

        DatabaseHelper().insert("salesitems", {
          "sales_id": int.parse(num),
          "productid": elem["productid"],
          "quantity": quan,
          "name": elem["name"],
          "unitprice": elem["unitcost"],
          "total": eachItemTotal[i],
        });
        i++;
      }
      confPurchase();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void loadsalesItems() async {
    try {
      salesitems = await DatabaseHelper().select("salesitems");
      sales = await DatabaseHelper().select("sales");
    } catch (e) {
      print(e);
    }
  }
}
