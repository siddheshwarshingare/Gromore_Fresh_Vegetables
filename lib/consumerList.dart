import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sales_rep/bigColonText.dart';
import 'package:sales_rep/resourceDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ConsumerList extends StatefulWidget {
  const ConsumerList({super.key});

  @override
  State<ConsumerList> createState() => _ConsumerListState();
}

class _ConsumerListState extends State<ConsumerList> {
  final Map<String, bool> expandedState =
      {}; // Corrected: Using Map for tracking expanded state
  List<String> _names = [];
  List<String> _mobiles = [];
  List<String> agentNameString = [];
  String image = "";
  String? base64Image;
  Uint8List? webImage;
  int? targetCount;
  String? _villageName;
  String? street;
  String? agentName;
  double _latitude = 0.0;
  double _longitude = 0.0;
  // String? agentNameString;

  // Dummy data for agents as a list of strings
  final List<String> agents = ['Rashmi', 'Siddhi', 'Suraj', 'Prashant', 'Raje'];

  // Load details from SharedPreferences
  Future<void> _loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load agent names from SharedPreferences
      agentNameString = prefs.getStringList('agentNames') ?? [];
      print("Loaded Agent Names: $agentNameString");
      if (agentNameString != null) {
      
      }

      // Load other data
      _names = prefs.getStringList('names') ?? [];
      _mobiles = prefs.getStringList('mobiles') ?? [];
      _villageName = prefs.getString('village') ?? "Unknown";
      street = prefs.getString('street') ?? "Unknown";

      // Load latitude and longitude
      _latitude = prefs.getDouble('latitude') ?? 0.0;
      _longitude = prefs.getDouble('longitude') ?? 0.0;

      // Update target count
      targetCount = (40 - _names.length);
    });
  }

  // Save agent names as JSON string
  Future<void> _saveAgentNames(List<Map<String, String>> agentData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonAgentData =
        jsonEncode(agentData); // Convert List<Map> to JSON string
    prefs.setString('agentNames',
        jsonAgentData); // Save the JSON string in SharedPreferences
  }

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

 
  @override
  Widget build(BuildContext context) {
     final applocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Consumer Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: agents.length,
          itemBuilder: (context, index) {
            final agent = agents[index];
            final isExpanded = expandedState[agent] ?? false;

            // Filter records related to this agent
            List<Map<String, String>> agentRecords = [];
            for (int i = 0; i < agentNameString.length; i++) {
              if (agentNameString[i] == agent) {
                agentRecords.add({
                  "name": _names[i],
                  "mobile": _mobiles[i],
                  "latitude": _latitude.toString(),
                  "longitude": _longitude.toString(),
                  "street": street ?? "Unknown",
                  "village": _villageName ?? "Unknown",
                });
              }
            }

            return Column(
              children: [
                // Agent Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.indigoAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                           Text(applocalizations!.name),
                          Text(
                            agent,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expandedState[agent] = !isExpanded;
                              });
                            },
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_double_arrow_up_outlined
                                  : Icons.keyboard_double_arrow_down_outlined,
                            ),
                          ),
                          
                        ],
                      ),
                      MoreTextColonText(title: "Houses Visited ", value: "16")
                    ],
                  ),
                ),
                // Expanded Details for the Agent
                if (isExpanded)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: agentRecords.length,
                      itemBuilder: (context, index) {
                        final record = agentRecords[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 195, 255),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextColonText(
                                title: "Agent",
                                value: agent,
                                fSize: 18,
                              ),
                              TextColonText(
                                title: "Name",
                                value: record["name"]!,
                                fSize: 18,
                              ),
                              TextColonText(
                                title: "Mobile",
                                value: record["mobile"]!,
                                fSize: 18,
                              ),
                              TextColonText(
                                title: 'Latitude',
                                value: record["latitude"]!,
                                fSize: 18,
                              ),
                              TextColonText(
                                title: 'Longitude',
                                value: record["longitude"]!,
                                fSize: 18,
                              ),
                              TextColonText(
                                title: 'Street',
                                value: record["street"]!,
                              ),
                              TextColonText(
                                title: 'Village',
                                value: record["village"]!,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
