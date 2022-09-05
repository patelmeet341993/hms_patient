import 'package:flutter/foundation.dart';
import 'package:patient/models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  PatientModel? _patientModel;

  PatientModel? getPatientModel() {
    if(_patientModel != null) {
      return PatientModel.fromMap(_patientModel!.toMap());
    }
    else {
      return null;
    }
  }

  void setPatientModel(PatientModel? patientModel, {bool isNotify = true}) {
    if(patientModel != null) {
      if(_patientModel != null) {
        _patientModel!.updateFromMap(patientModel.toMap());
      }
      else {
        _patientModel = PatientModel.fromMap(patientModel.toMap());
      }
    }
    else {
      _patientModel = null;
    }
    if(isNotify) {
      notifyListeners();
    }
  }
}