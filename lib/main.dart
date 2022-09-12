import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'init.dart';
import 'views/myapp.dart';

Future<void> main() async {

  await runErrorSafeApp(
    () => runApp(
      const MyApp(),
    ),


    isDev: false,
  );

  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(
  //       statusBarColor: Colors.red,
  //       statusBarBrightness: Brightness.dark,
  //       statusBarIconBrightness: Brightness.dark,
  // ));
}