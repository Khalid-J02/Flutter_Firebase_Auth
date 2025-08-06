import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/widgets/landingAlertDialog.dart';

import '../services/authService.dart';
import '../widgets/registerTextField.dart';


class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF122247),
          child: const _RegisterPage(),
        ),
      ),
    );
  }
}

class _RegisterPage extends StatefulWidget {
  const _RegisterPage({super.key});

  @override
  State<_RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  late String _fullName = '';
  late String _email = '';
  late String _password = '';
  late String _confirmPassword = '';

  final _fncontroller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obsecPass = true;
  bool _obsecConfPass = true;

  final _authService = AuthService();

  void _togglePassIcon() {
    setState(() {
      _obsecPass = !_obsecPass;
    });
  }

  void _toggleConfirmPassIcon() {
    setState(() {
      _obsecConfPass = !_obsecConfPass;
    });
  }

  TextStyle ElevatedButtonTextStyle() {
    return const TextStyle(
        color: Color(0xFFF3D69B), fontSize: 16, fontWeight: FontWeight.normal);
  }

  ButtonStyle ElevatedButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF6781A6)),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
            const BorderSide(color: Color(0xFFF3D69B), width: 1)),
        alignment: Alignment.center);
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found with this email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('email-already-in-use')) {
      return 'Email already in use';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else {
      return 'An error occurred. Please try again.';
    }
  }

  bool _validateFields() {
    _fullName = _fncontroller.text.trim();
    _email = _emailController.text.trim();
    _password = _passwordController.text;
    _confirmPassword = _confirmPasswordController.text;

    if (_fullName.isEmpty || _email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      landingAlertDialog.showErrorDialog(context, "Please enter all required data");
      return false;
    }
    else if (!_fullName.contains(" ")) {
      landingAlertDialog.showErrorDialog(context, "Please enter your full name, not just first one");
      return false;
    }
    else if (!_email.isEmail) {
      landingAlertDialog.showErrorDialog(context, "Please make sure to enter a valid email");
      return false;
    }
    else if (_password != _confirmPassword) {
      landingAlertDialog.showErrorDialog(context, "Please make sure the password matches");
      return false;
    }
    else if (_password.length < 8) {
      landingAlertDialog.showErrorDialog(context, "Please make sure the password size is at least 8");
      return false;
    }

    return true;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleAuth() async {
    try {
      bool userExists = await _authService.doesUserExist(_email);
      if (!userExists) {
        await _authService.registerWithEmailAndPassword(
          email: _email,
          password: _password,
          fullName: _fullName,
        );
        _showSnackBar('Account created successfully!', Colors.green);
        Get.offNamed('/Login');
      } else {
        landingAlertDialog.showErrorDialog(context, 'User already exists with this email');
      }
    } catch (e) {
      landingAlertDialog.showErrorDialog(context, _getErrorMessage(e.toString()));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 30),
        RegisterTextField(
          controller: _fncontroller,
          labelText: "Full Name",
          hintText: "Enter your full name here ...",
          height: 70,
        ),
        RegisterTextField(
          controller: _emailController,
          labelText: "Email Address",
          hintText: "Enter your email address here ...",
          height: 70,
          keyboardType: TextInputType.emailAddress,
        ),
        RegisterTextField(
          controller: _passwordController,
          labelText: "Password",
          hintText: "Enter your password here ...",
          height: 70,
          isPassword: true,
          showPassword: !_obsecPass,
          onTogglePassword: _togglePassIcon,
        ),
        RegisterTextField(
          controller: _confirmPasswordController,
          labelText: "Confirm Password",
          hintText: "Confirm your password here ...",
          height: 70,
          isPassword: true,
          showPassword: !_obsecConfPass,
          onTogglePassword: _toggleConfirmPassIcon,
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 120),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextButton(
            onPressed: () async {
              if (_validateFields()) {
                await _handleAuth();
              }
            },
            child: const Text(
              "Register",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF122247),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Already have an account?",
              style: TextStyle(
                color: Color(0xFFF3D69B),
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                // go to login page
                Get.offNamed('/Login');
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFF3D69B),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}