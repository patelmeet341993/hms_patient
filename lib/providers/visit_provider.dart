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


}