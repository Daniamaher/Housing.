

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Housing/pages/Services/FirestoreService.dart';
import 'package:flutter_application_1/Housing/pages/addhousepage.dart';
import 'package:flutter_application_1/Housing/pages/housedetailspage.dart';
import 'package:flutter_application_1/Housing/pages/houseownerloginpage.dart';
import 'package:flutter_application_1/Housing/pages/HouseOwnerRegistrationPage.dart';
import 'package:flutter_application_1/Housing/pages/HousesPage.dart';

import 'package:provider/provider.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_application_1/Housing/pages/Services/FirestoreService.dart';
import 'package:flutter_application_1/Housing/pages/HousesPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'House Owner Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'houseownerloginpage',
      routes: {
          'houseownerloginpage': (context) => HouseOwnerLoginPage(),

        'houseownerregister': (context) => HouseOwnerRegistrationPage (),
        'houses': (context) => HousingPage(),
        'addHouse': (context) => AddHousePage(),

        'HouseDetailsPage': (context) => DisplayHouseDetailPage(houseDetails: HouseDetails.defaultData()),





      },
    );
  }

}


