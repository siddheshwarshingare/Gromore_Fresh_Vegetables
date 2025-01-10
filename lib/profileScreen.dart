import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_rep/bigColonText.dart';
import 'package:sales_rep/createCustomerDetails.dart';
import 'package:sales_rep/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? base64Image;
  Uint8List? webImage; // For storing image in web
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  void getSharedPrefdb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      base64Image = prefs.getString('profile_image');
      if (base64Image != null && kIsWeb) {
        webImage = base64Decode(base64Image!);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Handle for web
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
          base64Image = base64Encode(bytes);
        });
      } else {
        // Handle for mobile
        setState(() {
          base64Image = pickedFile.path;
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'profile_image', kIsWeb ? base64Image! : pickedFile.path);
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefdb();
  }

  @override
  Widget build(BuildContext context) {
    final applocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title:  Text(
          applocalizations!.myProfile,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              badges.Badge(
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.green),
                position: badges.BadgePosition.bottomEnd(bottom: 5, end: 15),
                showBadge: true,
                onTap: () => _pickImage(ImageSource.gallery),
                badgeContent:
                    const Icon(Icons.edit, color: Colors.white, size: 20),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: base64Image != null
                      ? ClipOval(
                          child: kIsWeb
                              ? Image.memory(
                                  webImage!,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                )
                              : Image.file(
                                  File(base64Image!),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              // Profile Details Section
              Container(
                height: 250,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 244, 244),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child:  Column(
                  children: [
                    BigTextColonText(
                      title:applocalizations!.name,
                      value: "Raje",
                      fSize: 16,
                    ),
                    SizedBox(height: 5),
                    BigTextColonText(
                      title: applocalizations.emailId,
                      value: "raje@",
                      fSize: 16,
                    ),
                    SizedBox(height: 5),
                    BigTextColonText(
                      title: applocalizations.jodRole,
                      value: "Gromore Farming Agent",
                      fSize: 16,
                    ),
                    SizedBox(height: 5),
                    BigTextColonText(
                      title: applocalizations.mobileNumber,
                      value: "7769032792",
                      fSize: 16,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    alertdialogBox();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Logout', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CupertinoActivityIndicator(radius: 20.0),
            ),
        ],
      ),
    );
  }

  void alertdialogBox() {
    showDialog(
      context: context,
      barrierDismissible: !_isLoading, // Prevent closing when loading
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //await prefs.clear(); // Clear shared preferences
                                await Future.delayed(Duration(milliseconds: 1500));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Loginscreen()),
                                (Route<dynamic> route) =>
                                    false, // This removes all the previous routes
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          radius: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
