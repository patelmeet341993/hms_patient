import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/configs/styles.dart';
import 'package:patient/views/common/componants/common_button.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../homescreen/screens/visit_screen.dart';
import '../componants/common_bold_text.dart';

class TreatmentTimelineLogMasterWidget extends StatefulWidget {
  int index = 0;
  int? length;
  String primaryText;
  String? subText;
  Timestamp? time;
  bool isPaid =  false;


  TreatmentTimelineLogMasterWidget({
    this.index = 0,
    required this.primaryText,
    this.time,
    this.subText,
    this.length,
    this.isPaid = false,
  });

  @override
  _TreatmentTimelineLogMasterWidgetState createState() =>
      _TreatmentTimelineLogMasterWidgetState();
}

class _TreatmentTimelineLogMasterWidgetState
    extends State<TreatmentTimelineLogMasterWidget> {
  int index = 0;
  late ThemeData themeData;


  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.09,
          isFirst: index == 0,
          isLast: widget.length  != null ? index == widget.length! - 1 :false,
          indicatorStyle: IndicatorStyle(
          width: 50,
          height: 50,
           indicator: getTimeLineNumber(index + 1),
          drawGap: true,
        ),
        beforeLineStyle: LineStyle(
          color: Styles.lightPrimaryColor,
        ),
        endChild: GestureDetector(
          child: Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: getMyInfoShowWidget(),
          ),
        ),
      );
  }

  Widget getMyInfoShowWidget() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonBoldText(text: widget.primaryText,height: 1.1),
                  SizedBox(height: 5,),
                  widget.subText != null ? Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: CommonText(text: widget.subText!,fontSize: 14,),
                  ) : SizedBox.shrink(),
                  widget.time != null ? Text(DateFormat.jm().format(widget.time!.toDate()),
                    style: themeData.textTheme.bodySmall!.copyWith(height: 1,letterSpacing: 0.5,fontSize: 11),
                  ) : SizedBox.shrink(),
                ],
              ),
            ),
            widget.isPaid ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                getPaidButton(),

              ],
            ) : SizedBox()



          ],
        ),
      ),
    );
  }

  Widget getTimeLineNumber(int number) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Styles.lightPrimaryColor,
      ),
      child: Center(
          child: CommonBoldText(
            text: '${number}',
            color: Colors.white,
            fontSize: 18,
          )),
    );
  }

  Widget getPaidButton(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 1),
      decoration: BoxDecoration(
        color: Styles.lightPrimaryColor,
        borderRadius: BorderRadius.circular(25),

      ),
      child: Row(
        children: [
          Icon(Icons.check,color: Colors.white,size: 14,),
          SizedBox(width: 2,),
          CommonBoldText(text: 'Paid',color: Colors.white,fontSize: 11,),
          SizedBox(width: 5,),


        ],
      ),
    );
  }



}
