import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient/configs/constants.dart';
import 'package:patient/controllers/data_controller.dart';
import 'package:patient/controllers/firestore_controller.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/models/new_document_data_model.dart';
import 'package:patient/models/patient_model.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/utils/logger_service.dart';
import 'package:provider/provider.dart';

class PatientController {
  Future<PatientModel?> createPatient({required String mobile}) async {
    NewDocumentDataModel newDocumentDataModel = await DataController().getNewDocIdAndTimeStamp();

    PatientModel patientModel = PatientModel(
      id: newDocumentDataModel.docid,
      createdTime: newDocumentDataModel.timestamp,
      active: false,
      userMobiles: [mobile],
    );

    bool isPatientCreated = await FirestoreController().firestore.collection(FirebaseNodes.patientCollection).doc(patientModel.id).set(patientModel.toMap()).then((value) {
      return true;
    })
    .catchError((e, s) {
      Log().e("Error in Creating Patient Model:$e", s);
      return false;
    });
    Log().i("isPatientCreated:$isPatientCreated");

    if(isPatientCreated) {
      return patientModel;
    }
    else {
      return null;
    }
  }

  Future<List<PatientModel>> getPatientsForMobileNumber({required String mobileNumber}) async {
    Log().d("getPatientsForMobileNumber called with mobile number: $mobileNumber");
    List<PatientModel> patients = [];

    PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.patientCollection).where("userMobiles", arrayContainsAny: [mobileNumber]).get();
    Log().i("Patient Documents Length For Mobile Number '${mobileNumber}' :${querySnapshot.docs.length}");

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