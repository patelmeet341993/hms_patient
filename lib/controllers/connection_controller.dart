import 'package:flutter/cupertino.dart';
import 'package:hms_models/hms_models.dart';
import 'package:provider/provider.dart';

import '../providers/connection_provider.dart';
import 'navigation_controller.dart';

class ConnectionController {
  static ConnectionController? _instance;

  factory ConnectionController() {
    return _instance ?? ConnectionController._();
  }

  ConnectionController._();

  bool checkConnection({bool isShowErrorSnakbar = true, BuildContext? context}) {
    ConnectionProvider connectionProvider = Provider.of<ConnectionProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(!connectionProvider.isInternet && isShowErrorSnakbar && context != null) {
      MyToast.showError( msg: 'AppStrings.no_internet',context: context);
    }

    return connectionProvider.isInternet;
  }
}