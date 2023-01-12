import 'package:flutter/material.dart';
import 'package:hms_models/utils/my_print.dart';

import '../../common/componants/common_bold_text.dart';
import '../../common/componants/common_text.dart';

class VisitFilterBottomSheet extends StatefulWidget {
  const VisitFilterBottomSheet({Key? key}) : super(key: key);

  @override
  _VisitFilterBottomSheetState createState() => _VisitFilterBottomSheetState();
}

class _VisitFilterBottomSheetState extends State<VisitFilterBottomSheet> {

  String gender = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12) )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12,),

          Container(
            width: 70,
            height: 7,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
            ),),
          SizedBox(height: 5,),
          getRadioButtonTile(title: 'All',value: 'All',),
          getRadioButtonTile(title: 'Visits',value: 'Visits',),
          getRadioButtonTile(title: 'Admitted',value: 'Admitted',),
          SizedBox(height: 12,),
        ],
      ),
    );
  }

  Widget getRadioButtonTile({required String title,required String value}){
    return RadioListTile(
      title: CommonBoldText(text:title ),
      value: value,
      groupValue: gender,
      onChanged: (val){
        setState(() {
          gender = val.toString();
        });
      },
    );
  }

}
