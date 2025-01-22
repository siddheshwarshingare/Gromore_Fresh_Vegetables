import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sales_rep/staticData.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Map<String, List<Map<String, dynamic>>> groupedUsers = {};
  bool isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> fetchDataFromFirebase() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Query Firebase with date range filters
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .where('timestamp', isLessThanOrEqualTo: endDate)
          .get();

      Map<String, List<Map<String, dynamic>>> fetchedUsers = {};

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        String agencyName = userData['agencyName'] ?? 'Unknown Agency';
        if (!fetchedUsers.containsKey(agencyName)) {
          fetchedUsers[agencyName] = [];
        }
        fetchedUsers[agencyName]!.add(userData);
      }

      setState(() {
        groupedUsers = fetchedUsers;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data fetched successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
  DateTime now = DateTime.now(); // Current date and time
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(2000),
    lastDate: now,
  );

  if (pickedDate != null) {
    setState(() {
      if (isStartDate) {
        // Set time to 12:01 AM for the start date
        startDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          0,
          1,
        );
      } else {
        // Use current time for the end date
        endDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          now.hour,
          now.minute,
          now.second,
        );
      }
    });
  }
}



  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Customer Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context, true),
                    controller: TextEditingController(
                      text: startDate == null
                          ? ''
                          : dateFormat.format(startDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      hintText: 'Select Start Date',
                      suffixIcon: const Icon(Icons.calendar_today),
                      // Add a border here
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      // Optionally you can add the focused border
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      // Optional: add a disabled border style (in case the field is disabled)
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context, false),
                    controller: TextEditingController(
                      text: endDate == null ? '' : dateFormat.format(endDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      hintText: 'Select End Date',
                      suffixIcon: const Icon(Icons.calendar_today),
                      // Add a border here
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      // Optionally you can add the focused border
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      // Optional: add a disabled border style (in case the field is disabled)
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Row(
            //   children: [
            //     TextFormField(
            //       onTap: () => _selectDate(context, true),
            //       con
            //     )
            //   ],
            // ),
          ),
          const SizedBox(height: 10),
         
          GestureDetector(
            onTap: () {
              print("Start Date ===> $startDate");
              print("End Date ===> $endDate");
              fetchDataFromFirebase();
            },
            child: Container(
              width: 100,
                 decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(width: 2),
                     
                    ),
                    child: const Center(child: Text('Filter')),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : groupedUsers.isEmpty
                    ? const Center(child: Text('No data available'))
                    : ListView.builder(
                        itemCount: groupedUsers.length,
                        itemBuilder: (context, index) {
                          String agencyName =
                              groupedUsers.keys.elementAt(index);
                          List<Map<String, dynamic>> users =
                              groupedUsers[agencyName]!;
                          return AgencyExpansionTile(
                            agencyName: agencyName,
                            users: users,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class AgencyExpansionTile extends StatelessWidget {
  final String agencyName;
  final List<Map<String, dynamic>> users;

  const AgencyExpansionTile(
      {Key? key, required this.agencyName, required this.users})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(width: 2),
          boxShadow: [
            const BoxShadow(
              color: Colors.black,
              spreadRadius: 0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              const Text(
                "Agency Name  :  ",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              Text(
                agencyName,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              const Text(
                "No. of Surveys  :  ",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '${users.length}',
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: users.map((user) => UserDetailsCard(user: user)).toList(),
        ),
      ),
    );
  }
}

class UserDetailsCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailsCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white),
        gradient: const LinearGradient(
          begin: Alignment.center,
          colors: [Colors.lightBlueAccent, Colors.white],
          stops: [0, 50],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fetchDataflex(user, "Date", "date"),
          fetchDataflex(user, "Time", "time"),
          const Divider(),
          const Text(
            "Family Details",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          fetchDataflex(user, "Head Name", "name"),
          fetchDataflex(user, "Fathers Name", "fathersName"),
          fetchDataflex(user, "Mothers Name", "mothersName"),
          fetchDataflex(user, "Spouse Name", "spouseName"),
          const Divider(),
          const Text(
            "Address Details",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          fetchDataflex(user, "House No.", "houseNo"),
          fetchDataflex(user, "Street No.", "street"),
          fetchDataflex(user, "City", "city"),
          fetchDataflex(user, "Pin Code", "pinCode"),
          fetchDataflex(user, "Address", "address"),
          fetchDataflex(user, "Mobile Number", "mobileNumber"),
          const Divider(),
          const Text(
            "Newspaper Details",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          fetchDataflex(user, "Eenadu Newspaper", "eenaduNews"),
          fetchDataflex(user, "Read Newspaper", "readNewspaper"),
          fetchDataflex(user, "15 Days Offer", "15Daysoffer"),
          fetchDataflex(user, "Feedback", "feedBack"),
          fetchDataflex(user, "Reason for Unsubscription", "reason"),
          fetchDataflex(user, "NewsPaper Name", "newspaper"),
          fetchDataflex(user, "Reason for No newspaper", "reasonNoRead"),
          fetchDataflex(user, "15 days Offer rejected ", "offerNoReason"),
          const Divider(),
          const Text(
            "Employment Details",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          fetchDataflex(user, "Employed", "employmentType"),
          fetchDataflex(user, "Employment", "jobType"),
          fetchDataflex(
              user, "Employment Profession", "employmentTypeProfession"),
          fetchDataflex(user, "Govt Job Type", "govtJobType"),
          fetchDataflex(user, "Govt Job Profession", "govtJobProffession"),
          fetchDataflex(user, "Private Job Profession", "privateJobProfession"),
          fetchDataflex(user, "Designation", "designaton"),
          fetchDataflex(user, "Company Name", "privateCompany"),
        ],
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
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
