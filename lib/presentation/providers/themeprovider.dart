import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_tracker/theme/apptheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData get currentTheme {
    return isLight! ? AppTheme.lightTheme : AppTheme.darkTheme;
  }
  
  bool? isLight = true;

  void loadTheme()async{
    final prefs = await SharedPreferences.getInstance();
    isLight = prefs.getBool("isLight")!;
    if(isLight == null){
      loadTheme();
    }
    notifyListeners();
  }

  void setIsLight(bool value) {
    isLight = value;
    notifyListeners();
  }
  
}