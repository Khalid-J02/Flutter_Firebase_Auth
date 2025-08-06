import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/widgets/landingAlertDialog.dart';
import 'package:untitled/widgets/loginTextField.dart';

import '../services/authService.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF122247),
          child: const _LoginPage(),
        ),
      ),
    ) ;
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({super.key});

  @override
  State<_LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<_LoginPage> {

  late String _fullName = '' ;
  late String _email = '' ;
  late String _password = '' ;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  final _authService = AuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
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

  Future<void> _handleAuth() async {
    try{
      bool userExists = await _authService.doesUserExist(_email);
      if (userExists) {
        await _authService.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Get.offNamed("/HomePage");
      }
      if (!userExists){
        landingAlertDialog.showErrorDialog(context, "User doesn't exist. Please register your information first.");
      }
    }catch(e){
      landingAlertDialog.showErrorDialog(context, _getErrorMessage(e.toString()));
    }
  }


    @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LoginTextField(
            controller: _fullNameController,
            labelText: "Full Name",
            hintText: "Enter your full name here ..."
        ),
        LoginTextField(
          controller: _emailController,
          labelText: "Email",
          hintText: "Enter your email here ...",
        ),
        LoginTextField(
          controller: _passwordController,
          labelText: "Password",
          hintText: "Enter your password here ...",
          isPassword: true,
          showPassword: !_obscurePassword,
          onTogglePassword: _togglePasswordVisibility,
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 120),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextButton(
            onPressed: () {
              _signIn() ;
            },
            child: Text(
              "Login" ,
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
            Text(
              "Don't have an account yet?," ,
              style: TextStyle(
                color: Color(0xFFF3D69B),
                fontSize: 15,

              ),
            ),
            TextButton(
              onPressed: () {
                Get.offNamed('/Register');
              },

              child: Text(
                "Register" ,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFF3D69B),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _signIn() async {

    // Get the values from the text controllers
    _fullName = _fullNameController.text;
    _email = _emailController.text;
    _password = _passwordController.text;

    // Check if email or password is not filled
    if (_fullName.isEmpty || _email.isEmpty || _password.isEmpty) {
      landingAlertDialog.showErrorDialog(context, 'Please fill in all the required fields.');
      return;
    }
    else if (!_fullName.contains(" ")) {
      landingAlertDialog.showErrorDialog(context, "Please enter your full name, not just first one");
      return ;
    }
    else if(!_email.isEmail){
      landingAlertDialog.showErrorDialog(context, 'Please enter a valid email');
      return;
    }
    else if(_password.length < 8){
      landingAlertDialog.showErrorDialog(context, 'Password must be at least 8 characters');
      return;
    }
    _handleAuth();
  }
}