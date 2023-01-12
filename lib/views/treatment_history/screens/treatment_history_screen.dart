import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/configs/app_theme.dart';
import 'package:patient/controllers/my_visit_controller.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:patient/views/common/componants/common_topbar.dart';
import 'package:patient/views/common/components/modal_progress_hud.dart';
import 'package:patient/views/treatment_history/components/admitDetailsScreen.dart';
import 'package:patient/views/treatment_history/components/visit_filter_bottomsheet.dart';
import 'package:patient/views/treatment_history/screens/treatment_activity_detail_screen.dart';
import 'package:patient/views/treatment_history/screens/treatment_history_details_screen.dart';

import '../../../configs/constants.dart';
import '../../../configs/styles.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/text/text.dart';
import '../../common/componants/common_bold_text.dart';
import '../../common/components/filter_icon.dart';
import '../../common/components/loading_widget.dart';

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
  Future? getVisitData;

  bool isLoading = false;
  List<int> statusList = [];
  int? currentStatus;

  List<PropertyModels> propertiesModel = [
    PropertyModels(name: "abc", priority: 1),
    PropertyModels(name: "pqr", priority: 3),
    PropertyModels(name: "mno", priority: 2),
    PropertyModels(name: "xyz", priority: 2),
  ];

  VisitModel? visitModel;

  late PatientProvider patientProvider;
  late VisitProvider visitProvider;
  late MyVisitController visitController;
  String? patientId;

  Future<void> getData(String id,PatientProvider provider) async {

    if(id.isNotEmpty) {
      patientId = id;
      MyPrint.printOnConsole('Patient Id : $patientId');
       await visitController.getVisitListFromFirebase(patientId: patientId ?? '', isNotify: false);
    }
    
    if(provider.getCurrentPatient() != null) {
      if(provider.getCurrentPatient()!.createdTime != null) {
        int createdYear = provider.getCurrentPatient()!.createdTime!.toDate().year;
        int currentYear = DateTime.now().year;
        for(int i = createdYear; i <=currentYear ; i++){
          statusList.add(i);
        }
      }

    }else{
      int currentYear = DateTime.now().year;
      statusList.add(currentYear);
    }
    currentStatus = statusList.last;
  }



  Event buildEvent({Recurrence? recurrence}) {
    return Event(
      title: 'Test eventeee',
      description: 'example',
      location: 'Flutter app',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(minutes: 30)),
      allDay: false,
      iosParams: const IOSParams(
        reminder: const Duration(minutes: 40),
        url: "http://example.com",
      ),
      androidParams: const AndroidParams(
        emailInvites: ["test@example.com"],

      ),
      recurrence: recurrence,
    );
  }

  @override
  void initState() {
    super.initState();
    patientProvider = Provider.of<PatientProvider>(context, listen:  false);
    visitProvider = Provider.of<VisitProvider>(context, listen:  false);
    visitController = MyVisitController(visitProvider: visitProvider);
    getVisitData  =  getData(patientProvider.getCurrentPatient()?.id ?? "",patientProvider);
    //currentStatus = (statusList == null || statusList.isEmpty) ? null : statusList.first;
    //  getVisitData  =  getData("");
    MyPrint.printOnConsole('current status : $currentStatus');
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return FutureBuilder(
        future: getVisitData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      MyPrint.printOnConsole("Connection State:${snapshot.connectionState}");
      if(snapshot.connectionState == ConnectionState.done) {
         return SafeArea(
           child: Scaffold(
             body: Column(
               children: [
                 CommonTopBar(title: "History"),
                 Expanded(
                   child: Container(
                     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                     child: Column(
                       children: [
                         getHealthReportHeader(),
                         SizedBox(height: 20,),
                         Expanded(
                           child: ModalProgressHUD(
                             color: Colors.white,
                             opacity: 1,
                             inAsyncCall: isLoading,
                             progressIndicator: Container(
                                 child: LoadingWidget()),
                             child: Column(
                               children: [
                                 Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Expanded(child: getAnalysisContainer( visits:patientProvider.getCurrentPatient()?.totalVisits ?? 0),),
                                     SizedBox(width: 30,),
                                     Expanded(child: getAnalysisContainer(isTotalVisits: false,daysAdmitted: 05),),
                                   ],
                                 ),
                               SizedBox(height: 20,),
                               getVisitListHeader(),
                               SizedBox(height: 20,),
                               Expanded(child: getVisitsList()),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
      );
      }else {
        return Container(
          color: Styles.lightBackgroundColor,
          child: const Center(
            child: LoadingWidget(),
          ),
        );
      }
        }
    );
  }

  Widget getHistory(){
    return ListView(
      shrinkWrap: true,
      children: (patientProvider.getCurrentPatient() ?? PatientModel()).activeVisits.entries.map((e) {
        return Container(
          child: Text(e.key),
        );
      }).toList()
    );
  }

  Widget getHealthReportHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonBoldText(text: 'Health Report',fontSize:16),
        Expanded(flex: 2,child: Container(),),
        Expanded(child: TopBarDropDown()),
      ],
    );
  }

  Widget TopBarDropDown(){
    return   SizedBox(
       height: 30,
      //width: 90,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 1,color: Colors.black),),
        child: DropdownButton<int>(
          value: currentStatus,
          alignment: Alignment.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          dropdownColor: Colors.white,

          underline: Container(),iconEnabledColor: Colors.black,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_sharp,),
          borderRadius: BorderRadius.circular(4),
          items: statusList.map((int items) {
            return DropdownMenuItem(
              value: items,
              child: CommonText(text: '$items',),
            );
          }).toList(),
          onChanged: (int? val) async{
            // await changeStatus(currentStatus: val);
            if(currentStatus == val){return;}
            currentStatus = val!;
            setState(() {});
            if(currentStatus != null && patientId != null){

              visitProvider.setVisitByYear(currentStatus!);
              await visitController.getVisitListFromFirebase(patientId: patientId!, isNotify: false);
            }

            //Navigator.pop(context);

          },
        ),
      ),
    );
  }

  Widget getAnalysisContainer({bool isTotalVisits = true, int visits = 0,int daysAdmitted = 0}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
      decoration: BoxDecoration(
          color: isTotalVisits ? Styles.lightPrimaryColor : Styles.secondaryColor,
        borderRadius: BorderRadius.circular(12),

      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(isTotalVisits ? 'assets/icons/hospital.png':'assets/icons/bed.png',height: 22),
          SizedBox(height: 5,),
          CommonBoldText(text: isTotalVisits ? '$visits' : "$daysAdmitted",color: Colors.white,fontSize: 26),
          //SizedBox(height: 5,),
          CommonText(text: isTotalVisits ? 'Total Visits' : "Days Admitted",color: Colors.white,fontSize: 16),





        ],
      ),
    );
  }

  Widget getVisitsList(){
    String patientId = patientProvider.getCurrentPatient()?.id ?? "";
    if(patientId.isEmpty){
      return getNoVisitsCard();
    }
    return Consumer(
        builder: (BuildContext context,VisitProvider visitProvider,Widget? child){
          if(visitProvider.visitList.isEmpty){
            return getNoVisitsCard();
          }

          //List<NewsFeedModel> newsList = newsProvider.newsList;
          return ListView.builder(
            itemCount: visitProvider.visitList.length +1 ,
            shrinkWrap: true,
           // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              if((index == 0 && visitProvider.visitListLength == 0) || (index ==  visitProvider.visitListLength)){
                if(visitProvider.getIsVisitLoading){
                  return LoadingWidget();

                  //   Container(
                  //   margin: EdgeInsets.all(10),
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: AppColor.bgColor,
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  //   child: const Center(child: CircularProgressIndicator(color: AppColor.bgSideMenu)),
                  // );
                }else{
                  return SizedBox();
                }

              }

              if(visitProvider.getHasMoreVisits && index > (visitProvider.visitListLength - AppConstants.visitDocumentLimitForRefresh)) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  MyPrint.printOnConsole("Ye wali Method call");
                  visitController.getVisitListFromFirebase(patientId: patientId,isRefresh: false,isNotify: false);
                });
              }


              return getSingleVisitHistoryCard(visitProvider.visitList[index]);
            },
          );
        }
    );
  }

  Widget getSingleEvent({bool newVisit = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding:  const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
       // color: Styles.cardColor,
        color: Colors.red,
      ),
      child: Row(
        children: [
          Container(
            padding:  const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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

  Widget getVisitListHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonBoldText(text: 'Visits',fontSize:16),
        FilterIcon(
          onTap: (){
            showModalBottomSheet(
                context: context,
                builder: (context){
                  return VisitFilterBottomSheet();
                }
            );
          },
        )
      ],
    );
  }

  Widget getSingleVisitHistoryCard(VisitModel visitModel){
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,
              TreatmentHistoryDetailsScreen.routeName,
              arguments: {
                "visitModel" : visitModel,
              }
          );
        },
        child: Container(
          //margin: EdgeInsets.only(bottom: 10),
          //padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              getVisitCardMainDetails(visitModel),
              Divider(thickness: 0.2,color: Colors.grey,height: .2,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonBoldText(
                        text: '₹ ${visitModel.totalVisitAmount} ',
                      color: Colors.black,

                    ),
                    getInvoiceButton(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget getVisitCardMainDetails(VisitModel methodVisitModel){
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 28,
            child: Container(
             padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Styles.lightPrimaryColor.withOpacity(.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Image.asset('assets/icons/hospital.png',height: 22,color: Styles.lightPrimaryColor,),
                  SizedBox(height: 8,),
                  CommonBoldText(text: methodVisitModel.createdTime != null
                      ? DateFormat("dd MMM").format(methodVisitModel.createdTime!.toDate())
                      : "NA",
                      color: Styles.lightPrimaryColor,fontSize: 13,
                  ),
                ],

              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            flex: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/hospital_location.png',height:12),
                        SizedBox(width: 5,),
                        CommonBoldText(text: '${methodVisitModel.hospitalName}',fontSize: 11,),
                      ],
                    ),
                    Row(
                      children: [
                        CommonBoldText(text: '• ',fontSize:15),
                        CommonBoldText(text: methodVisitModel.previousVisitId.isNotEmpty ? 'Old Visit' : 'New Visit',
                          fontSize: 10,color: Styles.lightPrimaryColor,),
                      ],
                    )

                  ],
                ),
                SizedBox(height: 3,),
                getCustomTextColumn(primaryText: 'DISEASE',secondaryText: methodVisitModel.description),
                SizedBox(height: 8,),
                getCustomTextColumn(primaryText: 'DOCTOR',secondaryText: methodVisitModel.currentDoctorName),


              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getCustomTextColumn({required String primaryText,required String secondaryText}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CommonBoldText(text: primaryText,color: Styles.lightPrimaryColor,
        //   height: 1,fontSize: 10,maxLines: 1,textOverFlow: TextOverflow.ellipsis, ),
        Text(primaryText,style: AppTheme.getTextStyle(
          themeData.textTheme.headline5!,
          fontWeight: FontWeight.w800,
          height: 1,
          color: Styles.lightPrimaryColor,
          fontSize: 10
        ),),
        SizedBox(height: 2,),
        CommonText(text: secondaryText,color: Colors.black,fontSize: 13,
          height: 1,maxLines: 1,textOverFlow: TextOverflow.ellipsis, ),
      ],
    );
  }

  Widget getInvoiceButton(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
      decoration: BoxDecoration(
        color: Styles.lightPrimaryColor,
        borderRadius: BorderRadius.circular(25)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.download,color: Colors.white,size: 13),
          SizedBox(width: 5,),
          CommonBoldText(text: 'Invoice',color: Colors.white,fontSize: 14, ),
        ],
      ),
    );
  }

  Widget getNoVisitsCard(){
    return Column(
      children: [
        SizedBox(height:40 ,),
        Image.asset('assets/icons/empty_visits_card.png',height: 200),
        SizedBox(height:20 ,),
        CommonBoldText(text: "Woohoo !! You're Healthy",fontSize: 22,)
      ],
    );
  }









}

class PropertyModels{

  final String name;
  final int priority;
  TextEditingController? textEditingController = TextEditingController();

    PropertyModels({this.name = "", this.priority = 0, this.textEditingController});
}





/* Expanded(
                   child: isEvent?Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       ListView.builder(
                           itemCount: 4,
                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                           shrinkWrap: true,
                           itemBuilder: (context,index){
                             return InkWell(
                                 onTap: (){
                                   Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,TreatmentActivityDetailScreen.routeName);
                                 },
                                 child: getSingleEvent(newVisit: isNewVisit[index]));
                           }
                       )
                     ],
                   ):Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         CommonBoldText(text: "No Treatment History",fontSize: 20,color: Colors.black.withOpacity(.6)),
                       ]
                   ),
                 ),*/