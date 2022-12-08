import 'package:hms_models/hms_models.dart';
import 'package:patient/controllers/data_controller.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class MyPatientController {
  late PatientProvider _patientProvider;

  MyPatientController({PatientProvider? provider}) {
    _patientProvider = (provider ?? PatientProvider());
  }
  PatientProvider getProvider() => _patientProvider;

  Future<void> getPatientsDataForMainPage({bool isRefresh = true, bool isFromCache = false}) async {
    MyPrint.printOnConsole("getPatientsDataForMainPage called with isRefresh:$isRefresh and isFromCache:$isFromCache");

    AuthenticationProvider authenticationProvider = Provider.of(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    PatientProvider patientProvider = Provider.of(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(!isRefresh && isFromCache) {
      if(patientProvider.patientsLength > 0 && patientProvider.getCurrentPatient() != null) {
        MyPrint.printOnConsole("Data Already Exist");
        return;
      }
    }

    if(authenticationProvider.mobileNumber.isNotEmpty) {
      List<PatientModel> patients = await getPatientsForMobileNumber(mobileNumber: authenticationProvider.mobileNumber);
      if(patients.isEmpty) {
        PatientModel? patientModel = await createPatient(mobile: authenticationProvider.mobileNumber);

        if(patientModel != null) {
          patientProvider.addPatientModel(patientModel);
          patientProvider.setCurrentPatient(patientModel);
        }
        else {
          patientProvider.setCurrentPatient(null);
        }
      }
    }
  }

  Future<PatientModel?> createPatient({required String mobile}) async {
    NewDocumentDataModel newDocumentDataModel = await DataController().getNewDocIdAndTimeStamp();

    PatientModel patientModel = PatientModel(
      id: newDocumentDataModel.docId,
      createdTime: newDocumentDataModel.timestamp,
      active: false,
      primaryMobile: mobile,
      userMobiles: [mobile],
    );

    bool isPatientCreated = await FirestoreController.firestore.collection(FirebaseNodes.patientCollection).doc(patientModel.id).set(patientModel.toMap()).then((value) {
      return true;
    })
    .catchError((e, s) {
      MyPrint.printOnConsole("Error in Creating Patient Model:$e");
      MyPrint.printOnConsole(s);
      return false;
    });
    MyPrint.printOnConsole("isPatientCreated:$isPatientCreated");

    if(isPatientCreated) {
      return patientModel;
    }
    else {
      return null;
    }
  }

  Future<List<PatientModel>> getPatientsForMobileNumber({required String mobileNumber}) async {
    MyPrint.printOnConsole("getPatientsForMobileNumber called with mobile number: $mobileNumber");
    List<PatientModel> patients = [];

    PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController.firestore.collection(FirebaseNodes.patientCollection).where("userMobiles", arrayContainsAny: [mobileNumber]).get();
    MyPrint.printOnConsole("Patient Documents Length For Mobile Number '${mobileNumber}' :${querySnapshot.docs.length}");

    for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      if((documentSnapshot.data() ?? {}).isNotEmpty) {
        PatientModel patientModel = PatientModel.fromMap(documentSnapshot.data()!);
        patients.add(patientModel);
      }
    }
    patientProvider.setPatientModels(patients, isNotify: false);
    if(patients.isNotEmpty) {
      patientProvider.setCurrentPatient(patients.first, isNotify: false);
    }
    else {
      patientProvider.setCurrentPatient(null, isNotify: false);
    }

    return patients;
  }
}