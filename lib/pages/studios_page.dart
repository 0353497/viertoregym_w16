import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  late Future<List<dynamic>> studiosAndBroadcasts = Future.wait([
    JsonReader.getStudios(),
    JsonReader.getBroadcastInformation(),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: studiosAndBroadcasts,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final response = asyncSnapshot.data ?? [];
          final studioList = response.isNotEmpty
              ? response[0] as List
              : <dynamic>[];
          final broadcastList = response.length > 1
              ? response[1] as List
              : <dynamic>[];
          if (studioList.isEmpty) {
            return const Center(child: Text("No studios available"));
          }

          final latestBroadcasts =
              broadcastList.whereType<Map<String, dynamic>>().toList()
                ..sort((a, b) {
                  final dateA = DateTime.tryParse(
                    a["created_on"]?.toString() ?? "",
                  );
                  final dateB = DateTime.tryParse(
                    b["created_on"]?.toString() ?? "",
                  );

                  if (dateA == null && dateB == null) return 0;
                  if (dateA == null) return 1;
                  if (dateB == null) return -1;
                  return dateB.compareTo(dateA);
                });

          final broadcastItems = latestBroadcasts.take(2).toList();

          return Column(
            children: [
              Container(
                height: 200,
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
                          if (broadcastItems.isEmpty)
                            const Text("No broadcast information available")
                          else
                            for (final broadcast in broadcastItems) ...[
                              Text(broadcast["message"]?.toString() ?? ""),
                              Text(
                                DateFormat("MMMM d, yyyy").format(
                                  DateTime.tryParse(
                                        broadcast["created_on"]?.toString() ??
                                            "",
                                      ) ??
                                      DateTime.now(),
                                ),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                            ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                studio["name"],
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (todayOpeningHours != null)
                      for (int i = 0; i < occupancies.length; i++)
                        SizedBox(
                          height: 200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${(startHour + i).toString().padLeft(2, "0")}",
                                style: TextStyle(fontSize: 12),
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
