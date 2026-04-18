import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key, required this.user});
  final String user;
  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(color: Color(0xff3fa220), width: 3),
    );
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/Icon.png", width: 120),
        ),
        title: Text(
          "Membership",
          style: TextStyle(
            color: Color(0xff3e9f1f),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: Get.height * .35,
                child: Card(
                  elevation: 8,
                  color: Color(0xffe3f0e1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Member Details",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text("Save"),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Color(0xff3fa220),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          onChanged: (_) {
                            setState(() {});
                          },
                          validator: (value) {
                            return null;
                          },
                          decoration: InputDecoration(
                            hint: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12,
                              children: [
                                Icon(Icons.person),
                                Text(
                                  "${widget.user}",
                                  style: TextStyle(fontSize: 20),
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
                            return null;
                          },
                          decoration: InputDecoration(
                            hint: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12,
                              children: [
                                Icon(Icons.person),
                                Text(
                                  "Weinstein",
                                  style: TextStyle(fontSize: 20),
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
                        InkWell(
                          onTap: () => Get.dialog(
                            CalendarDatePicker(
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              onDateChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          child: TextFormField(
                            enabled: false,
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: (value) {
                              return null;
                            },
                            decoration: InputDecoration(
                              hint: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 12,
                                children: [
                                  Icon(Icons.calendar_month),
                                  Text(
                                    "June 7, 1983",
                                    style: TextStyle(fontSize: 20),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: Get.height * .2,
                child: Card(
                  elevation: 8,
                  color: Color(0xffe3f0e1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subscription Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Bronze Subscription"),
                        Text("Expires on June 29, 2025"),
                        Text("20.00€/month"),
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
