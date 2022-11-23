import '../../../configs/constants.dart';
import '../../../utils/parsing_helper.dart';

class PrescriptionMedicineDoseModel {
  String doseTime = PrescriptionMedicineDoseTime.morning, dose = "";
  int doseCount = 0;
  bool afterMeal = false, beforeMeal = false;

  PrescriptionMedicineDoseModel({
    this.doseTime = PrescriptionMedicineDoseTime.morning,
    this.afterMeal = false,
    this.beforeMeal = false,
    this.dose = "",
    this.doseCount = 0,
  });

  PrescriptionMedicineDoseModel.fromMap(Map<String, dynamic> map) {
    doseTime = ParsingHelper.parseStringMethod(map['doseTime']);
    dose = ParsingHelper.parseStringMethod(map['dose']);
    afterMeal = ParsingHelper.parseBoolMethod(map['afterMeal']);
    beforeMeal = ParsingHelper.parseBoolMethod(map['beforeMeal']);
    doseCount = ParsingHelper.parseIntMethod(map['doseCount']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    doseTime = ParsingHelper.parseStringMethod(map['doseTime']);
    dose = ParsingHelper.parseStringMethod(map['dose']);
    doseCount = ParsingHelper.parseIntMethod(map['doseCount']);
    afterMeal = ParsingHelper.parseBoolMethod(map['afterMeal']);
    beforeMeal = ParsingHelper.parseBoolMethod(map['beforeMeal']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "doseTime" : doseTime,
      "dose" : dose,
      'doseCount' : doseCount,
      "afterMeal" : afterMeal,
      "beforeMeal" : beforeMeal,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}