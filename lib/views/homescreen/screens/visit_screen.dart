import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hms_models/hms_models.dart';
import 'package:intl/intl.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';
import 'package:patient/views/common/componants/common_button.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:patient/views/common/componants/qr_view_dialog.dart';
import 'package:patient/views/common/screens/notification_screen.dart';
import 'package:patient/views/treatment_history/screens/treatment_history_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../configs/styles.dart';
import '../../../controllers/visit_controller.dart';
import '../../../packages/flux/themes/text_style.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/container/container.dart';
import '../../../packages/flux/widgets/text_field/text_field.dart';
import '../../about_us/screens/about_us_screen.dart';
import '../../treatment_history/componants/showCaseTimeline.dart';
import '../../treatment_history/componants/treatment_activity.dart';

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

  static String hhMM(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('HH:mm a').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    visitProvider = (widget.visitProvider ?? VisitProvider());
    visitController = VisitController(visitProvider: visitProvider);
    getData();
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
    return Container(
      color: themeData.backgroundColor,
      child: SafeArea(
        child: GestureDetector(
           onTap: (){
             FocusScope.of(context).requestFocus(FocusNode());
           },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Consumer2<PatientProvider, VisitProvider>(
              builder: (context, PatientProvider patientProvider, VisitProvider visitProvider, _) {
                visitModel = visitProvider.visitModel ?? VisitModel();
                PatientModel? patientModel = patientProvider.getCurrentPatient();
                userId = patientModel?.id ?? "";

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
        getTextField(),
        const SizedBox(height: 10,),
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
        CommonBoldText(text: "Current Treatment Activity",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9)),
        const SizedBox(height: 18,),
      ],
    );
  }

  Widget getProfileInfo() {
    PatientMetaModel patientMetaModel = visitModel.patientMetaModel ?? PatientMetaModel();
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
                    CommonText(text: "${visitProvider.visitModel?.patientMetaModel?.name}",color: Colors.white,fontSize: 17),
                    const SizedBox(height: 2,),
                    CommonText(text: "${patientMetaModel.gender}   ${calculateAge(patientMetaModel.dateOfBirth?.toDate() ?? DateTime.now())} years old",color: Colors.white,),
                    const SizedBox(height: 2,),
                    CommonText(text: DatePresentation.ddMMMMyyyyTimeStamp(patientMetaModel.dateOfBirth?? Timestamp.now()),color: Colors.white,),
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

  Widget getMyTreatment() {
    List<TreatmentActivityModel> treatMentList = visitModel.treatmentActivity;
    return ListView.builder(
      itemCount: visitModel.treatmentActivity.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if(index == 0){
          return getProfileInfoBody();
        }
        index--;
        final example = visitModel.treatmentActivity[index];

        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == visitModel.treatmentActivity.length - 1,
          // afterLineStyle: LineStyle(thickness: 1),
          indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            indicator: IndicatorExample(number: '${index + 1}'),

            drawGap: true,
            // indicatorXY: 0.1

          ),
          beforeLineStyle: LineStyle(
            color: Colors.grey.withOpacity(0.2),
          ),
          endChild: GestureDetector(
            child: RowExample(treatmentActivityModel: example,),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute<ShowcaseTimeline>(
              //     builder: (_) =>
              //         ShowcaseTimeline(example: example),
              //   ),
              // );
            },
          ),
        );
      },
    );
    return ListView.builder(
      itemCount: treatMentList.length + 1,
      shrinkWrap: true,
      itemBuilder: (context,index){
        if(index == 0){
          return getProfileInfoBody();
        }
        index--;
        // if(treatMentList[index].treatmentActivityStatus == TreatmentActivityStatus.prescribed){
        //   return prescribtionExpansionTile();
        // }
        return TimelineTile(
          alignment: TimelineAlign.start,
          isFirst: index == 0,
          isLast: index == treatMentList.length - 1,
          // lineXY: 0.9,
          endChild: Container(
            child: Text("hello"),
          ),
        );
        return TreatmentActivityScreen(
          visitModel: visitModel,
          prescribeWidget: prescriptionExpansionTile(),
          time: hhMM(treatMentList[index].createdTime ?? Timestamp.now()),
          message:  treatMentList[index].treatmentActivityStatus ,
          buttonOnTap: () async {
            if( treatMentList[index].treatmentActivityStatus == TreatmentActivityStatus.completed){
              await visitController.closeSteamSubscription();
              MyPrint.printOnConsole("in downlaod invoice");
            }
          },
          isButtonVisible: index == 2 || index == 3 ? true:false,
          buttonName: treatMentList[index].treatmentActivityStatus == TreatmentActivityStatus.billPay
              ? "Pay Now"
              : treatMentList[index].treatmentActivityStatus == TreatmentActivityStatus.completed
                  ? "Download Invoice"
                  : "",
        );
      }
    );
  }

  IndicatorStyle _indicatorStyleCheckpoint(Step step) {
    return IndicatorStyle(
      width: 46,
      height: 100,
      indicator: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.home,
            color: const Color(0xFF1D1E20),
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget prescriptionExpansionTile(){
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Styles.cardColor,

            collapsedBackgroundColor: Styles.cardColor,
            tilePadding: EdgeInsets.symmetric(horizontal: 10,vertical:0 ),

            title: Text("Prescribed"),
            subtitle: Text("Doctor Name: ${visitModel.visitBillings.values.first.doctorName ?? ""}"),

            children: [
              getPrescriptionTable()
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            color: Styles.cardColor,
            //color: themeData.primaryColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Doctor consultancy fee", style: Theme.of(context).textTheme.bodySmall,),
                  RichText(
                      text: TextSpan(
                        text: visitModel.visitBillings.values.first.totalFees.toString(),
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, decoration: TextDecoration.lineThrough,color: Colors.black),
                        children: [
                          TextSpan(
                            text: " ${visitModel.visitBillings.values.first.discount}",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15,decoration: TextDecoration.none),
                          )
                        ]
                      ))
                ],
              )),
              CommonButton(verticalPadding:2, buttonName: "Cash", onTap: (){}),
              SizedBox(width: 10,),
              CommonButton(verticalPadding: 2,buttonName: "Online", onTap: (){}),
            ],
          ),

        ),
      ],
    );
  }

  Widget getPrescriptionTable(){

    // MyPrint.printOnConsole("Dasshboard screen ${visitProvider.getPharmaBillingModel!.items}");

    return DataTable(
        headingRowHeight: 30,
        headingRowColor: MaterialStateProperty.resolveWith(
              (states) => themeData.primaryColor.withOpacity(0.3),),
        columns: [
          DataColumn(label:getColumnItem("Medicine")),
          DataColumn(label:getColumnItem("Dose")),
          // DataColumn(label:getColumnItem("Time")),
          DataColumn(label:getColumnItem("Dose count")),
          // DataColumn(label:getColumnItem("Instruction")),
          // DataColumn(label:getColumnItem("Mrp")),
          // DataColumn(label:getColumnItem("Total amount")),
          // DataColumn(label:Center(child:Text("Quantity",style: themeData.textTheme.bodyText1,))),
          // DataColumn(label:Center(child:Text("Instruction",style: themeData.textTheme.bodyText1,))),
          // DataColumn(label:Center(child:Text("Amount",style: themeData.textTheme.bodyText1,))),
          // DataColumn(label:Center(child:Text("Total amount",style: themeData.textTheme.bodyText1,))),
        ],
        rows: List.generate(visitModel.diagnosis.length, (index) {
          PrescriptionModel prescriptionModel = visitModel.diagnosis[index].prescription[index];
          // amountTextEditingControllers.add(TextEditingController());
          return getDataRow(prescriptionModel: prescriptionModel,index: index);
        })


      // (visitProvider.getPharmaBillingModel ?? PharmaBillingModel()).items.map((e) {
      //   amountTextEditingControllers.add(TextEditingController());
      //   return getDataRow(name: e.medicineName,description: "3 nos", quantity: 3, time: "Afternoon,Evening", instruction: "take only when have fever",totalAmount: 26.4,controller: mobileControlller,amountController: amountTextEditingControllers);
      // }).toList()
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


  DataRow getDataRow({ required PrescriptionModel prescriptionModel,int index = 0}){
    // controller.text = quantity.toString();
    return DataRow(
        cells: [
          getDataCell(prescriptionModel.medicineName,),
          getDataCell(prescriptionModel.doses[index].dose,),
          // getDataCell(pharmaBillingItemModel.dosePerUnit),
          getDataCell(prescriptionModel.doses[index].doseCount.toString()),
          // getDataCell(getEditableContent()),
          // getDataCell(prescriptionModel.dosePerUnit,),
          // getDataCell(prescriptionModel.price.toString()),
          // getEditableContent(amountController,(String? val){
          //   pharmaBillingItemModel.finalAmount = calculateTotalAmount(quantityController.text.isEmpty ? "0":quantityController.text,amountController.text.isEmpty?"0":amountController.text);
          //   pharmaBillingItemModel.price = ParsingHelper.parseDoubleMethod(amountController.text.trim());
          //   pharmaBillingItemModel.discount = individualDiscount(pharmaBillingItemModel.finalAmount);
          //   setState(() {});
          //   getTotalAmount();
          // }),
          // getDataCell(prescriptionModel.finalAmount.toString()),
        ]
    );
  }

  Widget getColumnItem(String text){
    return Expanded(child:Center(child: Text(text,style: themeData.textTheme.bodySmall,)));
  }

  DataCell getDataCell(String text){
    return  DataCell(Center(
      child: Text(text,
        style: themeData.textTheme.bodySmall,
        overflow: TextOverflow.visible,
        softWrap: true,),
    ),);
  }

  DataCell getEditableContent(String text){
    return DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
    ));
  }


  // static String hhMM(Timestamp timeStamp) {
  //   DateTime dateTime = timeStamp.toDate();
  //   return DateFormat('HH:mm a').format(dateTime);
  // }

}


