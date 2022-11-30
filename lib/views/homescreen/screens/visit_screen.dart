import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hms_models/hms_models.dart';
import 'package:intl/intl.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';
import 'package:patient/views/common/componants/common_button.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:patient/views/common/componants/qr_view_dialog.dart';
import 'package:patient/views/common/screens/notification_screen.dart';
import 'package:patient/views/treatment_history/screens/treatment_history_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../configs/styles.dart';
import '../../../controllers/visit_controller.dart';
import '../../../packages/flux/themes/text_style.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/container/container.dart';
import '../../../packages/flux/widgets/text_field/text_field.dart';
import '../../about_us/screens/about_us_screen.dart';
import '../../treatment_history/componants/treatment_activity.dart';

class VisitScreen extends StatefulWidget {
  final VisitProvider? visitProvider;
  const VisitScreen({Key? key, this.visitProvider}) : super(key: key);

  @override
  _VisitScreenState createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> with MySafeState{
  late ThemeData themeData;
  bool isFirstTimeUser = false;
  TextEditingController searchController =  TextEditingController();
  String userId = "123456";

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

  List<bool> invoiceList = [false, false, false, true,];
  List<bool> payList = [false, false, true, false,];

  late VisitProvider visitProvider;
  late VisitController visitController;
  VisitModel visitModel = VisitModel();


  Future<void> getData() async{
    await visitController.startTreatmentActivityStream();
  }


  @override
  void initState() {
    super.initState();
    visitProvider = (widget.visitProvider ?? VisitProvider());
    visitController = VisitController(visitProvider: visitProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await getData();
    });
    // VisitController(visitProvider: visitProvider).startTreatmentActivityStream();
  }


