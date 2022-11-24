import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

import '../../../packages/flux/widgets/text/text.dart';


class MyPrescriptionScreen extends StatefulWidget {
  const MyPrescriptionScreen({Key? key}) : super(key: key);

  @override
  _MyPrescriptionScreenState createState() => _MyPrescriptionScreenState();
}

class _MyPrescriptionScreenState extends State<MyPrescriptionScreen> {
  late ThemeData themeData;
  String currentMonth = DateFormat('MMMM').format(DateTime.now());
  List<String> dates = [
    "12\nTue",
    "13\nWed",
    "14\nThu",
    "15\nFri",
    "16\nSat",
    "16\nSat",
    "16\nSat",
    "16\nSat",
    "16\nSat",
    "16\nSat",
  ];

  List<String> monthsList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      color: themeData.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodyMedium("Today",
                            letterSpacing: 0,
                            color: Colors.black.withOpacity(.7),
                            fontWeight: 500),
                        FxText.bodyLarge(DateFormat('d MMM').format(DateTime.now()),
                            color: Colors.black,
                            fontWeight: 600),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Icon(
                        FeatherIcons.calendar,
                        size: 22,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1,color: themeData.primaryColor),),
                child: DropdownButton(
                  value: currentMonth,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  dropdownColor: Colors.white,
                  underline: Container(),iconEnabledColor: Colors.black,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(4),
                  items: monthsList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? val) async{
                    currentMonth = val!;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: FxText.titleMedium("Activity",
                    color: Colors.black,
                    muted: true,
                    fontWeight: 600),
              ),
            ],
          ),
        ),
      ),
    );

  }

}


/* Widget singleDateWidget({String? date, required int index}) {
    if (selectedDate == index) {
      return InkWell(
        onTap: () {
          setState(() {
            selectedDate = index;
          });
        },
        child: Container(
          width: 50,
          height: 80,
         // padding: EdgeInsets.fromLTRB(0, 8, 0, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: themeData.primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FxText.bodySmall(
                date.toString(),
                fontWeight: 600,
                color: Colors.white,
                height: 1.9,
                textAlign: TextAlign.center,
              ),
              Container(
                margin: FxSpacing.top(12),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color:Colors.white, shape: BoxShape.circle),
              )
            ],
          ),
        ),
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          selectedDate = index;
        });
      },
      child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Styles.cardColor,
        ),
        //padding: EdgeInsets.fromLTRB(0, 8, 0, 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.bodySmall(
              date.toString(),
              fontWeight: 600,
              color: Colors.black,
              height: 1.9,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
*/