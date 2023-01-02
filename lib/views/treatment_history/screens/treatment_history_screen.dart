import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/controllers/my_visit_controller.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/views/common/componants/common_topbar.dart';
import 'package:patient/views/treatment_history/components/admitDetailsScreen.dart';
import 'package:patient/views/treatment_history/screens/treatment_activity_detail_screen.dart';

import '../../../configs/styles.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../packages/flux/utils/spacing.dart';
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
  Future? getVisitData;

  List<PropertyModels> propertiesModel = [
    PropertyModels(name: "abc", priority: 1),
    PropertyModels(name: "pqr", priority: 3),
    PropertyModels(name: "mno", priority: 2),
    PropertyModels(name: "xyz", priority: 2),
  ];

  VisitModel visitModel = VisitModel();

  late PatientProvider provider;
  Future<void> getData(String ids) async {
    visitModel = await MyVisitController().getVisitModel(ids,isListen: false);
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
    provider = Provider.of<PatientProvider>(context, listen:  false);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return SafeArea(
         child: Column(
           children: [
             CommonTopBar(title: "Treatment History"),
             // const SizedBox(height : 1),
             // Expanded(child:getHistory()),
             Expanded(
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
             ),
           ],
         ),

    );
  }

  Widget getHistory(){
    return ListView(
      shrinkWrap: true,
      children: (provider.getCurrentPatient() ?? PatientModel()).activeVisits.entries.map((e) {
        return Container(
          child: Text(e.key),
        );
      }).toList()
    );
  }

  Widget getSingleEvent({bool newVisit = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:  const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Styles.cardColor,
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





}

class PropertyModels{

  final String name;
  final int priority;
  TextEditingController? textEditingController = TextEditingController();

    PropertyModels({this.name = "", this.priority = 0, this.textEditingController});
}
