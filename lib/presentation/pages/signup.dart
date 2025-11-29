import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databasehelper.dart';
import 'package:inventory_tracker/presentation/pages/signin.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/toastification/sucess.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
 
  void signUp()async{
    if (formKey.currentState!.validate()) {
      try {
        await DatabaseHelper().insert("account", {
          "name" : nameController.text,
          "email" : emailController.text,
          "password" : passwordController.text
        });
        showSuccessMessage(context, "Saved successfully");
      } catch (e) {
        print(e);
        showErrorMessage(context, "Something went wrong");
      }
      
    } else {
      
    }
  }

  bool isStrong(word) {
    String capital = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String digits = "1234567890";
    String lower = capital.toLowerCase();

    bool hasCapital = false;
    bool hasLower = false;
    bool hasDigit = false;

    for (var i = 0; i < word.length; i++) {
      var char = word[i];
      if (capital.contains(char)) {
        hasCapital = true;
      }
      if (digits.contains(char)) {
        hasDigit = true;
      }
      if (lower.contains(char)) {
        hasLower = true;
      }
    }

    if (hasDigit && hasLower && hasCapital && word.length >= 8) {
      return true;
    } else {
      return false;
    }
  }
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                  text: "NAME",
                  hintText: "Reto John",
                  controller: nameController,
                  validator: (value) {
                    if (value!.length < 4) {
                      return "Name cannot be less than 4 characters";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                Customtextfield(
                  text: "Email",
                  hintText: "examlpe@gmail.com",
                  controller: emailController,
                  validator: (value) {
                     var regex = RegExp(r"[a-z]+[0-9]*@[a-z]+\.[a-z]");
                  if (regex.hasMatch(value!)) {
                    return null;
                  } else {
                    return "Invalid email format";
                  }
                  },
                ),
                SizedBox(height: 20),
                Customtextfield(
                  text: "Password",
                  hintText: "********",
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (isStrong(value)) {
                      return null;
                    } else {
                      return "Password not strong enough";
                    }
                  },
                ),
                SizedBox(height: 20),
                Custombutton(text: "Sign Up", onPressed: signUp),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?  "),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SinginPage()),
                      ),
                      child: Text(
                        "Sign In",
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
