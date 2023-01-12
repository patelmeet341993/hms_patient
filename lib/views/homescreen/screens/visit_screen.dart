import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:patient/views/admit_details/screens/admit_details_screen.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';
import 'package:patient/views/common/componants/common_button.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:patient/views/common/componants/qr_view_dialog.dart';
import 'package:patient/views/common/components/Treatment_timeline_log_master_widget.dart';
import 'package:patient/views/common/screens/notification_screen.dart';
import 'package:patient/views/homescreen/components/visit_treatment_activity_widget.dart';
import 'package:patient/views/treatment_history/screens/treatment_history_screen.dart';

import '../../../configs/styles.dart';
import '../../../controllers/my_visit_controller.dart';
import '../../../packages/flux/themes/text_style.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/container/container.dart';
import '../../../packages/flux/widgets/text_field/text_field.dart';
import '../../about_us/screens/about_us_screen.dart';
import '../../treatment_history/components/admitDetailsScreen.dart';

class VisitScreen extends StatefulWidget {
  final VisitProvider? visitProvider;
  const VisitScreen({Key? key, this.visitProvider}) : super(key: key);

  @override
  _VisitScreenState createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> with MySafeState {
  late ThemeData themeData;
  TextEditingController searchController =  TextEditingController();
  String userId = "123456";

  List<bool> invoiceList = [false, false, false, true,];
  List<bool> payList = [false, false, true, false,];

  late VisitProvider visitProvider;
  late MyVisitController visitController;
  VisitModel visitModel = VisitModel();
  late PatientProvider newPatientProvider;

  Future<void> getData() async{
    await visitController.startTreatmentActivityStream();
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    }
    else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  /*static String hhMM(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('HH:mm a').format(dateTime);
  }*/

  @override
  void initState() {
    super.initState();
    visitProvider = (widget.visitProvider ?? VisitProvider());
    visitController = MyVisitController(visitProvider: visitProvider);
    // getData();
  }

  /*@override
  void didUpdateWidget(covariant VisitScreen oldWidget) {
    if(oldWidget.nativeMenuModel.menuid != widget.nativeMenuModel.menuid) {
      nativeMenuModel = widget.nativeMenuModel;
      newHomeProvider = (widget.provider ?? NewHomeProvider());
      newHomeController = NewHomeController(provider: newHomeProvider);
      getData();
    }
    super.didUpdateWidget(oldWidget);
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return SafeArea(
      child: GestureDetector(
         onTap: (){
           FocusScope.of(context).requestFocus(FocusNode());
         },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Consumer2<PatientProvider, VisitProvider>(
            builder: (context, PatientProvider patientProvider, VisitProvider visitProvider, _) {
              visitModel = visitProvider.visitModel ?? VisitModel();
              newPatientProvider = patientProvider;
              PatientModel? patientModel = patientProvider.getCurrentPatient();
              userId = patientModel?.id ?? "";

              // return VisitTreatmentActivity(visitId: "65235a50657811ed879e93dbff774310", );
                return Column(
                children: [
                  const SizedBox(height: 10,),
                  getTopBar(isOpen: true,name: "Saraswati Clinic"),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        child: !(patientModel?.isProfileComplete ?? false)
                            ? getForUserFirstTime()
                            : getMainPage(),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget getTopBar({bool isOpen = true,required String name}) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                      const SizedBox(width: 5,),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(top: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: isOpen?Colors.green:Colors.grey),
                          ),
                          child: CommonBoldText(text: isOpen?'Open':"Closed", color: isOpen?Colors.green:Colors.grey,fontSize: 12,)
                        ),
                      const SizedBox(width: 5,),
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
                  child: const Icon(
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
                    color: themeData.primaryColor,
                    child: Container(),
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
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400,width: 6)
            ),
            child: QrImage(
              data: QRCodeDataModel(
                id: userId,
                type: QRCodeTypes.patient,
              ).toEncodedString(),
              version: QrVersions.auto,
              padding: EdgeInsets.zero,
              gapless: false,
              embeddedImageEmitsError: true,
              errorStateBuilder: (context,obj){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical:10),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FeatherIcons.alertOctagon),
                      const SizedBox(height:8),
                      CommonText(text: "Some Error in Generating QR \n Please Try again",textAlign: TextAlign.center),
                      const SizedBox(height:8),
                      CommonButton(
                        buttonName: "Try Again",
                        onTap: (){
                          setState(() {});
                        },
                        verticalPadding: 3,
                        fontWeight: FontWeight.normal,
                        borderRadius: 2,
                      )
                    ],
                  ),
                );
              },
              /*embeddedImage: const AssetImage('assets/extra/viren.jpg'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(80, 80),
              ),*/
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
          CommonText(text: "( Scan Your QR Code from Receptionist )"),
        ],
      ),
    );
  }

  Widget getMainPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        // getTextField(),
        // const SizedBox(height: 10,),
         Expanded(child: getMyTreatment(),
        ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
        const SizedBox(height: 10,),
        CommonBoldText(text: "Profile Overview",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9) ),
        const SizedBox(height: 12,),
        getProfileInfo(),
        const SizedBox(height: 20,),
        CommonBoldText(text: "Upcoming Dose",textAlign: TextAlign.start,fontSize: 14,color: Colors.black.withOpacity(.9)),
        const SizedBox(height: 5,),
        getNextDoseDetail(),
        const SizedBox(height: 20,),
        getAdmitContainer(),

        // VisitTreatmentActivity(visitId: "65235a50657811ed879e93dbff774310"),
        // Row(
        //   children: [
        //     CommonBoldText(text: "Current Treatment Activity",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9)),
        //     const SizedBox(width: 10,),
        //     Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 5),
        //         decoration: BoxDecoration(
        //           color: Styles.lightPrimaryColor.withOpacity(0.2),
        //           border: Border.all(color: Styles.lightPrimaryColor),
        //           borderRadius: BorderRadius.circular(5)
        //         ),
        //         child: CommonBoldText(text:DatePresentation.ddMMMMyyyyTimeStamp(visitModel.createdTime ?? Timestamp.now()),textAlign: TextAlign.start,fontSize: 12,color: Colors.black.withOpacity(.9))),
        //   ],
        // ),
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget getProfileInfo() {
    // PatientMetaModel patientMetaModel = visitModel.patientMetaModel ?? PatientMetaModel();
    PatientModel patientMetaModel = newPatientProvider.getCurrentPatient() ?? PatientModel();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                    return QRCodeView(
                      data: QRCodeDataModel(
                        id: userId,
                        type: QRCodeTypes.patient,
                      ).toEncodedString(),
                    );
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 2)
                    ),
                    child: QrImage(
                      data: QRCodeDataModel(
                        id: userId,
                        type: QRCodeTypes.patient,
                      ).toEncodedString(),
                      version: QrVersions.auto,
                      padding: EdgeInsets.zero,
                      gapless: false,
                      size: 80,
                      backgroundColor: Colors.white,
                      embeddedImageEmitsError: true,
                      errorStateBuilder: (context,obj){
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical:10),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FeatherIcons.alertOctagon),
                              const SizedBox(height:8),
                              CommonText(text: "Some Error in Generating Image Please Try again",textAlign: TextAlign.center),
                              const SizedBox(height:8),
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
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text: "${patientMetaModel.name}",color: Colors.white,fontSize: 17),
                    const SizedBox(height: 7,),
                    CommonText(text: "${patientMetaModel.gender}   ${calculateAge(patientMetaModel.dateOfBirth?.toDate() ?? DateTime.now())} years old",color: Colors.white,),
                    const SizedBox(height: 7,),
                    CommonText(text: DatePresentation.ddMMMMyyyyTimeStamp(patientMetaModel.dateOfBirth ?? Timestamp.now()),color: Colors.white,),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height:10),
          FxContainer(
            onTap: (){
              Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,TreatmentHistoryScreen.routeName);
            },
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadiusAll: 4,
            color: const Color(0xffe6e1e5).withAlpha(45),
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

  Widget getNextDoseDetail(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
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
              const SizedBox(width: 10,),
              CommonText(text: 'After Meal',fontSize: 14),
            ],
          ),
          CommonText(text: 'Instructions : Milk Consume Karna Goli lene ke baad',fontSize: 14),
        ],
      ),
    );
  }

  Widget getMyTreatment(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getProfileInfoBody(),


          getVisitTreatmentActivity(),
           VisitTreatmentActivity(visitId: "65235a50657811ed879e93dbff774310")
        ],
      ),
    );
  }

  Widget getVisitTreatmentActivity() {
    // VisitProvider visitProvider = Provider.of<VisitProvider>(context,listen: false);
    Map<String,Timestamp> activeVisits = newPatientProvider.getCurrentPatient()?.activeVisits ?? {};
    List<String> visitIds = activeVisits.keys.toList()..sort((a, b) => activeVisits[a]!.compareTo(activeVisits[b]!));
    // List<VisitModel> visitModels = visitProvider.visitModelAccordingToId.
    MyPrint.printOnConsole(visitIds);

    return Consumer<VisitProvider>(
      builder: (context, VisitProvider vp, _) {
        MyPrint.printOnConsole("visitProvider.visitModelAccordingToIds: ${vp.visitModelAccordingToId.keys}");
        MyPrint.printOnConsole("visitProvider.visitModelAccordingToId[visitIds[index]]: ${vp.visitModelAccordingToId}");
        // List<String> visitIds = activeVisits.keys.toList()..sort((a, b) => activeVisits[a]!.compareTo(activeVisits[b]!));
        // List<VisitModel> visitModels = vp.visitModelAccordingToId.values.toList();
        return  Column(
          mainAxisSize: MainAxisSize.min,
          // shrinkWrap: true,
          children: vp.visitModelAccordingToId.values.map((e) {
            MyPrint.printOnConsole("visitProvider.visitModelAccordingToId[visitIds[index]]: ${e.id}");
            return VisitTreatmentActivity(visitId: e.id, visitModel: e,);
          }).toList()

        );
        // VisitTreatmentActivity(visitModel: value)   ListView.builder(
        //   itemCount: vp.visitModelAccordingToId.length,
        //   physics: NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   itemBuilder: (BuildContext context, int index) {
        //     // if(index == 0){
        //     //   return getProfileInfoBody();
        //     // }
        //
        //     // index--;
        //     // final example = visitModel.treatmentActivity[index];
        //     return VisitTreatmentActivity(visitModel: vp.visitModelAccordingToId[visitIds[index]]);
        //   },
        // );
      }
    );
  }

  Widget getAdmitContainer(){
    return  InkWell(
      onTap: (){
       // Navigator.push(context, MaterialPageRoute(builder: (context) => AdmitDetailsScreen(visitModel: visitModel,)));

          Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,AdmitDetailsScreen.routeName);
      },
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: themeData.primaryColor),
          borderRadius: BorderRadius.circular(6),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bedroom_child_outlined,
              color: Colors.black,
              size: 20,
            ),
            FxSpacing.width(8),
            CommonText(text:'Admit Details',color:Colors.black,
              fontSize: 14,fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

}

