import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/firestore_controller.dart';
import '../../packages/flux/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../utils/logger_service.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData themeData;


  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: FxBottomNavigationBar(
        containerDecoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        activeContainerColor:Colors.green,
        fxBottomNavigationBarType: FxBottomNavigationBarType.containered,
        showActiveLabel: false,
        showLabel: false,
        activeIconSize: 24,
        iconSize: 24,
        activeIconColor: Colors.blue,
        iconColor: Colors.red,
        itemList: [
          FxBottomNavigationBarItem(
            page: Container(),
            activeIconData: Icons.house,
            iconData: Icons.house_outlined,
          ),
          FxBottomNavigationBarItem(
            page: Container(),
            activeIconData: Icons.date_range,
            iconData: Icons.date_range_outlined,
          ),
          FxBottomNavigationBarItem(
            page: Container(),
            activeIconData: Icons.chat_bubble,
            iconData: Icons.chat_bubble_outline_rounded,
          ),
          FxBottomNavigationBarItem(
            page: Container(),
            activeIconData: Icons.person,
            iconData: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }
}
