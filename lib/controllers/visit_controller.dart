import 'dart:async';

import 'package:hms_models/hms_models.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:provider/provider.dart';

import 'navigation_controller.dart';

class VisitController{

  late VisitProvider _visitProvider;

  VisitController({VisitProvider? visitProvider}){
    _visitProvider = (visitProvider ?? VisitProvider());
  }

  VisitProvider getProvider() => _visitProvider;

  Future<void> startTreatmentActivityStream() async {
    MyPrint.printOnConsole("in visit controller");
    try {
      PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      VisitProvider visitProvider = getProvider();
      String patientId = "";
      PatientModel? patientModel = patientProvider.getCurrentPatient();
      if (patientModel != null) {
        patientId = patientModel.id;
      }
      if (patientId.isEmpty) {
        return;
      }
      MyPrint.printOnConsole("in visit controller22222");
      VisitModel visitModel;
      MyPrint.printOnConsole("in visit controller3333");

      final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> querySnapshot = FirebaseNodes.visitsCollectionReference
          .where('patientId', isEqualTo: patientId)
          .where('isTreatmentActiveStream', isEqualTo: true)
          .snapshots().listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
            MyPrint.printOnConsole("in visit controller44444");

            List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
            documents.forEach((element) {
              visitModel = VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data()));
              visitProvider.setVisitModel(visitModel);

              MyPrint.printOnConsole("visit model: ${visitModel.pharmaBilling?.totalAmount}");
            });
          },
          onError: (error) {
            MyPrint.printOnConsole("error in stream subscription$error");
          });

   patientProvider.setStreamSubscription(querySnapshot);
  }
  catch (e,s){
   MyPrint.printOnConsole(e);
   MyPrint.printOnConsole(s);
  }
  // querySnapshot.forEach((element) {
  //  element.docChanges.forEach((element) {
  //   myStreamActiveVisits.add(VisitModel.fromMap(ParsingHelper.parseMapMethod<dynamic,dynamic,String,dynamic>(element.doc.data())));
  //  });
  // });
  // querySnapshot.listen((querySnapshot) {
  //  querySnapshot.docChanges.forEach((element) {
  //     myStreamActiveVisits.add(VisitModel.fromMap(ParsingHelper.parseMapMethod<dynamic,dynamic,String,dynamic>(element.doc.data())));
  //  });
  // });

 }
 Future<void> closeSteamSubscription() async {
  try {
   PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
   patientProvider.closeStreamSubscription(patientProvider.querySnapshot);
  } catch (e,s){
   MyPrint.printOnConsole("Error in closing the stream subscription: ${e}");
   MyPrint.printOnConsole(s);
  }
 }

}