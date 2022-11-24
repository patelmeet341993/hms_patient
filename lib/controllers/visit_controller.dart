import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient/configs/my_print.dart';
import 'package:patient/controllers/firestore_controller.dart';
import 'package:patient/models/visit_model/visit_model.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:patient/utils/parsing_helper.dart';
import 'package:provider/provider.dart';

import '../configs/app_strings.dart';
import '../models/patient_model.dart';
import '../utils/logger_service.dart';
import 'navigation_controller.dart';

class VisitController{

 late VisitProvider _visitProvider;

 VisitController({VisitProvider? visitProvider}){
  _visitProvider = (visitProvider ?? VisitProvider());
 }

 VisitProvider getProvider() => _visitProvider;

 Future<void> startTreatmentActivityStream() async {
  Log().e("in visit controller");
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
   Log().e("in visit controller22222");

   List<VisitModel> myStreamActiveVisits = [];


   VisitModel visitModel;
   Log().e("in visit controller3333");

   final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> querySnapshot = FirestoreController
       .firestore.collection(AppStrings.visitCollection)
       .where('patientId', isEqualTo: patientId)
       .where('isTreatmentActiveStream', isEqualTo: true)
       .snapshots().listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    Log().e("in visit controller44444");

    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
    documents.forEach((element) {
     visitModel = VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data()));
     visitProvider.setVisitModel(visitModel);

     MyPrint.printOnConsole("visit model: ${visitModel.pharmaBilling?.totalAmount}");
    });
   },onError: (error) {
        Log().e("error in stream subscription$error");
   });

   patientProvider.setStreamSubscription(querySnapshot);
  }
  catch (e,s){
   Log().e(e,s);
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

}