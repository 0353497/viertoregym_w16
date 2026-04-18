import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:viertoregym/pages/membership_page.dart';
import 'package:viertoregym/pages/studios_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final String user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/Icon.png", width: 120),
        ),
        title: Text(
          "VierToreGym",
          style: TextStyle(
            color: Color(0xff3e9f1f),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi, ${widget.user}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
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
                      onPressed: Get.back,
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Color(0xff3fa220),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Get.to(() => MembershipPage(user: widget.user));
                },
                child: SizedBox(
                  width: double.maxFinite,
                  height: Get.height * .3,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(32),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          right: -240,
                          top: -150,
                          child: Container(
                            width: 450,
                            height: 450,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffddeddb),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 12,
                            children: [
                              Image.asset(
                                "assets/Icons/User attributes.png",
                                height: 100,
                              ),
                              Text(
                                "Membership",
                                style: TextStyle(
                                  color: Color(0xff3e9f1f),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => StudiosPage());
                },
                child: SizedBox(
                  width: double.maxFinite,
                  height: Get.height * .3,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(32),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          right: -240,
                          top: -150,
                          child: Container(
                            width: 450,
                            height: 450,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffddeddb),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 12,
                            children: [
                              Image.asset(
                                "assets/Icons/Location on.png",
                                height: 100,
                              ),
                              Text(
                                "Studios",
                                style: TextStyle(
                                  color: Color(0xff3e9f1f),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
