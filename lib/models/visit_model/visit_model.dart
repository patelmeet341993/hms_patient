import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient/models/visit_model/patient_meta_model.dart';
import 'package:patient/models/visit_model/treatment_activity/treatment_activity_model.dart';
import '../../utils/parsing_helper.dart';
import 'diagnosis and prescription/diagnosis_model.dart';
import 'diagnosis and prescription/vitals_model.dart';
import 'pharma_billings/pharma_billing_model.dart';
import 'visit_billings/visit_billing_model.dart';

class VisitModel {
  String id = "", patientId = "", currentDoctor = "", previousVisitId = "";
  Map<String, String> doctors = {};
  Timestamp? createdTime, updatedTime, completedTime;
  double weight = 0;
  VitalsModel? vitals;
  bool active = false,isPrescribed = false,isTreatmentActiveStream = false;
  List<DiagnosisModel> diagnosis = <DiagnosisModel>[];
  Map<String, VisitBillingModel> visitBillings = {};
  PharmaBillingModel? pharmaBilling;
  PatientMetaModel? patientMetaModel;
  List<TreatmentActivityModel> treatmentActivity = <TreatmentActivityModel>[];
  List<TreatmentActivityModel> treatmentActivityDetailedLog = <TreatmentActivityModel>[];

  VisitModel({
    this.id = "",
    this.patientId = "",
    this.currentDoctor = "",
    this.previousVisitId = "",
    this.doctors = const <String, String>{},
    this.createdTime,
    this.updatedTime,
    this.completedTime,
    this.weight = 0,
    this.active = false,
    this.isPrescribed = false,
    this.isTreatmentActiveStream = false,
    this.vitals,
    this.diagnosis = const <DiagnosisModel>[],
    this.visitBillings = const <String, VisitBillingModel>{},
    this.pharmaBilling,
    this.patientMetaModel,
    this.treatmentActivity = const <TreatmentActivityModel>[],
    this.treatmentActivityDetailedLog = const <TreatmentActivityModel>[]
  });

  VisitModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    patientId = ParsingHelper.parseStringMethod(map['patientId']);
    currentDoctor = ParsingHelper.parseStringMethod(map['currentDoctor']);
    previousVisitId = ParsingHelper.parseStringMethod(map['previousVisitId']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    updatedTime = ParsingHelper.parseTimestampMethod(map['updatedTime']);
    completedTime = ParsingHelper.parseTimestampMethod(map['completedTime']);
    weight = ParsingHelper.parseDoubleMethod(map['weight']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    isPrescribed = ParsingHelper.parseBoolMethod(map['isPrescribed']);
    isTreatmentActiveStream = ParsingHelper.parseBoolMethod(map['isTreatmentActiveStream']);

    List<DiagnosisModel> diagnosisList = <DiagnosisModel>[];
    List<Map> diagnosisMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['diagnosis']);
    for (Map diagnosisMap in diagnosisMapList) {
      Map<String, dynamic> newDiagnosisMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(diagnosisMap);
      if(newDiagnosisMap.isNotEmpty) {
        DiagnosisModel visitDiagnosisModel = DiagnosisModel.fromMap(newDiagnosisMap);
        diagnosisList.add(visitDiagnosisModel);
      }
    }
    diagnosis = diagnosisList;

    List<TreatmentActivityModel> treatmentModelList = <TreatmentActivityModel>[];

    List<Map> treatmentModelMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['treatmentActivity']);
    for (Map treatmentActivityMap in treatmentModelMapList) {
      Map<String, dynamic> newTreatmentMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(treatmentActivityMap);
      if(newTreatmentMap.isNotEmpty) {
        TreatmentActivityModel visitTreatmentModel = TreatmentActivityModel.fromMap(newTreatmentMap);
        treatmentModelList.add(visitTreatmentModel);
      }
    }
    treatmentActivity = treatmentModelList;

