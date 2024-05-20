import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/constant.dart';

class CustomTextField extends StatelessWidget {
  final String? label; 
  final String hint;
  final int maxLines;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Function(String)? onChanged;

  CustomTextField({
    Key? key,
    this.label,
    required this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) 
          Text(
            label!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        if (label != null) SizedBox(height: 8), 
        TextFormField(
          obscureText: obscureText,
          onChanged: onChanged,
          controller: controller,
          onSaved: onSaved,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              if (value?.isEmpty ?? true) {
                return 'Field is required';
              } else {
                return null;
              }
            }
          },
          cursorColor: kPrimaryColor,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border: buildBorder(),
            enabledBorder: buildBorder(kPrimaryColor),
            focusedBorder: buildBorder(kPrimaryColor),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
