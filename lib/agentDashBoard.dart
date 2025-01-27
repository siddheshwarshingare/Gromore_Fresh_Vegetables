import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_rep/bigColonText.dart';
import 'package:sales_rep/createCustomerDetails.dart';
import 'package:sales_rep/fetchTheDataFromFireBase.dart';
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
  List<String> _names = [];
  List<String> _mobiles = [];
  String image = "";
  String? base64Image;
  Uint8List? webImage;
  int? targetCount;
  int housesCount = 1000;
  int housesVisitedCount = 0;
  int notIntrestesToJoinPeopleWithGromoreVegetables = 0;
  int intrestesToJoinPeopleWithGromoreVegetables = 0;
  int milkTakingIntrestesPeople = 0;
  int milkNotTakingIntrestesPeople = 0;
  String currentusername = '';
  bool isEnglish = true;
  List<Map<String, dynamic>> users = [];

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

  Future<void> fetchDataFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('UserData').get();
      // filter method
      List<Map<String, dynamic>> filterUsers = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((user) => user['agencyName'] == currentusername)
          .toList();

      setState(() {
        users = filterUsers;
      });
      print("users stored ====> $users");
      Set<String> uniqueAgencies = Set();
      int totalSurveys = users.length;
      int gromoreVegetablesIntrestesPeople = 0;
      int gromoreVegetablesNotIntrestesPeople = 0;
      int milkIntrestesPeople = 0;
      int milkNotIntrestesPeople = 0; 
      // Count 'true' and 'false' for eenaduNews
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['agencyName'] != null) {
          uniqueAgencies.add(data['agencyName']);
        }

        if (data['intrestedToTakeOurVegetables'] == true) {
          gromoreVegetablesIntrestesPeople++;
        } else {
          gromoreVegetablesNotIntrestesPeople++;
        }
        if (data['intrestedToTakeOurMilk'] == true) {
          milkIntrestesPeople++;
        } else {
          milkNotIntrestesPeople++;
        }
      }

      setState(() {
        housesCount = 1000; // Keeping this as 1000 as per your request
        housesVisitedCount = totalSurveys;

        intrestesToJoinPeopleWithGromoreVegetables =
            gromoreVegetablesIntrestesPeople;
        notIntrestesToJoinPeopleWithGromoreVegetables =
            gromoreVegetablesNotIntrestesPeople;
        milkTakingIntrestesPeople = milkIntrestesPeople;
        milkNotTakingIntrestesPeople = milkNotIntrestesPeople;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
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
      backgroundColor: const Color.fromARGB(255, 244, 232, 197),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        centerTitle: false,
        toolbarHeight: 75,
        backgroundColor: Colors.green,
        title: Text(
          applocalizations.appTitle,
          style: const TextStyle(
            fontSize: 20,
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
              width: 40,
              height: 45,
              child:
                  const Image(image: AssetImage('assets/Images/profile.png')),
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
          elevation: 25,
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 200,
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset:
                        Offset(1, 1), // Shadow position (horizontal, vertical)
                    blurRadius: 10, // Blur radius
                    spreadRadius: 1, // Spread radius
                  )
                ]),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/Images/org3.jpg"),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ListTile(
                leading: const SizedBox(
                    height: 45,
                    width: 50,
                    child: Image(
                        image: AssetImage('assets/Images/feather-pen.gif'))),
                title: Text(
                  applocalizations.historyPage,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
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

              ListTile(
                leading: const SizedBox(
                    height: 45,
                    width: 45,
                    child: Image(
                        image: AssetImage('assets/Images/checklist.gif'))),
                title: Text(
                  applocalizations.survey,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HistoryPageData(agencyName: currentusername),
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
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'मराठी',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // height: 110,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade200,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(1),
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 0.1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                applocalizations.houseVisited,
                                style: const TextStyle(
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
                      decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(1),
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 0.1),
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
                  const Color.fromARGB(255, 232, 159, 51),
                  const Color.fromARGB(255, 194, 227, 84),
                  applocalizations.myRouteMap,
                  applocalizations.routeDetailsWillComeHere),
              const height(),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 59, 166, 212),
                      Color.fromARGB(255, 47, 89, 237),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(2, 4),
                    ),
                  ],
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
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
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 0.1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          applocalizations.reports,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const height(),
                    Column(
                      children: [
                        FlexTextColonText(
                            title:
                                applocalizations.shownIntrestToTakeVegetables,
                            value: intrestesToJoinPeopleWithGromoreVegetables),
                        FlexTextColonText(
                            title: applocalizations.notIntrestToTakeVegetables,
                            value:
                                notIntrestesToJoinPeopleWithGromoreVegetables),
                        FlexTextColonText(
                            title: applocalizations.shownIntrestToTakeMilk,
                            value: milkTakingIntrestesPeople),
                        FlexTextColonText(
                            title: applocalizations.notshownIntrestToTakeMilk,
                            value: milkNotTakingIntrestesPeople),
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
          backgroundColor: Colors.green,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateCustomerDeatils(),
              ),
            ).then(
              (_) => _loadDetails(),
            );
          },
          icon: Icon(
            Icons.sd_card_alert_outlined,
            color: Colors.black,
            size: 30,
          ),
          label: Text(
            applocalizations.createForm,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
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
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 0.1),
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
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const height()
        ],
      ),
    );
  }
}
