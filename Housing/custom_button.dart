import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_application_1/constant.dart';


import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onTap, this.isLoading = false, required this.textbutton, this.onPressed});

  final void Function()? onTap;
    final void Function()? onPressed;

 final String textbutton;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(
              8,
            )),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    
                  ),
                )
              :  Text(
                  textbutton,
                  style: TextStyle(
                    color: ksecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}