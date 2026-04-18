import 'package:flutter/material.dart';

class CreativePage extends StatefulWidget {
  const CreativePage({super.key});

  @override
  State<CreativePage> createState() => _CreativePageState();
}

class _CreativePageState extends State<CreativePage> {
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
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Steps taken", style: TextStyle(fontSize: 32)),
                Text(
                  "12339 steps",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xff3fa220),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Calories burned", style: TextStyle(fontSize: 32)),
                Text(
                  "1200",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xff3fa220),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
