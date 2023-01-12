import 'dart:async';

import 'package:hms_models/hms_models.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';

import '../configs/constants.dart';
import 'navigation_controller.dart';

class MyVisitController {
  late VisitProvider _visitProvider;

  MyVisitController({required VisitProvider visitProvider}){
    _visitProvider = (visitProvider);
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

      patientProvider.setStreamSubscription(querySnapshot, isNotify: false);
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

  Future<VisitModel> getVisitModel(String id,{bool isListen = false}) async {
    MyPrint.printOnConsole("MyVisitController().getVisitModel() called for Visit:$id");

    // VisitModel visitModel = VisitModel();
    MyPrint.printOnConsole("getVisitModel: $id");
    MyPrint.printOnConsole("1");

    try{
      VisitProvider visitProvider = getProvider();
      // PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

      if(isListen){
        VisitModel visitModel = VisitModel();
        MyPrint.printOnConsole("2");

        StreamSubscription<QuerySnapshot<Map<String, dynamic>>> querySnapshot = FirebaseNodes.visitsCollectionReference
              .where('id', isEqualTo: id)
              .where('isTreatmentActiveStream', isEqualTo: true)
              .snapshots().listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {

                List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
                Map<String, VisitModel> visitMap = {};
                documents.forEach((element) {
                     visitModel = VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data()));
                     visitMap = {id:VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data()))};
                     MyPrint.printOnConsole(visitMap);

                     // visitMap.addAll({id:VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data()))});
                     MyPrint.printOnConsole("3");
                });
                visitProvider.setVisitModelAccordingToId(Map.castFrom(visitMap));
            },
            onError: (error) {
              MyPrint.printOnConsole("error in stream subscription$error");
            });

        Map<String, StreamSubscription<QuerySnapshot<Map<String,dynamic>>>> visitStream = {id:querySnapshot};
        visitProvider.setVisitStreamSubscription(visitStream);

        // print(visitModel:)
        // patientProvider.setStreamSubscription(querySnapshot, isNotify: false);
        return visitModel;
      }
      else {
        VisitModel visitModel = VisitModel();

        DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await FirebaseNodes.visitsCollectionReference.doc(id).get();
        if(documentSnapshot.exists){
          Map<String,dynamic> data = documentSnapshot.data() ?? {};
          MyPrint.printOnConsole(data);
          visitModel = VisitModel.fromMap(ParsingHelper.parseMapMethod(documentSnapshot.data()));
          visitProvider.setVisitModel(visitModel);
        }
        MyPrint.printOnConsole(visitModel.id);
        return visitModel;
      }

    }
    catch(e,s){
      MyPrint.printOnConsole("Error in getting visit model: $e");
      MyPrint.printOnConsole(s);
      return VisitModel();
    }
  }

  Future<void> closeSteamSubscription() async {
    try {
      PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      patientProvider.closeStreamSubscription(patientProvider.querySnapshot);
    }
    catch (e,s){
      MyPrint.printOnConsole("Error in closing the stream subscription: ${e}");
      MyPrint.printOnConsole(s);
    }
  }


  Future<void> getVisitListFromFirebase({required String patientId,bool isRefresh = true,bool isNotify = true}) async{

    VisitProvider paginationVisitProvider = getProvider();

    try{
      MyPrint.printOnConsole("Inside the Method");

      if(!isRefresh && paginationVisitProvider.visitListLength > 0) {
        MyPrint.printOnConsole("Returning Cached Data");
        paginationVisitProvider.visitList;
      }

      if (isRefresh) {
        MyPrint.printOnConsole("Refresh");
        paginationVisitProvider.setHasMoreVisits = true; // flag for more products available or not
        paginationVisitProvider.setLastDocument = null; // flag for last document from where next 10 records to be fetched
        paginationVisitProvider.setIsVisitLoading(false, isNotify: isNotify);
        paginationVisitProvider.setVisitList([], isNotify: isNotify);
      }

      if (!paginationVisitProvider.getHasMoreVisits) {
        MyPrint.printOnConsole('No More Visits');
        return;
      }
      if (paginationVisitProvider.getIsVisitLoading)  return;

      paginationVisitProvider.setIsVisitLoading(true, isNotify: isNotify);

      Timestamp startTime = Timestamp.fromDate(DateTime(_visitProvider.visitsByYear, 1,0,0,0,0,0,0));
      Timestamp endTime = Timestamp.fromDate(DateTime(_visitProvider.visitsByYear, 12,31,23,59,59,0,0));

      Query<Map<String, dynamic>> query = FirebaseNodes.visitsCollectionReference
          .limit(AppConstants.visitDocumentLimitForPagination)
          .where('patientId',isEqualTo: patientId.trim())
          .where('createdTime',isGreaterThanOrEqualTo:startTime )
          .where('createdTime',isLessThanOrEqualTo:endTime )
          .orderBy("createdTime", descending: true);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = paginationVisitProvider.getLastDocument;
      if(snapshot != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      }
      else {
        MyPrint.printOnConsole("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Documents Length in Firestore for Admin Users:${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < AppConstants.visitDocumentLimitForPagination) paginationVisitProvider.setHasMoreVisits = false;

      if(querySnapshot.docs.isNotEmpty) paginationVisitProvider.setLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      List<VisitModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if((documentSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel newsModel = VisitModel.fromMap(documentSnapshot.data()!);
          list.add(newsModel);
        }
      }
      paginationVisitProvider.addAllVisitList(list, isNotify: false);
      paginationVisitProvider.setIsVisitLoading(false);
      MyPrint.printOnConsole("Final Visit Length From Firestore:${list.length}");
      MyPrint.printOnConsole("Final Visit Length in Provider:${paginationVisitProvider.visitListLength}");



    }catch(e,s){
      MyPrint.printOnConsole("Error in get Visit List form Firebase in visit Controller $e");
      MyPrint.printOnConsole(s);
    }
  }


}