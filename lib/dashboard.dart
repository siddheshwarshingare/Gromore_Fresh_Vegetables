import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_rep/bigColonText.dart';
import 'package:sales_rep/createCustomerDetails.dart';
import 'package:sales_rep/historyPage.dart';
import 'package:sales_rep/main.dart';
import 'package:sales_rep/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({
    super.key,
  });

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // List<Map<String, String>> _detailsList = [];
  List<String> _names = [];
  List<String> _mobiles = [];
  String image = "";
  String? base64Image;
  Uint8List? webImage;
  int? targetCount;

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

  // Load details from SharedPreferences
  Future<void> _loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _names = prefs.getStringList('names') ?? [];
      _mobiles = prefs.getStringList('mobiles') ?? [];
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

  // Function to toggle between English and Spanish
  void _toggleLanguage(bool value) {
    setState(() {
      isEnglish = value;
    });
    // Change language based on the toggle
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.changeLanguage(isEnglish
        ? const Locale('en')
        : const Locale('te')); // Change language using provider
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
        toolbarHeight: 50,
        backgroundColor: Colors.blueAccent,
        title: Text(
          applocalizations.gromoreOraganicFreshVegetables,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen())).then((_) {
                getSharedPrefdb();
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: base64Image != null
                  ? ClipOval(
                      child: kIsWeb
                          ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : Image.file(
                              File(image),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 40,
                    ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      drawer: Container(
        width: 280,
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: 150,
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset:
                        Offset(1, 1), // Shadow position (horizontal, vertical)
                    blurRadius: 5, // Blur radius
                    spreadRadius: 1, // Spread radius
                  )
                ]),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Images/enadu.png"),
                    ),
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.insert_chart_outlined_sharp,
                  color: Colors.blue,
                ),
                title: Text(applocalizations.historyPage),
                // trailing: Text(
                //   targetCount.toString(),
                //   style: TextStyle(color: Colors.red, fontSize: 16),
                // ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryPage(),
                    ),
                  );
                },
              ),

              // Spacer to push content to the top
              const Spacer(),

              // Bottom section with the language toggle switch
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      applocalizations.chooseYourLanguage,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Text(
                      'मराठी', // Label for the left side
                      style: TextStyle(color: Colors.black),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: isEnglish,
                        onChanged: _toggleLanguage,
                        activeColor: Colors.green,
                        trackColor: Colors.red,
                      ),
                    ),
                    const Text(
                      'English', // Label for the right side
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // height: 110,
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black, // Shadow color
                            spreadRadius: 1, // Spread of the shadow
                            blurRadius: 2, // Softness of the shadow
                            offset: Offset(0, 3), // Shadow position (x, y)
                          ),
                        ],
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)), // Curved edges
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(1),
                            width: double.infinity,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black38),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ), // Curved edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black, // Shadow color
                                  spreadRadius: 1, // Spread of the shadow
                                  blurRadius: 1, // Softness of the shadow
                                  offset:
                                      Offset(0, 0.1), // Shadow position (x, y)
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                applocalizations.houseVisited,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          const height(),
                          Text(
                            "${applocalizations.today} : ${_names.length.toString()}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const height()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // height: 110,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black, // Shadow color
                            spreadRadius: 1, // Spread of the shadow
                            blurRadius: 2, // Softness of the shadow
                            offset: Offset(0, 3), // Shadow position (x, y)
                          ),
                        ],
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)), // Curved edges
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(1),
                            width: double.infinity,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black38),
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                              ), // Curved edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black, // Shadow color
                                  spreadRadius: 1, // Spread of the shadow
                                  blurRadius: 1, // Softness of the shadow
                                  offset:
                                      Offset(0, 0.1), // Shadow position (x, y)
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                applocalizations.todaysTargetLeft,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          const height(),
                          Text(
                            "${applocalizations.today} : ${targetCount.toString()}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const height()
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const height(),
              coloredContainer(
                  const Color(0xFF432E54),
                  const Color.fromARGB(255, 119, 108, 181),
                  applocalizations.myRouteMap,
                  applocalizations.routeDetailsWillComeHere),
              const height(),
              coloredContainer(
                const Color(0xFF543A14),
                const Color.fromARGB(255, 224, 177, 114),
                applocalizations.plannedDetails,
                applocalizations.planeDetailsWillComeHere,
              ),
              const height(),
              Container(
                width: double.infinity,
                // height: 110,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3B1C32),
                      Color(0xFF6A1E55),
                    ], // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black, // Shadow color
                      spreadRadius: 0, // Spread of the shadow
                      blurRadius: 2, // Softness of the shadow
                      offset: Offset(2, 4), // Shadow position (x, y)
                    ),
                  ],
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10), // Curved edges
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(1),
                      width: double.infinity,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black38),
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)), // Curved edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black, // Shadow color
                            spreadRadius: 1, // Spread of the shadow
                            blurRadius: 1, // Softness of the shadow
                            offset: Offset(0, 0.1), // Shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          applocalizations.reports,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const height(),
                    Column(
                      children: [
                        FlexTextColonText(
                            title: applocalizations.alreadySubscribed, value: applocalizations.coming),
                        FlexTextColonText(
                            title: applocalizations.notIntrested, value: applocalizations.coming),
                        FlexTextColonText(
                            title: applocalizations.shownIntrest, value:applocalizations.coming),
                        FlexTextColonText(
                            title:applocalizations.willingToChange, value: applocalizations.coming),
                      ],
                    ),
                    const height()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateCustomerDeatils(),
              ),
            ).then(
              (_) => _loadDetails(),
            );
            // _navigateToInputPage();
          },
          icon: Icon(
            Icons.add_box_outlined,
            color: Colors.white,
            size: 30,
          ),
          label: Text(
            applocalizations.createForm,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
    );
  }

  Container coloredContainer(
    Color color1,
    color2,
    String text1,
    text2,
  ) {
    return Container(
      width: double.infinity,
      // height: 110,
      decoration: BoxDecoration(
        // color: Colors.white,
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black, // Shadow color
            spreadRadius: 0, // Spread of the shadow
            blurRadius: 2, // Softness of the shadow
            offset: Offset(2, 4), // Shadow position (x, y)
          ),
        ],
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10), // Curved edges
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black38),
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)), // Curved edges
              boxShadow: [
                BoxShadow(
                  color: Colors.black, // Shadow color
                  spreadRadius: 1, // Spread of the shadow
                  blurRadius: 1, // Softness of the shadow
                  offset: Offset(0, 0.1), // Shadow position (x, y)
                ),
              ],
            ),
            child: Center(
              child: Text(
                text1,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const height(),
          Text(
            text2,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const height()
        ],
      ),
    );
  }
}
