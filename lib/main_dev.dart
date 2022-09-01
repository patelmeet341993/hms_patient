import 'package:flutter/material.dart';

import 'init.dart';
import 'views/myapp.dart';

Future<void> main() async {
  await runErrorSafeApp(
    () => runApp(
      const MyApp(),
    ),
    isDev: true,
  );
}