  // @override
  // void didUpdateWidget(covariant VisitScreen oldWidget) {
  //   if(oldWidget.nativeMenuModel.menuid != widget.nativeMenuModel.menuid) {
  //     nativeMenuModel = widget.nativeMenuModel;
  //     newHomeProvider = (widget.provider ?? NewHomeProvider());
  //     newHomeController = NewHomeController(provider: newHomeProvider);
  //     getData();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }


  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

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
            resizeToAvoidBottomInset: false,
            body: Consumer<VisitProvider>(
              builder: (context, VisitProvider visitProvider, _) {
                visitModel = visitProvider.visitModel ?? VisitModel();
                return Column(
                  children: [
                    SizedBox(height: 10,),
                    getTopBar(isOpen: true,name: "Saraswati Clinic"),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,),
                          child: isFirstTimeUser?getForUserFirstTime():getMainPage()
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget getTopBar({bool isOpen = true,required String name}) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,AboutUsScreen.routeName);
                },
                child: Row(
                    children: [
                        Flexible(child: CommonBoldText(text: name,textAlign: TextAlign.start,fontSize: 20,textOverFlow: TextOverflow.ellipsis,maxLines: 3,)),
                      SizedBox(width: 5,),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 4).copyWith(top: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: isOpen?Colors.green:Colors.grey),
                          ),
                          child: CommonBoldText(text: isOpen?'Open':"Closed", color: isOpen?Colors.green:Colors.grey,fontSize: 12,)
                        ),
                      SizedBox(width: 5,),
                  ],
                ),
              )
          ),
          FxContainer(
            paddingAll: 7,
            borderRadiusAll: 4,
            color: Styles.cardColor,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                InkWell(
                  onTap:(){
                     Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,NotificationScreen.routeName);
                  },
                  child: Icon(
                    Icons.notifications,
                    size: 22,
                    color: Colors.grey,
                  ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400,width: 6)
            ),
            child: QrImage(
              data: userId,
              version: QrVersions.auto,
              padding: EdgeInsets.zero,
              gapless: false,
               embeddedImageEmitsError: true,
              errorStateBuilder: (context,obj){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical:10),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FeatherIcons.alertOctagon),
                      SizedBox(height:8),
                      CommonText(text: "Some Error in Generating QR \n Please Try again",textAlign: TextAlign.center),
                      SizedBox(height:8),
                      CommonButton(buttonName: "Try Again",
                        onTap: (){
                        setState(() {});
                        },
                        verticalPadding: 3,
                        fontWeight: FontWeight.normal,
                        borderRadius: 2,)
                    ],
                  ),
                );
              },
              embeddedImage: AssetImage('assets/extra/viren.jpg'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(80, 80),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 5,),
          CommonText(text: "( Scan Your QR Code from Receptionist )"),
        ],
      ),
    );
  }

  Widget getMainPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        getTextField(),
        SizedBox(height: 10,),
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

  Widget getProfileInfoBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        CommonBoldText(text: "Profile Overview",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9) ),
        SizedBox(height: 12,),
        getProfileInfo(),
        SizedBox(height: 20,),
        CommonBoldText(text: "Upcoming Dose",textAlign: TextAlign.start,fontSize: 14,color: Colors.black.withOpacity(.9)),
        SizedBox(height: 5,),
        getNextDoseDetail(),
        SizedBox(height: 20,),
        CommonBoldText(text: "Current Treatment Activity",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9)),
        SizedBox(height: 18,),
      ],
    );
  }

  Widget getProfileInfo() {
    PatientMetaModel patientMetaModel = visitModel.patientMetaModel ?? PatientMetaModel();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        color: themeData.primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  showDialog(context: context, builder: (context){
                    return QRCodeView(userId: userId,);
                  });
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 2)
                      ),
                      child: QrImage(
                        data: userId,
                        version: QrVersions.auto,
                        padding: EdgeInsets.zero,
                        gapless: false,
                        size: 80,
                        backgroundColor: Colors.white,
                        embeddedImageEmitsError: true,
                        errorStateBuilder: (context,obj){
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical:10),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FeatherIcons.alertOctagon),
                                SizedBox(height:8),
                                CommonText(text: "Some Error in Generating Image Please Try again",textAlign: TextAlign.center),
                                SizedBox(height:8),
                                CommonButton(buttonName: "Try Again",
                                  onTap: (){
                                     setState(() {});
                                  },
                                  verticalPadding: 3,
                                  fontWeight: FontWeight.normal,
                                  borderRadius: 2,)
                              ],
                            ),
                          );
                        },
                        //embeddedImage: AssetImage('assets/extra/viren.jpg'),
                        //embeddedImageStyle: QrEmbeddedImageStyle(
                        //size: Size(28, 28)
                        //),
                      ),
                    ),
                  //  Image.asset("assets/extra/code.png",height: 80,width: 80,fit: BoxFit.cover,)
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text: "${visitProvider.visitModel?.patientMetaModel?.name}",color: Colors.white,fontSize: 17),
                    SizedBox(height: 2,),
                    CommonText(text: "${patientMetaModel.gender}   ${calculateAge(patientMetaModel.dateOfBirth?.toDate() ?? DateTime.now())} years old",color: Colors.white,),
                    SizedBox(height: 2,),
                    CommonText(text: DatePresentation.ddMMMMyyyy(patientMetaModel.dateOfBirth?.toDate()?? DateTime.now()),color: Colors.white,),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height:10),
          FxContainer(
            onTap: (){
              Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,TreatmentHistoryScreen.routeName);
            },
            padding: EdgeInsets.symmetric(vertical: 12),
            borderRadiusAll: 4,
            color: Color(0xffe6e1e5).withAlpha(45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.watch_later,
                  color: Colors.white.withAlpha(160),
                  size: 20,
                ),
                FxSpacing.width(8),
                CommonText(text:'Treatment History',color:Colors.white,
                  fontSize: 14,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getMyTreatment() {
    List<TreatmentActivityModel> treatMentList = visitModel.treatmentActivity;
    return ListView.builder(
      itemCount: treatMentList.length + 1,
      shrinkWrap: true,
      itemBuilder: (context,index){
        if(index == 0){
          return getProfileInfoBody();
        }
        index--;
        return TreatmentActivityScreen(
          time: hhMM(treatMentList[index].createdTime ?? Timestamp.now()),
          message:  treatMentList[index].treatmentActivityStatus ,
          isButtonVisible: index == 2 || index == 3 ? true:false,
          buttonName: index == 2 ? "Download Invoice" : index == 3 ? "Pay Now" : "",
        );
      }
    );
  }

  Widget getNextDoseDetail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeData.primaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonBoldText(text: 'Tablet',fontSize: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CommonText(text: 'Paracetamol : 1 dose',fontSize: 14)),
              SizedBox(width: 10,),
              CommonText(text: 'After Meal',fontSize: 14),
            ],
          ),
          CommonText(text: 'Instructions : Milk Consume Karna Goli lene ke baad',fontSize: 14),
        ],
      ),
    );
  }

  static String hhMM(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('HH:mm a').format(dateTime);
  }


}


