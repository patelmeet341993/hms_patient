import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hms_models/hms_models.dart';

class PatientProvider extends ChangeNotifier {
  PatientModel? _currentPatient;
  List<PatientModel> _patientModels = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _querySnapshot;
  VisitModel? _visitModel;

  PatientModel? getCurrentPatient() {
    if(_currentPatient != null) {
      return PatientModel.fromMap(_currentPatient!.toMap());
    }
    else {
      return null;
    }
  }

  void setCurrentPatient(PatientModel? patientModel, {bool isNotify = true}) {
    if(patientModel != null) {
      _currentPatient = PatientModel.fromMap(patientModel.toMap());
    }
    else {
      _currentPatient = null;
    }
    if(isNotify) {
      notifyListeners();
    }
  }

  List<PatientModel> getPatientModels() {
    return _patientModels.map((e) => PatientModel.fromMap(e.toMap())).toList();
  }

  void setPatientModels(List<PatientModel> patientModels, {bool isNotify = true}) {
    _patientModels = patientModels.map((e) => PatientModel.fromMap(e.toMap())).toList();
    if(isNotify) {
      notifyListeners();
    }
  }

  int get patientsLength => _patientModels.length;

  void addPatientModel(PatientModel patientModel, {bool isNotify = true, int index = -1}) {
    if(index > -1 && index <= _patientModels.length) {
      _patientModels.insert(index, PatientModel.fromMap(patientModel.toMap()));
    }
    else {
      _patientModels.add(PatientModel.fromMap(patientModel.toMap()));
    }
    if(isNotify) {
      notifyListeners();
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? get querySnapshot {
    if(_querySnapshot != null) {
      return _querySnapshot;
    }
    return null;
  }

  void setStreamSubscription(StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? querySnapshot,{bool isNotify = true}){
    if(querySnapshot != null){
      _querySnapshot = querySnapshot;
    }
    if(isNotify) {
      notifyListeners();
    }
  }

  void setVisitModel(VisitModel? visitModel , {bool isNotify = true}){
    if(visitModel != null){
      _visitModel = visitModel;
    }
    if(isNotify){
      notifyListeners();
    }
  }

  VisitModel? get visitModel {
    if(_visitModel != null){
      return _visitModel;
    } else {
      return null;
    }
  }

}