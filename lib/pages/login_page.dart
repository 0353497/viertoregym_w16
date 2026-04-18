import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:viertoregym/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  static const List _users = [
    {"username": "barbara", "password": "ga83s6"},
    {"username": "michael", "password": "9x7zih"},
  ];

  bool get isEnabled =>
      !(usernameController.value.text.isEmpty ||
          passwordController.value.text.isEmpty);

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(color: Color(0xff3fa220), width: 3),
    );
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () => Get.to(() => HomePage(user: "barbara")),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Image.asset("assets/Icon.png", width: Get.width * .2),
                    Text(
                      "VierToreGym",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3fa220),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Container(
                    width: double.maxFinite,
                    height: Get.height * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: .5,
                          blurRadius: 10,
                          color: Colors.black87,
                        ),
                      ],
                      color: Color(0xffe3f0e1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3fa220),
                            ),
                          ),
                          TextFormField(
                            controller: usernameController,
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null) return "not valid";
                              if (value.trim() == _users[0]["username"] ||
                                  value.trim() == _users[1]["username"])
                                return null;
                              return "not valid username";
                            },
                            decoration: InputDecoration(
                              hint: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 12,
                                children: [
                                  Icon(Icons.person),
                                  Text(
                                    "Username",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                            ),
                          ),
                          TextFormField(
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null) return "not valid";
                              if (value.trim() == _users[0]["password"] ||
                                  value.trim() == _users[1]["password"])
                                return null;
                              return "not valid password";
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hint: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 12,
                                children: [
                                  Icon(Icons.lock),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: double.maxFinite,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  isEnabled
                                      ? Color(0xff3fa220)
                                      : Colors.green.withAlpha(100),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Color(0xffffffff),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      32,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: isEnabled
                                  ? () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        Get.to(
                                          () => HomePage(
                                            user: usernameController.value.text,
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: Text(
                                "Sign in",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text("Not registered yet?"),
                    SizedBox(
                      width: Get.width * .3,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(32),
                              side: BorderSide(
                                color: Color(0xff3fa220),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color(0xff3fa220),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
