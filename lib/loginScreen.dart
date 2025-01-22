import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_rep/dashBoardOfUnitManager.dart';
import 'package:sales_rep/agentDashBoard.dart';
import 'package:sales_rep/historyPage.dart';
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
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Logo/tt.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(40),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //   child: Image.asset(
                    //     "assets/Logo/vegetables.jpg",
                    //     width: 200,
                    //     height: 150,
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
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
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                          // Toggle visibility
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
                    // Center(
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       HapticFeedback.mediumImpact();
                    //       // String userAgent = await DeviceInfoUtil.getUserAgent(
                    //       //     Theme.of(context).platform);
                    //       // _login(context, userAgent);
                    //       // Handle login logic
                    //       String username = _usernameController.text;
                    //       String password = _passwordController.text;
                    //       print('Username: $username, Password: $password');
                    //       if (_formKey.currentState!.validate()) {
                    //         // Perform login action

                    //         _loginMethod(username, password);
                    //       }
                    //     },
                    //     child: Container(
                    //       height: 50,
                    //       width: double.infinity,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.black),
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Colors.blue,
                    //       ),
                    //       child: Center(
                    //         child: _isLoading
                    //             ? const CupertinoActivityIndicator(
                    //                 color: Colors.white,
                    //                 radius: 15.0,
                    //               )
                    //             : const Text(
                    //                 'LOGIN',
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                   Center(
  child: SliderButton(
    action: () async {
      HapticFeedback.mediumImpact();
      String username = _usernameController.text;
      String password = _passwordController.text;

      if (_formKey.currentState!.validate()) {
        // Show loading animation and delay
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(), // Replace with your animation if needed
            );
          },
        );

        // Simulate login delay (e.g., for API call)
        await Future.delayed(Duration(seconds: 2));

        // Dismiss the loading dialog
        Navigator.of(context).pop();

        // Perform the login action
        _loginMethod(username, password);
      }
      
      // Return false to avoid auto-resetting the slider button
      return false;
    },
    label: Text(
      "Login",
      style: TextStyle(
          color: Color(0xff4a4a4a),
          fontWeight: FontWeight.w500,
          fontSize: 17),
    ),
  ),
)

                  ],
                ),
              ),
            ),
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
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (username == "Raje" && password == "Raje") {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashBoard(),
        ),
      );
    }
    if (username == "admin" && password == "admin") {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashBoardOfUnitManager(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 700),
          content: Title(
            color: Colors.redAccent,
            child: const Center(
              child: Text(
                "Invalid credentials",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }
  }
}
