import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/pages/start_screen.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/providers/themeprovider.dart';
import 'package:inventory_tracker/theme/apptheme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MultiProvider(
    providers: [
      
      ChangeNotifierProvider(create:  (context) => ItemsProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
    child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
  void initState() {
    loadTheme();
    super.initState();
  }

  void loadTheme()async{
    var themeprovider = Provider.of<ThemeProvider>(context,listen: false);
    themeprovider.loadTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) { 
    return Consumer<ThemeProvider>(
      builder: (context, tp, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: tp.isLight! ? AppTheme.lightTheme : AppTheme.darkTheme,
          home: StartScreen(),
        );
      }
    );
  }
}
