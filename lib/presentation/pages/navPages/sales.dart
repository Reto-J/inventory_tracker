import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/data/week.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:provider/provider.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  void initState() {
    super.initState();
  }

  void loadsalesItems() {
    try {
      var itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      itemsProvider.loadsalesItems();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ItemsProvider>(
        builder: (context, ip, child) {
          return Column(
            children: [
              Text(
                "View Sales",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: ip.sales.length,
                  itemBuilder: (context, index) {
                    int say = 0;
                    return Card(
                      child: ListTile(
                        leading: Text(
                          daysOfWeek[DateTime.parse(
                            ip.sales[index]["date"],
                          ).weekday],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        title: Text(
                          DateTime.parse(
                            ip.sales[index]["date"],
                          ).toLocal().toString().substring(0, 11),
                        ),
                        subtitle: Text("Earned : ${ip.sales[index]["complete_total"]}"),
                        trailing: GestureDetector(child: Text("View",style: TextStyle(color: Colors.blue),),onTap: (){
                          say = ip.sales[index]["id"];
                          showDialog(context: context, builder: (context){
                            return Dialog(
                              child: SizedBox(
                                height: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListView.builder(itemCount: ip.salesitems.where((cat) => cat["sales_id"] == say).length,itemBuilder: (context, numb){
                                    return Card(
                                      child: ListTile(
                                        title: Text(ip.salesitems[numb]['name']),
                                        subtitle: Text("${ip.salesitems[numb]["quantity"]} items at ${ip.salesitems[numb]["unitprice"]} per item"),
                                        trailing: Text("Total earned ${ip.salesitems[numb]["total"]}"),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          });
                        },),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
