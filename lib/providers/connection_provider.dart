import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hms_models/hms_models.dart';


class ConnectionProvider extends ChangeNotifier {
  bool isInternet = true;
  StreamSubscription<ConnectivityResult>? subscription;

  ConnectionProvider() {
    MyPrint.printOnConsole("ConnectionProvider constructor called");
    if(kIsWeb) {
      isInternet = true;
    }
    else {
      isInternet = Platform.isIOS;
    }
    try {
      Connectivity().checkConnectivity().then((ConnectivityResult result) {
        MyPrint.printOnConsole("Connectivity Result:$result");
        isInternet = result == ConnectivityResult.none ? false : true;

        MyPrint.printOnConsole("Connection Subscription Started");
        subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
          MyPrint.printOnConsole("Connectivity Result:$result");
          isInternet = result == ConnectivityResult.none ? false : true;
          notifyListeners();
        });
      });
    }
    catch (E) {
      MyPrint.printOnConsole("Error in Connectivity Subscription:  $E");
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    subscription = null;
  }
}