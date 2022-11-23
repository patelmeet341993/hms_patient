import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient/controllers/firestore_controller.dart';
import 'package:patient/models/visit_model/visit_model.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/utils/parsing_helper.dart';
import 'package:provider/provider.dart';

import '../configs/app_strings.dart';
import '../models/patient_model.dart';
import 'navigation_controller.dart';

class VisitController{

 Future<void> startTreatmentActivityStream() async {
  
  
  PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
  String patientId = "";
  PatientModel? patientModel = patientProvider.getCurrentPatient();
  if(patientModel != null){
   patientId  =  patientModel.id;
  }
  if(patientId.isEmpty) { return; }

  List<VisitModel> myStreamActiveVisits = [];

  final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> querySnapshot = await FirestoreController.firestore.collection(AppStrings.patient)
      .where('patientId', isEqualTo: patientId)
      .where('isTreatmentActiveStream',isEqualTo: true).snapshots().listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
  });



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