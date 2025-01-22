import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, Map<String, int>> statistics = {
    'eenaduNews': {'true': 0, 'false': 0},
    'readNewspaper': {'true': 0, 'false': 0},
    '15Daysoffer': {'true': 0, 'false': 0},
    'employmentType': {'true': 0, 'false': 0},
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').get();

      Map<String, Map<String, int>> tempStats = {
        'eenaduNews': {'true': 0, 'false': 0},
        'readNewspaper': {'true': 0, 'false': 0},
        '15Daysoffer': {'true': 0, 'false': 0},
        'employmentType': {'true': 0, 'false': 0},
      };

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        updateStatistics(tempStats, 'eenaduNews', userData['eenaduNews'] as bool? ?? false);
        updateStatistics(tempStats, 'readNewspaper', userData['readNewspaper'] as bool? ?? false);
        updateStatistics(tempStats, '15Daysoffer', userData['15Daysoffer'] as bool? ?? false);
        updateStatistics(tempStats, 'employmentType', userData['employmentType'] as bool? ?? false);
      }

      setState(() {
        statistics = tempStats;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching statistics: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateStatistics(Map<String, Map<String, int>> stats, String field, bool value) {
    if (stats.containsKey(field)) {
      stats[field]![value ? 'true' : 'false'] = (stats[field]![value ? 'true' : 'false'] ?? 0) + 1;
    }
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
          "Statistics",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: statistics.length,
              itemBuilder: (context, index) {
                String field = statistics.keys.elementAt(index);
                Map<String, int> counts = statistics[field]!;
                return Container(
                  decoration:  BoxDecoration(
                     gradient: const LinearGradient(
            colors: [Colors.brown, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15),),
          border: Border.all(width: 2)
                  ),
                  margin: const EdgeInsets.symmetric(horizontal:  8.0, vertical: 4),
                  child: ListTile(
                    title: Text(field, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Yes : ${counts['true']}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black), ),
                        Text('No  : ${counts['false']}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

