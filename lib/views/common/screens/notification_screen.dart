import 'package:flutter/material.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = "/NotificationScreen";

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
         body: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             getTopBar(),

             Expanded(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   CommonBoldText(text: "No Notifications",fontSize: 20,color: Colors.black.withOpacity(.6)),
                 ],
               ),
             )

           ],
         ),
        ),
      ),
    );
  }

  Widget getTopBar(){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonBoldText(text: "Notifications",textAlign: TextAlign.center,fontSize: 20,),
          ],
        )
    );
  }
}
