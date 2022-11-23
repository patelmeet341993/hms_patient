import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../utils/parsing_helper.dart';


class PatientMetaModel extends Equatable {
  String id = "", name = "", bloodGroup = "", gender = "";
  Timestamp? dateOfBirth;
  int totalVisits = 0;
  String userMobile = "";

  PatientMetaModel({
    this.id = "",
    this.name = "",
    this.bloodGroup = "",
    this.gender = "",
    this.dateOfBirth,
    this.totalVisits = 0,
    this.userMobile = "",
  });

  PatientMetaModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    dateOfBirth = ParsingHelper.parseTimestampMethod(map['dateOfBirth']);
    totalVisits = ParsingHelper.parseIntMethod(map['totalVisits']);
    userMobile = ParsingHelper.parseStringMethod(map['userMobile']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    dateOfBirth = ParsingHelper.parseTimestampMethod(map['dateOfBirth']);
    totalVisits = ParsingHelper.parseIntMethod(map['totalVisits']);
    userMobile = ParsingHelper.parseStringMethod(map['userMobile']);
  }

  Map<String, dynamic> toMap({bool json = false}) {
    return <String, dynamic>{
      "id" : id,
      "name" : name,
      "bloodGroup" : bloodGroup,
      "gender" : gender,
      "dateOfBirth" : dateOfBirth,
      "totalVisits" : totalVisits,
      "userMobiles" : userMobile,
    };
  }

  @override
  String toString({bool json = false}) {
    return toMap(json: json).toString();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    bloodGroup,
    gender,
    dateOfBirth?.millisecondsSinceEpoch ?? 0,
    totalVisits,
    userMobile,
  ];
}