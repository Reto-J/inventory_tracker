import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databaseHelper.dart';
import 'package:inventory_tracker/presentation/data/week.dart';
import 'package:inventory_tracker/presentation/pages/additem.dart';
import 'package:inventory_tracker/presentation/pages/signin.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    try {
      var itemsprovider = Provider.of<ItemsProvider>(context, listen: false);
      itemsprovider.loadData();
      itemsprovider.loadsalesItems();
      setState(() {});
    } catch (e) {
      print(e);
      showErrorMessage(context, "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Consumer<ItemsProvider>(
        builder: (context, ip, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SinginPage()),
                        );
                      },
                    ),
                    backgroundColor: Colors.white,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        child: IconButton(
                          onPressed: () {
                            DatabaseHelper().getlastindex();
                          },
                          icon: Icon(Icons.notifications),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdditemPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ],
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
                children: [
                  Expanded(
                    flex: 2,
                    child: tileContent(
                      Icons.cancel_outlined,
                      ip.outOfstock,
                      "Out of stock",
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: tileContent(
                      Icons.error_outline,
                      ip.instock,
                      "Low stock",
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: tileContent(
                      Icons.check_circle_outline,
                      ip.total,
                      "Total items",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Documents",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("View all", style: TextStyle(color: Colors.grey)),
                ],
              ),

              Expanded(
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 30,
                    centerSpaceColor: Colors.grey,
                    sections: [
                      PieChartSectionData(
                        color: Colors.red,
                        value: ip.outOfstock.toDouble(),
                        title: "Out of stock",
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: ip.instock.toDouble(),
                        title: "In stock",
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: ip.total.toDouble(),
                        title: "Total items",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    backgroundColor: Colors.white,
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),axisNameWidget: Text("No of sales per day",style: TextStyle(fontSize: 12),)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(child: Text(daysOfWeek[value.toInt()].toString()), meta: meta);
                          },
                          reservedSize: 38,
                        ),
                      ),
                    ),
                    barGroups: ip.getSalesPerDay.entries
                        .map(
                          (s) => BarChartGroupData(
                            x: daysOfWeek.indexOf(s.key),
                            barRods: [
                              BarChartRodData(toY: s.value),
                            ],
                          ),
                        )
                        .toList(),
                    // barGroups: ip.sales
                    //     .map(
                    //       (cat) => BarChartGroupData(
                    //         x: ip.sales.indexWhere((sal) => sal["id"] == cat["id"]),
                    //         barRods: [BarChartRodData(toY: ip.salesitems.where((cou) => cou["sales_id"] == cat["id"]).fold<double>(0, (preeviousValue, e) => preeviousValue + e["quantity"] ))],
                    //       ),
                    //     )
                    //     .toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget tileContent(IconData icon, int number, String type) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),

              child: SizedBox(
                height: 40,
                width: 40,
                child: Icon(icon, color: Colors.blueAccent, size: 35),
              ),
            ),
            Text(
              number.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(type, style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    ),
  );
}
