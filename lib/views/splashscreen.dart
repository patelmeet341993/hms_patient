import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/controllers/authentication_controller.dart';
import 'package:patient/controllers/patient_controller.dart';

import '../controllers/navigation_controller.dart';
import 'authentication/login_screen.dart';
import 'common/componants/common_bold_text.dart';
import 'homescreen/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ThemeData themeData;

  Future<void> checkLogin() async {
     await Future.delayed(const Duration(seconds: 3));

    bool isUserLoggedIn = await AuthenticationController().isUserLoggedIn();
    MyPrint.printOnConsole("isUserLoggedIn:$isUserLoggedIn");
    NavigationController.isFirst = false;
    if(isUserLoggedIn) {
      await PatientController().getPatientsDataForMainPage();
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }
    else {
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: !kIsWeb && Platform.isIOS?Brightness.light:Brightness.dark,
          statusBarIconBrightness: !kIsWeb && Platform.isIOS?Brightness.light:Brightness.dark,
        ));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      checkLogin();

    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      color: themeData.backgroundColor,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Container(
                 padding: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.black,width: 2),
                   borderRadius: BorderRadius.circular(5)
                 ),
                 child: Icon(Icons.vaccines,color: themeData.primaryColor,size: 80)),
             SizedBox(height: 18),
             CommonBoldText(text: "Hospital Management \n System",fontSize: 20,textAlign: TextAlign.center,),


            ],
          ),
        ),
      ),
    );
  }
}
