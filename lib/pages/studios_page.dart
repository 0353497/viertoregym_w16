import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  int _selectedStudioIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: studios,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final studioList = asyncSnapshot.data ?? [];
          if (studioList.isEmpty) {
            return const Center(child: Text("No studios available"));
          }

          final selectedStudio =
              studioList[_selectedStudioIndex.clamp(0, studioList.length - 1)];
          final newsText =
              selectedStudio["news"]?.toString() ??
              "No news available for this studio";

          return Column(
            children: [
              Container(
                height: 160,
                width: double.maxFinite,
                color: const Color(0xffc7e2c3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Studios",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Text(newsText),
                          Text(
                            selectedStudio["name"].toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset("assets/Map.png", fit: BoxFit.cover),
                    ),
                    Align(
                      alignment: const Alignment(.8, -.8),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () => selectStudio(0, studioList),
                          child: Image.asset("assets/Icon.png"),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-.6, .38),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () => selectStudio(1, studioList),
                          child: Image.asset("assets/Icon.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void selectStudio(int index, List studios) {
    setState(() {
      _selectedStudioIndex = index;
    });

    showData(index, studios);
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

    final todayKey = days[DateTime.now().weekday - 1];
    final todayOpeningHours = studio["opening_hours"][todayKey];
    final occupancies = (todayOpeningHours?["occupancies"] as List?) ?? [];
    final fromTime = todayOpeningHours?["from"]?.toString() ?? "00:00";
    final startHour = int.tryParse(fromTime.split(":").first) ?? 0;

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
                    if (todayOpeningHours != null)
                      for (int i = 0; i < occupancies.length; i++)
                        SizedBox(
                          height: 200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${(startHour + i).toString().padLeft(2, "0")}",
                              ),
                              Container(
                                width: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: Color(0xff3fa220),
                                ),
                                height:
                                    ((occupancies[i] as int).toDouble() * 2),
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
