import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:patient/packages/flux/flutx.dart';
import 'package:patient/views/common/componants/common_text.dart';

import '../controllers/navigation_controller.dart';
import 'authentication/login_screen.dart';
import 'common/componants/common_bold_text.dart';
import 'homescreen/homescreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ThemeData themeData;

  Future<void> checkLogin() async {
    await Future.delayed(Duration(seconds: 3));

    if(Random().nextBool()) {
      NavigationController.isFirst = false;
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }
    else {
      NavigationController.isFirst = false;
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
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
    );
  }
}
