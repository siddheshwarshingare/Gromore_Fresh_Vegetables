import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_rep/createCustomerDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPageData extends StatefulWidget {
  final String agencyName;

  const HistoryPageData({
    Key? key,
    required this.agencyName,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPageData> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String currentusername = "";

  Future<void> _loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentusername = prefs.getString("username") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDetails();
    fetchUsersForAgency();
  }

  Future<void> fetchUsersForAgency() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('UserData').get();

      // Filter users belonging to the specific agency
      List<Map<String, dynamic>> fetchedUsers = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((user) => user['agencyName'] == widget.agencyName)
          .toList();

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final applocalizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title: Text(
          "$currentusername Survey's",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        gradient: const LinearGradient(
                          begin: Alignment.center,
                          colors: [Colors.cyan, Colors.white],
                          stops: [0, 50],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fetchDataflex(user, applocalizations!.date, "date"),
                          fetchDataflex(user, applocalizations!.time, "time"),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              applocalizations!.familyDetails,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          fetchDataflex(
                              user, applocalizations!.familyHeadName, "name"),
                          const Divider(),
                          Center(
                            child: Text(
                              applocalizations!.addressDetails,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          fetchDataflex(
                              user, applocalizations!.houseNumber, "houseNo"),
                          fetchDataflex(
                              user, applocalizations!.streetNo, "street"),
                          fetchDataflex(
                              user, applocalizations!.address, "address"),
                          fetchDataflex(user, applocalizations!.mobilenumber,
                              "mobileNumber"),
                          const Divider(),
                          Center(
                            child: Text(
                              applocalizations!.vegetablesDetails,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          fetchDataflex(
                              user,
                              applocalizations.shownIntrestToTakeVegetables,
                              "intrestedToTakeOurVegetables"),
                          fetchDataflex(
                              user,
                              applocalizations
                                  .reasonForNotTakingGromoreVegetables,
                              "resonForNotTakingOurVegetables"),
                          fetchDataflex(
                              user,
                              applocalizations.shownIntrestToTakeMilk,
                              "intrestedToTakeOurMilk"),
                          fetchDataflex(
                              user,
                              applocalizations.reasonForNotTakingGromoreMilk,
                              "reasonForNotTakingOutMilk"),
                          const Divider(),
                          Center(
                            child: Text(
                              applocalizations.employmentDetails,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          fetchDataflex(user, applocalizations.employed,
                              "employmentType"),
                          fetchDataflex(
                              user, applocalizations.employeeType, "jobType"),
                          fetchDataflex(
                              user,
                              applocalizations.employementProfession,
                              "employmentTypeProfession"),
                          fetchDataflex(user, applocalizations.govtjobtype,
                              "govtJobType"),
                          fetchDataflex(user, applocalizations.governmentjob,
                              "govtJobProffession"),
                          const height(),
                          Center(
                            child: Text(
                              applocalizations.privatejob,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          fetchDataflex(user, applocalizations.privatejob,
                              "privateJobProfession"),
                          fetchDataflex(
                              user, applocalizations.designation, "designaton"),
                          fetchDataflex(user, applocalizations.companyname,
                              "privateCompany"),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget fetchDataflex(Map<dynamic, dynamic> user, String title, String value) {
    var displayValue = user[value];
    if (displayValue is bool) {
      displayValue = displayValue ? 'Yes' : 'No';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(":",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 4,
            child: Text(displayValue?.toString() ?? 'N/A',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
