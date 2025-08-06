import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/widgets/landingPageButtons.dart';

void main() {
  runApp(const landingPage());
}

class landingPage extends StatefulWidget {
  const landingPage({super.key});

  @override
  State<landingPage> createState() => _landingPageState();
}

class _landingPageState extends State<landingPage> {

  late VoidCallback moveToLoginPage;
  late VoidCallback moveToRegisterPage;

  @override
  void dispose() {
    // Cleanup code goes here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    moveToLoginPage = () {
      Get.toNamed("/Login");
    };

    moveToRegisterPage = () {
      Get.toNamed("/Register");
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF122247), //#abcdd2 chose this color instead
        body: SafeArea(
          child: Center(
            child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Hi There!!",
                          style: TextStyle(
                            fontSize: 24.0,        // Make text bigger
                            color: Colors.white,   // White text color
                            fontWeight: FontWeight.bold, // Optional: make it bold
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      landingPageButton(
                        text: "Login",
                        backgroundColor: Colors.white,
                        textColor: Color(0xFF122247),
                        onPressed: moveToLoginPage,
                        buttonKey: 'login_button',
                      ),
                      landingPageButton(
                        text: "Register",
                        backgroundColor: Color(0xFFF3D69B),
                        textColor: Color(0xFF122247),
                        onPressed: moveToRegisterPage,
                        buttonKey: 'register_button',
                      )
                    ],
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}

