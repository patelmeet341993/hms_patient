import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';
import 'package:patient/views/common/componants/common_button.dart';
import 'package:patient/views/common/componants/common_text.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/themes/text_style.dart';
import '../../../packages/flux/widgets/container/container.dart';
import '../../../packages/flux/widgets/text_field/text_field.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({Key? key}) : super(key: key);

  @override
  _VisitScreenState createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  late ThemeData themeData;
  bool isFirstTimeUser = false;
  TextEditingController searchController =  TextEditingController();

  List<String> messageList = [
    "Appointment Registered Successfully",
    "Doctor Has been Assigned for your Treatment",
    "Your treatment has been Completed",
    "Payment Done Successfully"

  ];

  List<String> timingList = [
    "9:35 AM",
    "9:48 AM",
    "9:50 AM",
    "9:52 AM",
  ];

  List<bool> invoiceList = [false, false, false, true,];
  List<bool> payList = [false, false, true, false,];



  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      color: themeData.backgroundColor,
      child: SafeArea(
        child: GestureDetector(
           onTap: (){
             FocusScope.of(context).requestFocus(new FocusNode());
           },
          child: Scaffold(
            body: Column(
              children: [
                SizedBox(height: 10,),
                getTopBar(),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: isFirstTimeUser?getForUserFirstTime():getMainPage()
                  ),
                ),




              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget getTopBar() {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: CommonBoldText(text: "Saraswati Clinic",textAlign: TextAlign.start,fontSize: 20,)),
          FxContainer(
            paddingAll: 7,
            borderRadiusAll: 4,
            color: Styles.cardColor,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Icon(
                  Icons.notifications,
                  size: 22,
                  color: Colors.grey,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: FxContainer.rounded(
                    paddingAll: 4,
                    child: Container(),
                    color: themeData.primaryColor,
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget getForUserFirstTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          //color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal:25),
            child: Image.asset("assets/extra/code.png",height: 300,)
        ),
        CommonText(text: "( Scan Your QR Code from Receptionist )"),
      ],
    );
  }

  Widget getMainPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        getTextField(),
        SizedBox(height: 20,),
        CommonBoldText(text: "Profile Overview",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9) ),
        SizedBox(height: 12,),
        getProfileInfo(),
        SizedBox(height: 30,),
        CommonBoldText(text: "My Treatment Activity",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9)),
        SizedBox(height: 18,),
        Expanded(child: getMyTreatment()),







      ],
    );
  }

  Widget getTextField() {
    return FxTextField(
      controller: searchController,
      cursorColor: themeData.primaryColor,
      textFieldStyle: FxTextFieldStyle.outlined,
      labelText: 'Search your last treatment',
      labelStyle: FxTextStyle.bodySmall(
          color: Colors.grey, xMuted: true,fontSize: 15),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 12),
      fillColor: Styles.cardColor,
      enabledBorderColor: themeData.primaryColor,
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeData.primaryColor,),
        borderRadius: BorderRadius.circular(6),
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: themeData.primaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(color: themeData.primaryColor.withOpacity(.6),width: 1),
        borderRadius: BorderRadius.circular(6),
      ) ,
      focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: themeData.primaryColor,width: 1.4),
        borderRadius: BorderRadius.circular(6),
      ) ,
      prefixIcon: Icon(
        FeatherIcons.search,
        color: themeData.primaryColor,
        size: 20,
      ),
    );

  }

  Widget getProfileInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        color: themeData.primaryColor,
        borderRadius: BorderRadius.circular(6),

      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset("assets/extra/code.png",height: 80,width: 80,fit: BoxFit.cover,)),
          SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(text: "Viren Desai",color: Colors.white,fontSize: 17),
                SizedBox(height: 2,),
                CommonText(text: "male   23 years old",color: Colors.white,),
                SizedBox(height: 2,),
                CommonText(text: "19-04-1999",color: Colors.white,),
              ],
            ),
          ),





        ],
      ),
    );
  }

  Widget getMyTreatment() {
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      itemBuilder: (context,index){
        return Container(
            margin: EdgeInsets.only(bottom: 14),
            child: getSingleActivityTile(time: timingList[index],
                message:  messageList[index],isInvoice: invoiceList[index],isPayment: payList[index]));
      }
    );
  }

  Widget getSingleActivityTile({required String time,required String message,bool isPayment = false,bool isInvoice = false}){
    Widget getActionButton = SizedBox.shrink();
    if(isPayment){
      getActionButton = Container(
          padding: EdgeInsets.only(top: 5),
          child: CommonButton(buttonName: "Pay Now", onTap: (){},verticalPadding: 3,fontWeight: FontWeight.normal,));
    }else if(isInvoice){
      getActionButton = Container(
          padding: EdgeInsets.only(top: 5),
          child: CommonButton(buttonName: "Download Invoice", onTap: (){},verticalPadding: 3,fontWeight: FontWeight.normal));
    }else{
      getActionButton = SizedBox.shrink();
    }
    return Row(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CommonText(text:time,color: Colors.grey,fontSize: 13,)),
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
                        CommonText(text: message,),
                        getActionButton
                      ],
                    )
                ),



              ],
            ),

          ),
        )






      ],
    );
  }



}


