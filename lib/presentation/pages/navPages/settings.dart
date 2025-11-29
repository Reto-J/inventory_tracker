import 'package:flutter/material.dart';
import 'package:inventory_tracker/helper/databasehelper.dart';
import 'package:inventory_tracker/presentation/pages/signin.dart';
import 'package:inventory_tracker/presentation/providers/items_provider.dart';
import 'package:inventory_tracker/presentation/providers/themeprovider.dart';
import 'package:inventory_tracker/presentation/toastification/error.dart';
import 'package:inventory_tracker/presentation/toastification/sucess.dart';
import 'package:inventory_tracker/presentation/widgets/customButton.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool? isLight;
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
  ItemsProvider itemsProvider = ItemsProvider();

  @override
  void initState() {
      itemsProvider = Provider.of<ItemsProvider>(listen: false, context);
    loadItems();
    loadTheme();
    getPresntUser();
    super.initState();
  }

  void loadTheme(){
    try {
      var themeprovider = Provider.of<ThemeProvider>(context,listen: false);
      themeprovider.loadTheme();
    } catch (e) {
      print(e);
    }
  }

  void loadItems() {
    try {
      itemsProvider.loadUsers();
    } catch (e) {
      print(e);
      showErrorMessage(context, "Something went wrong");
    }
  }

  void getPresntUser() async {
    try {
      itemsProvider.loadUsers();
      final prefs = await SharedPreferences.getInstance();
      String email = prefs.getString("email")!;
      isLight = prefs.getBool("isLight")!;
      setState(() {
        
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Consumer<ThemeProvider>(
        builder: (context, tp, child) {
          return Consumer<ItemsProvider>(
            builder: (context, ip, child) {
              var currentUser = ip.currentUser;
              if (ip.users.isEmpty){
                return CircularProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 55,
                        child: Icon(Icons.person, size: 100),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      currentUser["name"],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(currentUser["email"]),
                    SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Row(
                        children: [
                          Icon(Icons.password_rounded),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  TextEditingController passwordController =
                                      TextEditingController();
                                  TextEditingController newpasswordController =
                                      TextEditingController();
                                  return Dialog(
                                    child: SizedBox(
                                      height: 280,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Enter current password",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Customtextfield(
                                              isPassword: true,
                                              hintText: "*******",
                                              controller: passwordController,
                                            ),
                                            SizedBox(height: 10),
                                            Text("Enter new password",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,)),
                                            SizedBox(height: 10,),
                                            Customtextfield(
                                              isPassword: true,
                                              hintText: "*******",
                                              controller: newpasswordController,
                                              validator: (value) {
                                                if (isStrong(value)) {
                                                  return null;
                                                } else {
                                                  return "Password is not strong enough";
                                                }
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Custombutton(
                                              text: "Next",
                                              onPressed: () {
                                                if (passwordController.text ==
                                                    ip.users.firstWhere(
                                                      (cat) => cat["id"] == currentUser["id"],
                                                    )["password"]) {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    DatabaseHelper().update(
                                                      "account",
                                                      {
                                                        "password":
                                                            newpasswordController
                                                                .text,
                                                      },
                                                      {"id": currentUser["id"]},
                                                    );
                                                    Navigator.pop(context);
                                                    showSuccessMessage(
                                                      context,
                                                      "Password Changed sucessfully👍✅",
                                                    );
                                                  } else {
                                                    showErrorMessage(
                                                      context,
                                                      "New password not strong enough",
                                                    );
                                                  }
                                                } else {
                                                  showErrorMessage(
                                                    context,
                                                    "Old password is incorrect",
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Change password",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.theaters),
                            SizedBox(width: 10),
                            Text(
                              "Change theme",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: tp.isLight ?? true,
                          onChanged: (value) async {
                            final theme = await SharedPreferences.getInstance();
                            await theme.setBool("isLight", value);
                            setState(() {
                              tp.setIsLight(value);
                            });
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    Custombutton(
                      text: "Log Out",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.question_mark,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "Are you sure you want to Log Out",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(height: 50),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Custombutton(
                                              text: "Cancle",
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              fgColor: Colors.blue,
                                              brColor: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Custombutton(
                                              text: "Confirm",
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SinginPage(),
                                                  ),
                                                );
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
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}