class IndicatorExample extends StatelessWidget {
  const IndicatorExample({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 4,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class TimeLineRow extends StatelessWidget {
  final TreatmentActivityModel treatmentActivityModel;
  final VisitModel? visitModel;

  const TimeLineRow({Key? key, required this.treatmentActivityModel, this.visitModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            treatmentActivityModel.treatmentActivityStatus,
            softWrap: false,
            textWidthBasis: TextWidthBasis.parent,

          ),
          Visibility(
            visible: treatmentActivityModel.treatmentActivityStatus == TreatmentActivityStatus.assigned,
            child: Text(
              // "Doctor Name: ${visitModel?.visitBillings.values.first.doctorName ?? ""}",
              "Doctor Name: ${visitModel?.currentDoctorName ?? ""}",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(DatePresentation.hhMM(treatmentActivityModel.updatedTime ?? treatmentActivityModel.createdTime!),style: themeData.textTheme.bodySmall!.copyWith(height: 1,letterSpacing: 0.5,fontSize: 12))

        ],
      ),
      trailing: Visibility(
        visible: treatmentActivityModel.treatmentActivityStatus == TreatmentActivityStatus.completed,
        child:Container(
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
              color: themeData.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Report ",style: themeData.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w600,fontSize: 12,letterSpacing: 0.3,color: themeData.primaryColor),
              ),
              Icon(FontAwesomeIcons.fileInvoiceDollar,size: 13, color: themeData.primaryColor,)
            ],
          ),
        ),
      ),
      // subtitle: Visibility(
      //     visible: treatmentActivityModel.treatmentActivityStatus == TreatmentActivityStatus.registered,
      //     child: Text("Doctor Name: ${visitModel?.visitBillings.values.first.doctorName ?? ""}")),
      tileColor: Styles.cardColor,
      // collapsedBackgroundColor: Styles.cardColor,,
      // trailing: const Icon(
      //   Icons.navigate_next,
      //   color: Colors.black,
      //   size: 26,
      // ),
    );
     /* Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              treatmentActivityModel.treatmentActivityStatus,
            ),
          ),
          const Icon(
            Icons.navigate_next,
            color: Colors.black,
            size: 26,
          ),
        ],
      ),
    );*/
  }

  Widget expansionTile(context, TreatmentActivityModel treatmentActivityModel){
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: Styles.cardColor,
        collapsedBackgroundColor: Styles.cardColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 10,vertical:0 ),
        title: Text(treatmentActivityModel.treatmentActivityStatus),
        // subtitle: Text("Doctor Name: ${visitModel.visitBillings.values.first.doctorName}"),

        // children: [
        //   // getPrescriptionTable()
        // ],
      ),
    );
  }

}