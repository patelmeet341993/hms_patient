import 'package:flutter/material.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';

class VisitProvider extends ChangeNotifier {
  VisitModel? _visitModel;

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