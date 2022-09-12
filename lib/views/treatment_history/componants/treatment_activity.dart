import 'package:flutter/material.dart';

import '../../../configs/styles.dart';
import '../../common/componants/common_button.dart';
import '../../common/componants/common_text.dart';

class TreatmentActivityScreen extends StatefulWidget {
  String time;
  String message;
  bool isButtonVisible = false;
  String buttonName;
  Function()? buttonOnTap;
  TreatmentActivityScreen({required this.time,required this.message,this.isButtonVisible = false,this.buttonName = "",this.buttonOnTap});

  @override
  _TreatmentActivityScreenState createState() => _TreatmentActivityScreenState();
}

class _TreatmentActivityScreenState extends State<TreatmentActivityScreen> {
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CommonText(text:widget.time,color: Colors.grey,fontSize: 13,)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                color: Styles.cardColor,
                //color: themeData.primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: widget.message,),
                          widget.isButtonVisible?Container(
                            padding: EdgeInsets.only(top: 5),
                            child: CommonButton(buttonName: widget.buttonName, onTap: widget.buttonOnTap,verticalPadding: 3,fontWeight: FontWeight.normal,)
                          ):SizedBox.shrink(),
                        ],
                      )
                  ),
                ],
              ),

            ),
          ),
        ],
      ),
    );
  }
}
