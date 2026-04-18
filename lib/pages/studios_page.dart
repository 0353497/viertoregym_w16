import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:viertoregym/services/json_reader.dart';

class StudiosPage extends StatefulWidget {
  const StudiosPage({super.key});

  @override
  State<StudiosPage> createState() => _StudiosPageState();
}

class _StudiosPageState extends State<StudiosPage> {
  @override
  void initState() {
    super.initState();
  }

  late Future<List> studios = JsonReader.getStudios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 160,
            width: double.maxFinite,
            color: Color(0xffc7e2c3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Studios",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Text("We've extended our opening hours"),
                      Text("June 2", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: studios,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset("assets/Map.png", fit: BoxFit.cover),
                    ),
                    Align(
                      alignment: Alignment(.8, -.8),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () => showData(0, asyncSnapshot.data!),
                          child: Image.asset("assets/Icon.png"),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-.6, .38),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () => showData(1, asyncSnapshot.data!),
                          child: Image.asset("assets/Icon.png"),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showData(int i, List studios) {
    final dynamic studio = studios[i];

    const List<String> days = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday",
    ];

    Get.bottomSheet(
      Container(
        height: Get.height * 4,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studio["name"],
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      for (var i = 0; i < 7; i++)
                        Text(
                          days[i],
                          style: TextStyle(
                            fontWeight: DateTime.now().weekday - 1 == i
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                      SizedBox(),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < 7; i++)
                        Text(
                          studio["opening_hours"][days[i]] == null
                              ? "Closed"
                              : "${studio["opening_hours"][days[i]]["from"]} - ${studio["opening_hours"][days[i]]["until"]}",
                          style: TextStyle(
                            fontWeight: DateTime.now().weekday - 1 == i
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                    ],
                  ),

                  SizedBox(),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    if (studio["opening_hours"][days[DateTime.now().weekday -
                            1]] !=
                        null)
                      for (
                        int i = 0;
                        i <
                            (studio["opening_hours"][days[DateTime.now()
                                            .weekday -
                                        1]]["occupancies"]
                                    as List)
                                .length;
                        i++
                      )
                        SizedBox(
                          height: 200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${(i + 6).toString().padLeft(2, "0")}"),
                              Container(
                                width: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: Color(0xff3fa220),
                                ),
                                height:
                                    ((studio["opening_hours"][days[DateTime.now()
                                                    .weekday -
                                                1]]["occupancies"][i]
                                            as int)
                                        .toDouble() *
                                    2),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
