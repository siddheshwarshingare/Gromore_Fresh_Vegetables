import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sales_rep/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        foregroundColor: Colors.black,
        toolbarHeight: 80,
        backgroundColor: Colors.purpleAccent.shade100,
        actions: [Icon(Icons.abc_outlined)],
        title: Text(
          applocalizations!.myProfile,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Images/org1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
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
                              await prefs.clear(); // Clear shared preferences
                              await Future.delayed(
                                  Duration(milliseconds: 1500));
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

//clipath class...
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
