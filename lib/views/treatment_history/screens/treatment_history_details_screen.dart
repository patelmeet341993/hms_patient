import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/views/common/componants/common_bold_text.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:patient/views/common/components/modal_progress_hud.dart';
import 'package:patient/views/common/components/profile_picture_circle_avatar.dart';
import 'package:patient/views/treatment_history/components/my_expansion_tile.dart';

import '../../../configs/styles.dart';
import '../../common/componants/common_topbar.dart';
import '../../common/components/Treatment_timeline_log_master_widget.dart';
import '../../common/components/loading_widget.dart';


class TreatmentHistoryDetailsScreen extends StatefulWidget {
  static const String routeName = "/TreatmentHistoryDetailsScreen";

   VisitModel? visitModel;
   TreatmentHistoryDetailsScreen(this.visitModel);

  @override
  _TreatmentHistoryDetailsScreenState createState() => _TreatmentHistoryDetailsScreenState();
}

class _TreatmentHistoryDetailsScreenState extends State<TreatmentHistoryDetailsScreen> {

  bool isLoading = false;
  VisitModel? methodVisitModel;
  Future<void> getData() async {
    isLoading = true;
    //await Future.delayed(Duration(seconds: 5));
    if(widget.visitModel != null){
      methodVisitModel = widget.visitModel;
      MyPrint.printOnConsole('Visit Id is: ${methodVisitModel!.id}');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          color: Colors.white,
          opacity: 1,
          inAsyncCall: isLoading,
          progressIndicator: Container(
              child: LoadingWidget()
          ),
          child: ListView(
            children: [
              CommonTopBar(title: "Visit Details",isNotification: false),
              methodVisitModel != null ? SingleChildScrollView(
                child:Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      //getPatientDetails(methodVisitModel!),
                      SizedBox(height: 0,),
                      getTreatmentDetails(methodVisitModel!),
                      SizedBox(height: 10,),
                      methodVisitModel!.treatmentActivity.isNotEmpty
                          ? getActivityTimelineDetails()
                          : SizedBox()
                    ],
                  ),
                ),
              ) : CommonExtraBoldText(text: 'Some Issues in Fetching Your Information, Please try again Later')
            ],
          ),
        ),
      ),
    );
  }


  //region Treatment Details
  Widget getTreatmentDetails(VisitModel myVisitModel){
    return MyExpansionTile(
      titleGap: 15,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: 'Treatment Details',
      children: myVisitModel.diagnosis
          .map((e) => getSingleDoctorDiagnosisDetails(e)).toList(),
    );
  }

  Widget getPersonalInfoWidget({String? name, String? id}){
    return Row(
      children: [
        ProfilePictureCircleAvatar(imageUrl: '',),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonExtraBoldText(text: name ?? "",fontWeight: FontWeight.w700,height: 1,fontSize: 16),
              SizedBox(height: 2,),
              CommonExtraBoldText(text: "ID: ${id ?? ''}",height: 1,fontSize: 10,color: Colors.grey,),
            ],
          ),
        )
      ],
    );
  }

  Widget getSingleDoctorDiagnosisDetails(DiagnosisModel diagnosisModel){
    return Column(
      children: [
        getPersonalInfoWidget(id: diagnosisModel.doctorId,name: 'Dr. ${diagnosisModel.doctorName}'),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 1.0).copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonBoldText(text: 'Description :',fontSize: 16),
              SizedBox(height: 1,),
              CommonText(text: diagnosisModel.diagnosisDescription,fontSize: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: diagnosisModel.prescription.map((e) => getDiagnosisDetailMedicine(e)).toList(),
              ),



            ],
          ),
        ),
      ],
    );
  }

  Widget getDiagnosisDetailMedicine(PrescriptionModel prescriptionModel){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: MyExpansionTile(
        title: 'Medicine: ${prescriptionModel.medicineName}',
        fontSize: 14,
        iconSize: 18,
        initiallyExpanded: false,
        contentPadding: EdgeInsets.only(left: 5),

        children: [
          Row(
            children: [
              Expanded(child: CommonBoldText(text: 'Time',fontSize: 12,textAlign: TextAlign.center),),
              Expanded(child: CommonBoldText(text: 'Instruction(s)',fontSize: 12,textAlign: TextAlign.center),),
              Expanded(child: CommonBoldText(text: 'Total Days',fontSize: 12,textAlign: TextAlign.center),),
              Expanded(child: CommonBoldText(text: 'Total Dose',fontSize: 12,textAlign: TextAlign.center),),
            ],
          ),
          Column(
            children: prescriptionModel.doses != null
                ? prescriptionModel.doses.map((e) => Row(
              children: [
                Expanded(child: CommonBoldText(
                    text: e.doseTime ,fontSize: 11,textAlign: TextAlign.center),),
                Expanded(child: CommonBoldText(text:prescriptionModel.instructions.isEmpty ? '-' : prescriptionModel.instructions ,fontSize: 11,textAlign: TextAlign.center),),
                Expanded(child: CommonBoldText(text: '${prescriptionModel.totalDays}',fontSize: 11,textAlign: TextAlign.center),),
                Expanded(child: CommonBoldText(text: prescriptionModel.totalDose,fontSize: 11,textAlign: TextAlign.center),),
              ],
            ),).toList()
                : [
                  CommonBoldText(text: 'No more Information')
                  ],
          )
        ],
      ),
    );
  }
  //endregion

  //region Treatment Activity
  Widget getActivityTimelineDetails(){
    int index = -1;
    return MyExpansionTile(
        titleGap: 15,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        title: 'Activity Timeline',
        children: methodVisitModel!.treatmentActivity.map((e){
          index++;
          return TreatmentTimelineLogMasterWidget(
              index:index,
              length: methodVisitModel!.treatmentActivity.length,
              primaryText: 'Assigned',
              subText: 'Doctor is Successfully Assigned',
              time: e.createdTime
          );
        }
        ).toList()
    );
  }
  //endregion




  //region commented Patient Details
  /*Widget getPatientDetails(VisitModel myVisitModel){
      return MyExpansionTile(
        title: 'Patient Details',
        titleGap: 15,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          getPersonalInfoWidget(id: myVisitModel.patientId,name: myVisitModel.patientName),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: getPatientShortDetails(title: 'Date of Birth',
                  answer:myVisitModel.patientModel != null ? myVisitModel.patientModel!.dateOfBirth != null
                      ? DateFormat("dd/mm/yyyy").format(myVisitModel.patientModel!.dateOfBirth!.toDate())
                      : "-" : "-", )),
              Expanded(child: getPatientShortDetails(title: 'Weight',answer:myVisitModel.patientModel != null ?'${myVisitModel.patientModel?.weight} kg' : '-')),
              Expanded(child: getPatientShortDetails(title: 'Phone',answer: myVisitModel.patientModel?.userMobiles.first ?? "-")),
              Expanded(child: getPatientShortDetails(title: 'Gender',answer:myVisitModel.patientModel?.gender ?? '-')),
            ],
          ),
          SizedBox(height: 10,),



        ],
      );
    }
    Widget getPatientShortDetails({required String title,required String answer}){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonExtraBoldText(text: title,fontSize: 13,),
          CommonExtraBoldText(text: answer,fontSize: 13,color: Colors.grey,maxLines: 2),
        ],
      );
    }*/
  //endregion

}
