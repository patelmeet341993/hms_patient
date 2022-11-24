import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../views/authentication/login_screen.dart';
import 'navigation_controller.dart';

class AuthenticationController {
  Future<bool> isUserLoggedIn() async {
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    User? firebaseUser = await FirebaseAuth.instance.authStateChanges().first;

    if(firebaseUser == null) {
      if(kIsWeb) {
        await Future.delayed(const Duration(seconds: 2));
        firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
      }
    }

    if(firebaseUser != null && (firebaseUser.phoneNumber ?? "").isNotEmpty) {
      authenticationProvider.setFirebaseUser(firebaseUser, isNotify: false);
      authenticationProvider.setUserId(firebaseUser.uid, isNotify: false);
      authenticationProvider.setMobileNumber(firebaseUser.phoneNumber ?? "", isNotify: false);
      return true;
    }
    else {
      logout(context: NavigationController.mainScreenNavigator.currentContext!);
      return false;
    }
  }

  Future<bool> logout({required BuildContext context, bool isNavigateToLogin = false}) async {
    bool isLoggedOut = false;

    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    authenticationProvider.clearData(isNotify: false);

    try {
      Future.wait([
        FirebaseAuth.instance.signOut().then((value) {
          MyPrint.printOnConsole("Logged Out User From Firebase Auth");
        })
        .catchError((e, s) {
          MyPrint.printOnConsole("Error in Logging Out User From Firebase:$e");
          MyPrint.printOnConsole(s);
        }),
      ]);
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Logging Out:$e");
      MyPrint.printOnConsole(s);
    }

    isLoggedOut = true;

    if(isNavigateToLogin) {
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
    }

    return isLoggedOut;
  }
}