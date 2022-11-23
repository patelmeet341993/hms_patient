import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/parsing_helper.dart';

import '../../../utils/parsing_helper.dart';

class VitalsModel{

  String bloodGroup="";
  double? height,weight,pulse,bpSystolic,bpDiastolic,temperature;

  VitalsModel({
    this.bloodGroup="",
    this.height,
    this.bpSystolic,
    this.bpDiastolic,
    this.pulse,
    this.temperature,
    this.weight
  });

  VitalsModel.fromMap(Map<String, dynamic> map) {
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    height = ParsingHelper.parseDoubleMethod(map['height']);
    weight = ParsingHelper.parseDoubleMethod(map['weight']);
    bpSystolic = ParsingHelper.parseDoubleMethod(map['bpSystolic']);
    bpDiastolic = ParsingHelper.parseDoubleMethod(map['bpDiastolic']);
    pulse = ParsingHelper.parseDoubleMethod(map['pulse']);
    temperature = ParsingHelper.parseDoubleMethod(map['temperature']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "bloodGroup" : bloodGroup,
      "height" : height,
      "weight" : weight,
      "bpSystolic" : bpSystolic,
      "bpDiastolic" : bpDiastolic,
      "pulse" : pulse,
      "temperature" : temperature,
    };
  }

}