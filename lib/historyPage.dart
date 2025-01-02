import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_rep/bigColonText.dart';
import 'package:sales_rep/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

double _latitude = 0.0;
double _longitude = 0.0;

class _HistoryPageState extends State<HistoryPage> {
  // List<Map<String, String>> _detailsList = [];
  List<String> _names = [];
  List<String> _mobiles = [];
  String image = "";
  String? base64Image;
  Uint8List? webImage;
  int? targetCount;
  String? _villageName;
  String? street;

  bool isEnglish = true; // Track language selection

  void getSharedPrefdb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('profile_image') ?? 'NA';
      base64Image = prefs.getString('profile_image');
      if (base64Image != null && kIsWeb) {
        webImage = base64Decode(base64Image!);
      }
    });
  }

  Future<void> _loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load names and mobiles as before
      _names = prefs.getStringList('names') ?? [];
      _mobiles = prefs.getStringList('mobiles') ?? [];
       // Load village name
      _villageName = prefs.getString('village') ?? "Unknown";
      street = prefs.getString('street') ?? "Unknown";

      // Load latitude and longitude from SharedPreferences
      double latitude =
          prefs.getDouble('latitude') ?? 0.0; // Default to 0.0 if not found
      double longitude =
          prefs.getDouble('longitude') ?? 0.0; // Default to 0.0 if not found

      // Optionally, you can store the latitude and longitude in variables for later use
      _latitude = latitude;
      _longitude = longitude;
    });

    setState(() {
      targetCount = (40 - _names.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDetails();
    getSharedPrefdb();
  }

  @override
  Widget build(BuildContext context) {
    final applocalizations = AppLocalizations.of(context);
    if (applocalizations == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title: Text(
          applocalizations.history,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _names.length,
              itemBuilder: (context, index) {
                if (index < _names.length && index < _mobiles.length) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 216, 195, 255),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(
                                1, 1), // Shadow position (horizontal, vertical)
                            blurRadius: 2, // Blur radius
                            spreadRadius: 1, // Spread radius
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextColonText(
                          title: "Name",
                          value: _names[index],
                          fSize: 18,
                        ),
                        TextColonText(
                          title: "Mobile",
                          value: _mobiles[index],
                          fSize: 18,
                        ),
                        TextColonText(
                          title: 'latitude',
                          value: _latitude.toString(),
                          fSize: 18,
                        ),
                        TextColonText(
                          title: 'longitude',
                          value: _longitude.toString(),
                          fSize: 18,
                        ),
                         TextColonText(
                            title: 'Street', value: street.toString()),
                        TextColonText(
                            title: 'Village', value: _villageName.toString()),
                      ],
                    ),
                  );
                } else {
                  return Text("data");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
