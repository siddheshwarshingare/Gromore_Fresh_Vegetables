// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sales_rep/bigColonText.dart';
// import 'package:sales_rep/consumerList.dart';
// import 'package:sales_rep/profileScreen.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:sales_rep/resourceDetails.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashBoardOfUnitManager extends StatefulWidget {
//   const DashBoardOfUnitManager({super.key});

//   @override
//   State<DashBoardOfUnitManager> createState() => _DashBoardOfUnitManagerState();
// }

// class _DashBoardOfUnitManagerState extends State<DashBoardOfUnitManager> {
//   @override
//   Widget build(BuildContext context) {
//     String image = "";
//     String? base64Image;
//     Uint8List? webImage;
// final applocalizations = AppLocalizations.of(context);
//     void getSharedPrefdb() async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         image = prefs.getString('profile_image') ?? 'NA';
//         base64Image = prefs.getString('profile_image');
//         if (base64Image != null && kIsWeb) {
//           webImage = base64Decode(base64Image!);
//         }
//       });
//     }

//     if (applocalizations == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return Scaffold(

//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         foregroundColor: Colors.white,
//         centerTitle: false,
//         toolbarHeight: 70,
//         backgroundColor: Colors.blueAccent,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               applocalizations.unitManger,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text("KarimNagar", style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),)
//           ],
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ProfileScreen())).then((_) {
//                 getSharedPrefdb();
//               });
//             },
//             child: Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//               child: base64Image != null
//                   ? ClipOval(
//                       child: kIsWeb
//                           ? Image.memory(
//                               webImage!,
//                               fit: BoxFit.cover,
//                               width: 50,
//                               height: 50,
//                             )
//                           : Image.file(
//                               File(image),
//                               fit: BoxFit.cover,
//                               width: 50,
//                               height: 50,
//                             ),
//                     )
//                   : const Icon(
//                       Icons.person,
//                       size: 40,
//                     ),
//             ),
//           ),
//           const SizedBox(
//             width: 12,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.mediumImpact();
//                 Navigator.push(context, MaterialPageRoute(builder: (_)=> ResourcesPage(),),);
//               },
//               child: cardColoredContainer(
//                 Colors.white,
//                 Colors.redAccent,
//                 applocalizations.numberOfAgent,
//                 "Agents", "26"
//               ),
//             ),
//             SizedBox(height: 15,),
//              GestureDetector(
//               onTap: () {
//                 HapticFeedback.mediumImpact();
//                 Navigator.push(context, MaterialPageRoute(builder: (_)=> ConsumerList(),),);
//               },
//                child: cardMultioptionsColoredContainer(
//                 Colors.white,
//                 Colors.brown,
//                 "Subscription Details",
//                 "Houses Count","15500",
//                 "Eenadu subscription","250",
//                 "Willing to change","50",
//                  "Not Intrested","150",
//                  "Houses Visited", "1900"
//                            ),
//              ),
//           ],
//         ),
//       ),
//     );
//   }

//   Container cardColoredContainer(
//       Color color1,
//       color2,
//       String title,
//       value1, value2

//       ) {
//     return Container(
//       width: double.infinity,
//       // height: 110,
//       decoration: BoxDecoration(
//         // color: Colors.white,
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black, // Shadow color
//             spreadRadius: 0, // Spread of the shadow
//             blurRadius: 2, // Softness of the shadow
//             offset: Offset(4, 4), // Shadow position (x, y)
//           ),
//         ],
//         border: Border.all(width: 1, color: Colors.black),
//         borderRadius: BorderRadius.circular(10), // Curved edges
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(1),
//             width: double.infinity,
//             height: 40,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color1,
//                   color2,
//                 ], // Gradient colors
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               border: const Border(
//                 bottom: BorderSide(width: 1, color: Colors.black38),
//               ),
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10)), // Curved edges
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black, // Shadow color
//                   spreadRadius: 1, // Spread of the shadow
//                   blurRadius: 1, // Softness of the shadow
//                   offset: Offset(0, 0.1), // Shadow position (x, y)
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [

//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w900,
//                       color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 3,
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
//             child: Column(
//               children: [
//                 BigTextColonText(title: value1, value: value2),

//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 3,
//           ),
//         ],
//       ),
//     );
//   }

//   Container cardMultioptionsColoredContainer(
//       Color color1,
//       color2,
//       String title,
//       value1, value2, value3, value4,value5,value6,value7,value8,value9,value10

//       ) {
//     return Container(
//       width: double.infinity,
//       // height: 110,
//       decoration: BoxDecoration(
//         // color: Colors.white,
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black, // Shadow color
//             spreadRadius: 0, // Spread of the shadow
//             blurRadius: 2, // Softness of the shadow
//             offset: Offset(4, 4), // Shadow position (x, y)
//           ),
//         ],
//         border: Border.all(width: 1, color: Colors.black),
//         borderRadius: BorderRadius.circular(10), // Curved edges
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(1),
//             width: double.infinity,
//             height: 40,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color1,
//                   color2,
//                 ], // Gradient colors
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               border: const Border(
//                 bottom: BorderSide(width: 1, color: Colors.black38),
//               ),
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10)), // Curved edges
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black, // Shadow color
//                   spreadRadius: 1, // Spread of the shadow
//                   blurRadius: 1, // Softness of the shadow
//                   offset: Offset(0, 0.1), // Shadow position (x, y)
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [

//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w900,
//                       color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 3,
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
//             child: Column(
//               children: [
//                 BigTextColonText(title: value1, value: value2),
//                  BigTextColonText(title: value9, value: value10),
//                  BigTextColonText(title: value3, value: value4),
//                   BigTextColonText(title: value5, value: value6),
//                    BigTextColonText(title: value7, value: value8),

//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 3,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sales_rep/bigColonText.dart';
import 'package:sales_rep/profileScreen.dart';
import 'package:sales_rep/userListScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashBoardOfUnitManager extends StatefulWidget {
  const DashBoardOfUnitManager({super.key});

  @override
  State<DashBoardOfUnitManager> createState() => _DashBoardOfUnitManagerState();
}

class _DashBoardOfUnitManagerState extends State<DashBoardOfUnitManager> {
  int housesCount = 1000; // This will be updated with the total surveys
  int notintrestedToTakeMilk = 0;
  int intrestedToTakeMilk = 0;
  int intrestedToTakeVegetables = 0;
  int notInterestedToTakeVegetables = 0;
  int numberOfAgents = 0;
  List<String> agentNames = [];
  String image = "";
  String? base64Image;
  Uint8List? webImage;

  Future<void> fetchDataFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('UserData').get();

      Set<String> uniqueAgencies = Set();
      int totalSurveys = snapshot.docs.length;
      int intrestedVegetable = 0;
      int intrestedMilk = 0;
      int notintrestedVegetable = 0;
      int notintrestedMilk = 0;
      int offerFalse = 0;

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['agencyName'] != null) {
          uniqueAgencies.add(data['agencyName']);
        }

        if (data['intrestedToTakeOurVegetables'] == true) {
          intrestedVegetable++;
        } else {
          notintrestedVegetable++;
        }
        if (data['intrestedToTakeOurMilk'] == true) {
          intrestedMilk++;
        } else {
          notintrestedMilk++;
        }
      }
      // "intrestedToTakeOurVegetables": intrestedToTakeGromoreVegetables,
      // "resonForNotTakingOurVegetables": vegetablesReason,
      // "intrestedToTakeOurMilk": intrestedToTakeOutMilk,
      // "reasonForNotTakingOutMilk": milkReason,

      setState(() {
        housesCount = 1000; // Keeping this as 1000 as per your request
        notintrestedToTakeMilk = notintrestedMilk;
        intrestedToTakeMilk = intrestedMilk;
        intrestedToTakeVegetables = intrestedVegetable;
        notInterestedToTakeVegetables = notintrestedVegetable;
        numberOfAgents = uniqueAgencies.length;
        agentNames = uniqueAgencies.toList();
        print("11111111111111111111111111${uniqueAgencies}");
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    print("Interested u: $intrestedToTakeVegetables");
    print("Not interested : $notInterestedToTakeVegetables");
    print("Subscribed users count: $intrestedToTakeMilk");
    print("Houses Visited users count: $notintrestedToTakeMilk");
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // applocalizations.unitManger,
              "unit manager",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "KarimNagar",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen())).then((_) {
                fetchDataFromFirebase();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                showAgentNames();
              },
              child: cardColoredContainer(Colors.white, Colors.redAccent,
                  "Number of resources", "Agents", numberOfAgents.toString()),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserListScreen(),
                  ),
                );
              },
              child: cardMultioptionsColoredContainer(
                Colors.white,
                Colors.lightGreen,
                "Subscription Details",
                "Houses Count",
                housesCount.toString(),
                "Intrested In Vegetables",
                intrestedToTakeVegetables.toString(),
                "Not Intrested In Vegetables",
                notInterestedToTakeVegetables.toString(),
                "Intrested In Milk",
                intrestedToTakeMilk.toString(),
                "Not Intrested In Milk",
                notintrestedToTakeMilk.toString(),
                // "Houses Visited",
                // housesVisitedCount.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container cardColoredContainer(
      Color color1, color2, String title, value1, value2) {
    return Container(
      width: double.infinity,
      // height: 110,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black, // Shadow color
            spreadRadius: 0, // Spread of the shadow
            blurRadius: 2, // Softness of the shadow
            offset: Offset(4, 4), // Shadow position (x, y)
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color1,
                  color2,
                ], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: const Border(
                bottom: BorderSide(width: 1, color: Colors.black38),
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)), // Curved edges
              boxShadow: const [
                BoxShadow(
                  color: Colors.black, // Shadow color
                  spreadRadius: 1, // Spread of the shadow
                  blurRadius: 1, // Softness of the shadow
                  offset: Offset(0, 0.1), // Shadow position (x, y)
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                BigTextColonText(title: value1, value: value2),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }

  Container cardMultioptionsColoredContainer(
      Color color1,
      color2,
      String title,
      value1,
      value2,
      value3,
      value4,
      value5,
      value6,
      value7,
      value8,
      value9,
      value10) {
    return Container(
      width: double.infinity,
      // height: 110,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black, // Shadow color
            spreadRadius: 0, // Spread of the shadow
            blurRadius: 2, // Softness of the shadow
            offset: Offset(4, 4), // Shadow position (x, y)
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color1,
                  color2,
                ], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: const Border(
                bottom: BorderSide(width: 1, color: Colors.black38),
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)), // Curved edges
              boxShadow: const [
                BoxShadow(
                  color: Colors.black, // Shadow color
                  spreadRadius: 1, // Spread of the shadow
                  blurRadius: 1, // Softness of the shadow
                  offset: Offset(0, 0.1), // Shadow position (x, y)
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                BigTextColonText(title: value1, value: value2),
                BigTextColonText(title: value9, value: value10),
                BigTextColonText(title: value3, value: value4),
                BigTextColonText(title: value5, value: value6),
                BigTextColonText(title: value7, value: value8),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }

  void showAgentNames() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agent Names'),
          content: SingleChildScrollView(
            child: ListBody(
              children: agentNames.map((name) => Text(name)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
