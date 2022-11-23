import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/parsing_helper.dart';

enum TreatmentActivityStreamEnum{
 none,registered,prescribed,billPay,completed,
}

class TreatmentActivityModel {
  Timestamp? createdTime;
  TreatmentActivityStreamEnum activityMessage= TreatmentActivityStreamEnum.none;

  TreatmentActivityModel({
    this.createdTime,
    this.activityMessage = TreatmentActivityStreamEnum.none,
  });

  TreatmentActivityModel.fromMap(Map<String, dynamic> map) {
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    activityMessage = getTreatmentActivityEnumFromString(map['activityMessage']);
  }

  Map<String, dynamic> toMap(){
    return  <String, dynamic>{
      'createdTime' : createdTime,
      'activityMessage' : getTreatmentActivityStringFromEnum(activityMessage),
    };
  }

  static TreatmentActivityStreamEnum getTreatmentActivityEnumFromString(String activityMessage) {
    if(activityMessage.isEmpty) return TreatmentActivityStreamEnum.none;

    if(activityMessage == "billPay") return TreatmentActivityStreamEnum.billPay;
    else if(activityMessage == "completed") return TreatmentActivityStreamEnum.completed;
    else if(activityMessage == "prescribed") return TreatmentActivityStreamEnum.prescribed;
    else if(activityMessage == "registered") return TreatmentActivityStreamEnum.registered;
    return TreatmentActivityStreamEnum.none;
  }

  static String getTreatmentActivityStringFromEnum(TreatmentActivityStreamEnum activityMessage) {
    if(activityMessage == TreatmentActivityStreamEnum.billPay) return "billPay";
    else if(activityMessage == TreatmentActivityStreamEnum.registered) return "registered";
    else if(activityMessage == TreatmentActivityStreamEnum.prescribed) return "prescribed";
    else if(activityMessage == TreatmentActivityStreamEnum.completed) return "completed";
    return "";
  }

  @override
  String toString() {
    return toMap().toString();
  }
}


   TreatmentActivityModel getTreatmentActivityStatus({TreatmentActivityStreamEnum activityMessageEnum = TreatmentActivityStreamEnum.none}){
      return TreatmentActivityModel(
        createdTime: Timestamp.now(),
        activityMessage: activityMessageEnum
      );
   }



