import 'package:flutter/material.dart';
import 'package:sales_rep/agentDashBoard.dart';
import 'package:sales_rep/dashBoardOfUnitManager.dart';
import 'package:sales_rep/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? username = "";
  String? password = "";
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Simulate a delay for 1 second
    await Future.delayed(const Duration(seconds: 2));

    // Check login status
    bool isLoggedIn = await _checkLoginStatus();

    // Navigate based on login status
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => password == "admin"
              ? const DashBoardOfUnitManager()
              : const DashBoard(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Loginscreen()),
      );
    }
  }

  Future<bool> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the username from SharedPreferences
    setState(() {
      username = prefs.getString('userName');
      password = prefs.getString('passWord');
    });

    // Check if the username is not null or empty
    return username != null;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          height: 600,
          image: AssetImage("assets/Images/org3.jpg"),
        ),
      ),
    );
  }
}
