import 'package:flutter/material.dart';
import 'package:patient/views/common/componants/common_topbar.dart';

class AboutUsScreen extends StatefulWidget {
  static const String routeName = "/AboutUsScreen";
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late ThemeData themeData;


  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      color: themeData.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CommonTopBar(title: "About Us"),
              SizedBox(height: 1,),






            ],
          ),
        ),
      ),


    );
  }



}
