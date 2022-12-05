import 'package:flutter/material.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';
import 'package:patient/views/common/componants/common_topbar.dart';

import '../componants/treatment_activity.dart';


class TreatmentActivityDetailScreen extends StatefulWidget {
  static const String routeName = "/TreatmentActivityDetailScreen";

  const TreatmentActivityDetailScreen({Key? key}) : super(key: key);

  @override
  _TreatmentActivityDetailScreenState createState() => _TreatmentActivityDetailScreenState();
}

class _TreatmentActivityDetailScreenState extends State<TreatmentActivityDetailScreen> {
  late ThemeData themeData;
  List<String> messageList = [
    "Appointment Registered Successfully",
    "Doctor Has been Assigned for your Treatment",
    "Your treatment has been Completed",
    "Payment Done Successfully",
  ];

  List<String> timingList = [
    "9:35 AM",
    "9:48 AM",
    "9:50 AM",
    "9:52 AM",
  ];

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      color: themeData.backgroundColor,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CommonTopBar(title: "Treatment Activity"),
              SizedBox(height: 1,),
              Expanded(
                child: ListView.builder(
                itemCount: 4 ,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    shrinkWrap: true,
                  itemBuilder: (context,index){
                  return TreatmentActivityScreen(
                    visitModel: VisitModel(),
                    time: timingList[index],
                    message:  messageList[index],
                    isButtonVisible: index == 2 || index == 3 ? true:false,
                    buttonName: index == 2 ? "Download Invoice" : index == 3 ? "Pay Now" : "",
                  );
                }
          ),
              ),

            ],
          ),
        ),
      ),
    );
  }


}
