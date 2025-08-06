import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color textColor;
  final Color hintColor;
  final Color fillColor;
  final Color borderColor;
  final EdgeInsets? padding;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final VoidCallback? onTogglePassword;
  final bool showPassword;
  final double? height;

  const RegisterTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.textColor = const Color(0xFFF3D69B),
    this.hintColor = const Color(0xFFF3D69B),
    this.fillColor = const Color(0xFF2F4771),
    this.borderColor = const Color(0xFFF3D69B),
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.isPassword = false,
    this.onTogglePassword,
    this.showPassword = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: controller,
      obscureText: isPassword ? !showPassword : obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        labelText: labelText,
        labelStyle: TextStyle(
          color: textColor,
        ),
        suffixIcon: isPassword ? GestureDetector(
          onTap: onTogglePassword,
          child: Icon(
            showPassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            color: textColor,
          ),
        ) : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );

    if (height != null) {
      return Container(
        height: height,
        padding: padding,
        child: textField,
      );
    } else {
      return Padding(
        padding: padding!,
        child: textField,
      );
    }
  }
}