import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_rep/agentDashBoard.dart';
import 'package:sales_rep/dashBoardOfUnitManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:slider_button/slider_button.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({
    super.key,
  });

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> storeDataToFirebase() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    try {
      await firestore.collection('userCredential').doc(username).set({
        'userName': username,
        'passWord': password,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 217, 217),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Images/org3.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
          Column(
            children: [
              const Spacer(
                flex: 3,
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.all(35),
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 83, 140, 106),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.redAccent, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.redAccent, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SliderButton(
                              action: () async {
                                HapticFeedback.mediumImpact();
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                if (_formKey.currentState!.validate()) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Text('');
                                    },
                                  );

                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  Navigator.of(context).pop();
                                  storeDataToFirebase();
                                  _loginMethod(username, password);
                                }

                                return false;
                              },
                              label: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 212, 113, 113),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              icon: const Icon(Icons.swipe_left_outlined)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  _loginMethod(String username, String password) async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    if (username == "Raje" && password == "Raje") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userName", username);
      prefs.setString("passWord", password);
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashBoard(),
        ),
      );
    }
    if (username == "admin" && password == "admin") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userName", username);
      prefs.setString("passWord", password);
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashBoardOfUnitManager(),
        ),
      );
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 700),
          content: Center(
            child: Text(
              "Invalid credentials",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
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
