import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/views/common/screens/notification_screen.dart';
import 'package:patient/views/treatment_history/screens/treatment_history_screen.dart';

import '../views/about_us/screens/about_us_screen.dart';
import '../views/admit_details/screens/admit_details_screen.dart';
import '../views/authentication/login_screen.dart';
import '../views/authentication/otp_screen.dart';
import '../views/homescreen/screens/homescreen.dart';
import '../views/splashscreen.dart';
import '../views/treatment_history/screens/treatment_activity_detail_screen.dart';

class NavigationController {
  static NavigationController? _instance;
  static String chatRoomId = "";
  static bool isNoInternetScreenShown = false;
  static bool isFirst = true;

  factory NavigationController() {
    _instance ??= NavigationController._();
    return _instance!;
  }

  NavigationController._();

  static final GlobalKey<NavigatorState> mainScreenNavigator = GlobalKey<NavigatorState>();

  static bool isUserProfileTabInitialized = false;


  static bool checkDataAndNavigateToSplashScreen() {
    MyPrint.printOnConsole("checkDataAndNavigateToSplashScreen called, isFirst:$isFirst");

    if(isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirst = false;
        Navigator.pushNamedAndRemoveUntil(mainScreenNavigator.currentContext!, SplashScreen.routeName, (route) => false);
      });
    }

    return isFirst;
  }

  static Route? onMainGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole("OnMainGeneratedRoutes called for ${settings.name}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if(kIsWeb) {
      if(!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/": {
        page = const SplashScreen();
        break;
      }
      case SplashScreen.routeName: {
        page = const SplashScreen();
        break;
      }
      case LoginScreen.routeName: {
        page = const LoginScreen();
        break;
      }
      case OtpScreen.routeName: {
        dynamic arguments = settings.arguments;

        if(arguments is String && arguments.isNotEmpty) {
          page = OtpScreen(mobile: arguments,);
        }
        break;
      }
      case HomeScreen.routeName: {
        page = const HomeScreen();
        break;
      }
      case NotificationScreen.routeName: {
        page = const NotificationScreen();
        break;
      }
      case TreatmentHistoryScreen.routeName: {
        page = const TreatmentHistoryScreen();
        break;
      }
      case AdmitDetailsScreen.routeName: {
        page =  AdmitDetailsScreen();
        break;
      }
      case TreatmentActivityDetailScreen.routeName: {
        page = const TreatmentActivityDetailScreen();
        break;
      }
      case AboutUsScreen.routeName: {
        page = const AboutUsScreen();
        break;
      }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
  }

 /* static Route? onProfileGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole(s) called for ${settings.name}");

    if(kIsWeb) {
      if(!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }

    MyPrint.printOnConsole(s) Page:$isFirst");
    Widget? page;

    switch (settings.name) {

      case SplashScreen.routeName: {
        page = const SplashScreen();
        break;
      }

    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }

  }*/


}
