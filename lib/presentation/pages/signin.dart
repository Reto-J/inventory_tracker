import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databasehelper.dart';
import 'package:inventory_tracker/presentation/pages/home_screen.dart';
import 'package:inventory_tracker/presentation/pages/signup.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SinginPage extends StatefulWidget {
  const SinginPage({super.key});

  @override
  State<SinginPage> createState() => _SinginPageState();
}

class _SinginPageState extends State<SinginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signin() async {
    if (formKey.currentState!.validate()) {
      try {
        var result = await DatabaseHelper().selectWhere("account", {
          "email": emailController.text,
          "password": passwordController.text,
        });
        if (result.isEmpty) {
          showErrorMessage(context, "Email or password incorrect");
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("email", emailController.text);
          await prefs.setString("time", DateTime.now().toString());
          var itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
          itemsProvider.loadUsers;
          clear();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void clear(){
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.widgets_rounded, color: Colors.blue),
                        Text(
                          "GOSTOCK",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                CircleAvatar(child: Icon(Icons.person, size: 100), radius: 60),
                SizedBox(height: 20),
                Customtextfield(
                  text: "Email",
                  hintText: "example@gmail.com",
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please input an email";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                Customtextfield(
                  text: "Password",
                  hintText: "********",
                  controller: passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 20),
                Custombutton(text: "Sign In", onPressed: (){signin();}),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?  "),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
