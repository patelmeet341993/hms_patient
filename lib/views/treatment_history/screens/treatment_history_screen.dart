import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/container/container.dart';
import '../../../packages/flux/widgets/text/text.dart';
import '../../common/componants/common_bold_text.dart';

class TreatmentHistoryScreen extends StatefulWidget {
  static const String routeName = "/TreatmentHistoryScreen";

  const TreatmentHistoryScreen({Key? key}) : super(key: key);

  @override
  _TreatmentHistoryScreenState createState() => _TreatmentHistoryScreenState();
}

class _TreatmentHistoryScreenState extends State<TreatmentHistoryScreen> {
  late ThemeData themeData;
  bool isEvent = true;
  List<bool> isNewVisit = [
    true,
    false,
    false,
    true,
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
              getTopBar(),
              SizedBox(height : 1),
              Expanded(
                child: isEvent?Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                        itemCount: 4,
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return getSingleEvent(newVisit: isNewVisit[index]);
                        }
                    )
                  ],
                ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonBoldText(text: "No Treatment History",fontSize: 20,color: Colors.black.withOpacity(.6)),
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
            Expanded(child: CommonBoldText(text: "Treatment History",textAlign: TextAlign.center,fontSize: 20,)),
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

  Widget getSingleEvent({bool newVisit = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Styles.cardColor,


      ),
      child: Row(
        children: [
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: themeData.primaryColor),
              borderRadius: BorderRadius.circular(4),

              color: newVisit
                    ? themeData.primaryColor.withAlpha(60)
                    : Colors.transparent
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.bodyMedium(
                   "12",
                    fontWeight: 700,
                    color: themeData.primaryColor,
                  ),
                  FxText.bodySmall(
                    "Aug",
                    fontWeight: 600,
                    color: themeData.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  "Fever and Headache",
                  fontWeight: 600,
                ),
               // FxSpacing.height(2),
                Row(
                  children: [
                    FxText.bodySmall(
                      "11:35 AM",
                      fontSize: 10,
                    ),
                    FxSpacing.width(5),
                    FxText.bodySmall(
                      newVisit?"•  New Visit":"•  Old Visit",
                      fontSize: 10,
                    ),

                  ],
                ),
                FxSpacing.height(2),
                FxText.bodySmall(
                  "Dr. Viren Desai",
                  fontSize: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