    List<TreatmentActivityModel> treatmentModelLogList = <TreatmentActivityModel>[];
    List<Map> treatmentModelLogMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['treatmentActivity']);
    for (Map treatmentActivityLogMap in treatmentModelLogMapList) {
      Map<String, dynamic> newTreatmentLogMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(treatmentActivityLogMap);
      if(newTreatmentLogMap.isNotEmpty) {
        TreatmentActivityModel visitTreatmentModel = TreatmentActivityModel.fromMap(newTreatmentLogMap);
        treatmentModelLogList.add(visitTreatmentModel);
      }
    }
    treatmentActivityDetailedLog = treatmentModelLogList;

    Map<String, VisitBillingModel> finalVisitBillingsMap = <String, VisitBillingModel>{};
    Map<String, dynamic> visitBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['visitBillings']);
    if(visitBillingsMap.isNotEmpty) {
      visitBillingsMap.forEach((String doctorId, dynamic value) {
        Map<String, dynamic> visitBillingMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(value);
        if(visitBillingMap.isNotEmpty) {
          VisitBillingModel visitBillingModel = VisitBillingModel.fromMap(visitBillingMap);
          finalVisitBillingsMap[doctorId] = visitBillingModel;
        }
      });
    }
    visitBillings = finalVisitBillingsMap;

    Map<String, dynamic> pharmaBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['pharmaBilling']);
    if(pharmaBillingsMap.isNotEmpty) {
      pharmaBilling = PharmaBillingModel.fromMap(pharmaBillingsMap);
    }

    Map<String, dynamic> vitalsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['vitals']);
    if(pharmaBillingsMap.isNotEmpty) {
      vitals = VitalsModel.fromMap(vitalsMap);
    }

    Map<String, dynamic> patientmetaMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['patientMetaModel']);
    if(pharmaBillingsMap.isNotEmpty) {
      patientMetaModel = PatientMetaModel.fromMap(patientmetaMap);
    }
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    patientId = ParsingHelper.parseStringMethod(map['patientId']);
    currentDoctor = ParsingHelper.parseStringMethod(map['currentDoctor']);
    previousVisitId = ParsingHelper.parseStringMethod(map['previousVisitId']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    updatedTime = ParsingHelper.parseTimestampMethod(map['updatedTime']);
    completedTime = ParsingHelper.parseTimestampMethod(map['completedTime']);
    weight = ParsingHelper.parseDoubleMethod(map['weight']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    isPrescribed = ParsingHelper.parseBoolMethod(map['isPrescribed']);
    isTreatmentActiveStream = ParsingHelper.parseBoolMethod(map['isTreatmentActiveStream']);


    List<DiagnosisModel> diagnosisList = <DiagnosisModel>[];
    List<Map> diagnosisMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['diagnosis']);
    for (Map diagnosisMap in diagnosisMapList) {
      Map<String, dynamic> newDiagnosisMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(diagnosisMap);
      if(newDiagnosisMap.isNotEmpty) {
        DiagnosisModel visitDiagnosisModel = DiagnosisModel.fromMap(newDiagnosisMap);
        diagnosisList.add(visitDiagnosisModel);
      }
    }
    diagnosis = diagnosisList;

    List<TreatmentActivityModel> treatmentModelList = <TreatmentActivityModel>[];

    List<Map> treatmentModelMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['treatmentActivity']);
    for (Map treatmentActivityMap in treatmentModelMapList) {
      Map<String, dynamic> newTreatmentMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(treatmentActivityMap);
      if(newTreatmentMap.isNotEmpty) {
        TreatmentActivityModel visitTreatmentModel = TreatmentActivityModel.fromMap(newTreatmentMap);
        treatmentModelList.add(visitTreatmentModel);
      }
    }
    treatmentActivity = treatmentModelList;

    List<TreatmentActivityModel> treatmentModelLogList = <TreatmentActivityModel>[];
    List<Map> treatmentModelLogMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['treatmentActivity']);
    for (Map treatmentActivityLogMap in treatmentModelLogMapList) {
      Map<String, dynamic> newTreatmentLogMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(treatmentActivityLogMap);
      if(newTreatmentLogMap.isNotEmpty) {
        TreatmentActivityModel visitTreatmentModel = TreatmentActivityModel.fromMap(newTreatmentLogMap);
        treatmentModelLogList.add(visitTreatmentModel);
      }
    }
    treatmentActivityDetailedLog = treatmentModelLogList;

    Map<String, VisitBillingModel> finalVisitBillingsMap = <String, VisitBillingModel>{};
    Map<String, dynamic> visitBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['visitBillings']);
    if(visitBillingsMap.isNotEmpty) {
      visitBillingsMap.forEach((String doctorId, dynamic value) {
        Map<String, dynamic> visitBillingMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(value);
        if(visitBillingMap.isNotEmpty) {
          VisitBillingModel visitBillingModel = VisitBillingModel.fromMap(visitBillingMap);
          finalVisitBillingsMap[doctorId] = visitBillingModel;
        }
      });
    }
    visitBillings = finalVisitBillingsMap;

    Map<String, dynamic> pharmaBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['pharmaBilling']);
    if(pharmaBillingsMap.isNotEmpty) {
      pharmaBilling = PharmaBillingModel.fromMap(pharmaBillingsMap);
    }

    Map<String, dynamic> vitalsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['vitals']);
    if(pharmaBillingsMap.isNotEmpty) {
      vitals = VitalsModel.fromMap(vitalsMap);
    }

    Map<String, dynamic> patientmetaMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['patientMetaModel']);
    if(pharmaBillingsMap.isNotEmpty) {
      patientMetaModel = PatientMetaModel.fromMap(patientmetaMap);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id" : id,
      "patientId" : patientId,
      "currentDoctor" : currentDoctor,
      "previousVisitId" : previousVisitId,
      "createdTime" : createdTime,
      "updatedTime" : updatedTime,
      "completedTime" : completedTime,
      "weight" : weight,
      "active" : active,
      "isTreatmentActiveStream" : isTreatmentActiveStream,
      "isPrescribed" : isPrescribed,
      "diagnosis" : diagnosis.map((e) => e.toMap()).toList(),
      "visitBillings" : visitBillings.map((key, value) => MapEntry(key, value.toMap())),
      "treatmentActivity" : treatmentActivity.map((e) => e.toMap()).toList(),
      "treatmentActivityDetailedLog" : treatmentActivityDetailedLog.map((e) => e.toMap()).toList(),
      "pharmaBilling" : pharmaBilling?.toMap(),
      "patientMetaModel" : patientMetaModel?.toMap(),
      "vitals" : vitals?.toMap(),
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}