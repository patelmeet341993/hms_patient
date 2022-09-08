import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/widgets/container/container.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = "/NotificationScreen";

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    bool isNotification = true;
    List<bool> isActive = [
      true,
      false,
      false,
      false,
    ];

    return Container(
        color: themeData.backgroundColor,
      child: SafeArea(
        child: Scaffold(
         body: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             getTopBar(),
             SizedBox(height: 1,),
             Expanded(
               child: isNotification?Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   ListView.builder(
                       itemCount: 4,
                       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                       shrinkWrap: true,
                       itemBuilder: (context,index){
                         return getNotificationCard(isActive: isActive[index],text: "Congratulations! You have successfully Registered",time: "9:34 AM");
                       }
                   )
                 ],
               ):Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     CommonBoldText(text: "No Notifications",fontSize: 20,color: Colors.black.withOpacity(.6)),
                    ]
               ),
             ),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FxContainer(
              paddingAll: 6,
              borderRadiusAll: 4,
              color: Styles.cardColor,
              child: InkWell(
                onTap:(){
                  Navigator.pop(context);
                },
                child: Icon(
                  FeatherIcons.chevronLeft,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(child: CommonBoldText(text: "Notifications",textAlign: TextAlign.center,fontSize: 20,)),
            FxContainer(
              paddingAll: 6,
              borderRadiusAll: 4,
              color: Colors.transparent,
              child: Icon(
                FeatherIcons.chevronLeft,
                size: 22,
                color: Colors.transparent,
              ),
            ),

          ],
        )
    );
  }

  Widget getNotificationCard({bool isActive = true,String text = "Notifications",String time = ""}){
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:isActive ? themeData.primaryColor.withOpacity(.25):Styles.cardColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.2,
               letterSpacing: 0.4,
            ),

          ),
          //SizedBox(height: 3,),
          CommonBoldText(text: time,color: Colors.black.withOpacity(.4),fontSize: 13,),

        ],
      ),
    );
  }
}
