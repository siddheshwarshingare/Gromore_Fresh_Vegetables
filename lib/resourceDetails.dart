import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_rep/bigColonText.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Resources Details",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          
          itemCount: 10,
          itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
             gradient: LinearGradient(
                colors: [
                  Colors.white,
                 Colors.deepOrange,
                ], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 0,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Agent Name :    ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Prashant",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 24),
                    )
                  ],
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 5,
                ),
                MoreTextColonText(title: "Route Name", value: "SR Nagar"),
                MoreTextColonText(title: "Houses Assigned", value: "60"),
              ],
            ),
          );
        }),
      ),


      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        HapticFeedback.mediumImpact();
      },
      backgroundColor: Colors.blueAccent,
      elevation: 5,
       label: Row(
         children: [
          Icon(Icons.add_box_outlined, color: Colors.white, size: 25,),
           Text("Add Agent", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
         ],
       ),),
    );
  }
}


class MoreTextColonText extends StatelessWidget {
  final String? title;
  final String? value;
  final double? fSize;
  const MoreTextColonText(
      {super.key, required this.title, required this.value, this.fSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  ":   ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: fSize),
                )
              ],
            )),
        Expanded(
          flex: 6,
          child: Text(
            value ?? "",
            style: TextStyle(fontSize: fSize, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
