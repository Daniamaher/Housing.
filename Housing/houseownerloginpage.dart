import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Housing/pages/HouseOwnerRegistrationPage.dart';
import 'package:flutter_application_1/Housing/pages/HousesPage.dart';
import 'package:flutter_application_1/Housing/pages/widgets/customTextField.dart';
import 'package:flutter_application_1/constant.dart';

class HouseOwnerLoginPage extends StatefulWidget {
  const HouseOwnerLoginPage({Key? key}) : super(key: key);

  @override
  State<HouseOwnerLoginPage> createState() => _HouseOwnerLoginPageState();
}

class _HouseOwnerLoginPageState extends State<HouseOwnerLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> signIn(BuildContext context) async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showErrorDialog('Email and password are required.');
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      await user!.reload(); 
      if (user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return HousingPage();
          }),
        );
      } else {
        showErrorDialog('Email is not verified. Please verify your email.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          errorMessage = 'User not found';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password';
        } else {
          errorMessage = 'An error occurred: ${e.message}';
        }
        showErrorDialog(errorMessage!);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        showErrorDialog(errorMessage!);
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          MaterialButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150),
              Center(
                child: Image.asset(
                  'images/imageicon.png',
                  width: 220,
                  height: 220,
                ),
              ),
              SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              CustomTextField(
                hint: 'Email',
                controller: emailController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hint: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => signIn(context),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:20), 

              Center(
                child: Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HouseOwnerRegistrationPage()));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}















