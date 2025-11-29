import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/pages/navPages/home.dart';
import 'package:inventory_tracker/presentation/pages/navPages/inventory.dart';
import 'package:inventory_tracker/presentation/pages/navPages/reports.dart';
import 'package:inventory_tracker/presentation/pages/navPages/sales.dart';
import 'package:inventory_tracker/presentation/pages/navPages/settings.dart';
import 'package:inventory_tracker/presentation/providers/themeprovider.dart';
import 'package:inventory_tracker/theme/apptheme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _navPages = [
    Home(),
    Inventory(),
    Reports(),
    Sales(),
    Settings()
  ];
  int currentPageIndex = 0;
  ThemeProvider themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
   themeProvider  = Provider.of<ThemeProvider>(
        context,
        listen: false,
      );
    return Scaffold(
      body: _navPages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        fixedColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (value) => setState(() {
          currentPageIndex = value;
        }),
        items: [
          bottomNavItem(Icons.home, "Home"),
          bottomNavItem(Icons.inventory_2_outlined, "Inventory"),
          bottomNavItem(Icons.add_chart_rounded, "Purchase"),
          bottomNavItem(Icons.table_chart_outlined, "Sales"),
          bottomNavItem(Icons.settings_sharp, "Settings"),
        ]),
    );
  }
BottomNavigationBarItem bottomNavItem(IconData icon, String label) {
  return BottomNavigationBarItem(
      icon: Icon(icon), label: label, backgroundColor: themeProvider.currentTheme.bottomNavigationBarTheme.backgroundColor,);
}
}
