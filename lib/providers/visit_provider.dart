import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

class VisitProvider extends ChangeNotifier {
  final Map<String, VisitModel> _visitModelAccordingToId = {};
  final Map<String, StreamSubscription<QuerySnapshot<Map<String,dynamic>>>> _visitStreamSubscription = {};
  VisitModel? _visitModel;

  void setVisitModelAccordingToId(Map<String,VisitModel> visitModelAccordingToId, {bool isNotify = true}){
    if(visitModelAccordingToId.isNotEmpty){
      _visitModelAccordingToId.addAll(visitModelAccordingToId);
    }
    if(isNotify){
      notifyListeners();
    }
  }

  void setVisitStreamSubscription(Map<String,StreamSubscription<QuerySnapshot<Map<String,dynamic>>>> visitStreamSubscription, {bool isNotify = true}){
    if(visitStreamSubscription.isNotEmpty){
      _visitStreamSubscription.addAll(visitStreamSubscription);
    }
    if(isNotify){
      notifyListeners();
    }
  }

  // Map<String, VisitModel> get visitModelAccordingToId {
  //   if(_visitModelAccordingToId.isNotEmpty){
  //     return _visitModelAccordingToId;
  //   } else {
  //     return {};
  //   }
  // }

  Map<String, VisitModel> get visitModelAccordingToId => _visitModelAccordingToId;

  Map<String, StreamSubscription<QuerySnapshot<Map<String,dynamic>>>> get visitStreamSubscription {
    if(_visitStreamSubscription.isNotEmpty){
      return _visitStreamSubscription;
    } else {
      return {};
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


  //region pagination for treatment history

  List<VisitModel> _visitList = [];

  List<VisitModel> get visitList => _visitList;

  bool _visitLoading = false, _hasMoreVisit = false;

  DocumentSnapshot<Map<String, dynamic>>? _lastdocument;

  int _visitsByYear = 2023;

  int get visitsByYear => _visitsByYear;

  void setVisitByYear(int year,{bool isNotify = true}) {
    _visitsByYear = year;
    if(isNotify) {
      notifyListeners();
    }
  }

  void setVisitList(List<VisitModel> value,{bool isNotify = true}) {
    _visitList.clear();
    _visitList = value;
    if(isNotify) {
      notifyListeners();
    }
  }

  void addAllVisitList(List<VisitModel> value,{bool isNotify = true}) {
    _visitList.addAll(value);
    if(isNotify) {
      notifyListeners();
    }
  }

  int get visitListLength => _visitList.length;

  bool get getHasMoreVisits => _hasMoreVisit;
  set setHasMoreVisits(bool hasMoreVisit) => _hasMoreVisit = hasMoreVisit;

  DocumentSnapshot<Map<String, dynamic>>? get getLastDocument => _lastdocument;
  set setLastDocument(DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) => _lastdocument = documentSnapshot;

  bool get getIsVisitLoading => _visitLoading;
  void setIsVisitLoading(bool isVisitLoading, {bool isNotify = true}) {
    _visitLoading = isVisitLoading;
    if(isNotify) {
      notifyListeners();
    }
  }

  //endregion



}