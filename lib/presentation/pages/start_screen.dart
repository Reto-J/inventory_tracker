import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/pages/home_screen.dart';
import 'package:inventory_tracker/presentation/pages/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), (){autologin();});
    super.initState();
  }
 void autologin()async{
   final prefs = await SharedPreferences.getInstance();

    if (prefs.getString("email") == null || prefs.getString("email")!.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SinginPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.widgets, 
              color: Colors.white, 
              size: 120
              ),
            Text(
              "GOSTOCK",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
