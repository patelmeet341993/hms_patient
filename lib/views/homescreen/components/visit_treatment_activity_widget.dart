import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/views/homescreen/screens/visit_screen.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../configs/styles.dart';
import '../../../controllers/my_visit_controller.dart';
import '../../../providers/visit_provider.dart';
import '../../common/componants/common_bold_text.dart';
import '../../common/componants/common_button.dart';

class VisitTreatmentActivity extends StatefulWidget {
  static const String routeName = "/VisitTreatmentActivity";
  final String visitId;
  final VisitModel? visitModel;
  const VisitTreatmentActivity({Key? key, this.visitId = "", this.visitModel}) : super(key: key);

  @override
  State<VisitTreatmentActivity> createState() => _VisitTreatmentActivityState();
}

class _VisitTreatmentActivityState extends State<VisitTreatmentActivity> {
  VisitModel visitModel = VisitModel();
  late MyVisitController visitController;
  late VisitProvider visitProvider;
  Future? future;
  late ThemeData themeData;
  String titleString = "Current";

  List<Map<String, dynamic>> data =  [
    {"data1":"data","subtitle":"as dma ca cbna cba  cas ca scas cas cjhsa jc a s c sab c as ch asghhjs bcjasbckas k"},
    {"data1":"data","subtitle":"as dma ca cbna cba  cas ca scas cas cjhsa jc a s c sab c as ch asghhjs bcjasbckas k"},
    {"data1":"data","subtitle":"as dma ca cbna cba  cas ca scas cas cjhsa jc a s c sab c as ch asghhjs bcjasbckas k"},
    {"data1":"data","subtitle":"as dma ca cbna cba  cas ca scas cas cjhsa jc a s c sab c as ch asghhjs bcjasbckas k"}
  ];

  @override
  void initState() {
    super.initState();
    MyPrint.printOnConsole("in in it state ${widget.visitModel?.id}");
    visitModel = widget.visitModel ?? VisitModel();
  }

  @override
  void didUpdateWidget(covariant VisitTreatmentActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.visitModel != null) {
      visitModel = widget.visitModel!;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // visitModel = widget.visitModel ?? VisitModel();

    MyPrint.printOnConsole("VisitTreatmentActivity widget.visitId:'${widget.visitId}'");

    return Column(
            children: [
              Row(
                children: [
                  CommonBoldText(text: "$titleString Treatment Activity",textAlign: TextAlign.start,fontSize: 15,color: Colors.black.withOpacity(.9)),
                  const SizedBox(width: 10,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Styles.lightPrimaryColor.withOpacity(0.2),
                        border: Border.all(color: Styles.lightPrimaryColor),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: CommonBoldText(text:DatePresentation.ddMMMMyyyyTimeStamp(visitModel.createdTime ?? Timestamp.now()),textAlign: TextAlign.start,fontSize: 12,color: Colors.black.withOpacity(.9))),
                ],
              ),
             ListView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: visitModel.treatmentActivity.length,
               itemBuilder: (BuildContext context, int index) {

                  if(visitModel.treatmentActivity[index].treatmentActivityStatus == TreatmentActivityStatus.completed){
                    titleString = "Last";
                  } else {
                    titleString = "Current";
                  }
                   final example = visitModel.treatmentActivity[index];

                   return getTimeLineView(index);
               },
             )

            ],
          );

  }

  Widget getTimeLineView(int index){
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: index == 0,
      isLast: index == visitModel.treatmentActivity.length - 1,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: IndicatorExample(number: '${index + 1}'),

        drawGap: true,
      ),
      beforeLineStyle: LineStyle(
        color: Colors.grey.withOpacity(0.2),
      ),
      endChild: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: getWidgetsAccordingToStatus(
              treatmentActivityStatus: visitModel.treatmentActivity[index].treatmentActivityStatus,
              visitModel: visitModel,
              index: index
          ),
        ),

        // visitModel.treatmentActivity[index].treatmentActivityStatus == TreatmentActivityStatus.prescribed ? prescriptionExpansionTile(): TimeLineRow(treatmentActivityModel: example, visitModel: visitModel),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute<ShowcaseTimeline>(
          //     builder: (_) =>
          //         ShowcaseTimeline(example: example),
          //   ),
          // );
        },
      ),
    );
  }

  Widget getWidgetsAccordingToStatus({String treatmentActivityStatus = "", VisitModel? visitModel, index}){
    if(treatmentActivityStatus == TreatmentActivityStatus.assigned){
      return TimeLineRow(treatmentActivityModel: visitModel!.treatmentActivity[index], visitModel: visitModel,);
    } else if(treatmentActivityStatus == TreatmentActivityStatus.prescribed){
      return prescriptionExpansionTile(visitModel!, index);
    } else if(treatmentActivityStatus == TreatmentActivityStatus.pharmaPay){
      return getPharmaBillTile(visitModel!,index);
    }
    else {
      return TimeLineRow(treatmentActivityModel: visitModel!.treatmentActivity[index], visitModel: visitModel,);
    }
  }

  Widget prescriptionExpansionTile(VisitModel visitModel, index){
    TreatmentActivityModel treatmentActivityModel = visitModel.treatmentActivity[index];
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Styles.cardColor,
            ),
            child: ExpansionTile(

              backgroundColor: Colors.transparent,

              collapsedBackgroundColor: Colors.transparent,

              tilePadding: const EdgeInsets.symmetric(horizontal: 10,vertical:0),

              title: Text(treatmentActivityModel.treatmentActivityStatus),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 2,),
                  Text(visitModel.visitBillings.values.first.doctorName,style: const TextStyle(height: 1),),
                  const SizedBox(height: 3,),
                  updatedDateTimeText(treatmentActivityModel.updatedTime ?? treatmentActivityModel.createdTime!)
                ],
              ),

              children: [
                getPrescriptionTable()
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              color: Styles.cardColor,
              //color: themeData.primaryColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Doctor consultancy fee", style: Theme.of(context).textTheme.bodySmall,),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: visitModel.visitBillings.values.first.totalFees.toString(),
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, decoration: TextDecoration.lineThrough,color: Colors.black),
                              children: [
                                TextSpan(
                                  text: " ${visitModel.visitBillings.values.first.discount}",
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15,decoration: TextDecoration.none),
                                )
                              ]
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Visibility(
                          visible:  visitModel.visitBillings.values.first.paymentStatus == PaymentStatus.paid,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1),
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(PaymentStatus.paid,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,letterSpacing: 0.3,),),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                ),
                Visibility(
                  visible: visitModel.visitBillings.values.first.paymentStatus == PaymentStatus.pending,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonButton(verticalPadding:2, buttonName: "Cash", onTap: (){}),
                      const SizedBox(width: 10,),
                      CommonButton(verticalPadding: 2,buttonName: "Online", onTap: (){}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getPrescriptionTable(){
    return DataTable(
        headingRowHeight: 30,
        headingRowColor: MaterialStateProperty.resolveWith(
              (states) => themeData.primaryColor.withOpacity(0.3),),
        columns: [
          DataColumn(label:getColumnItem("Medicine")),
          DataColumn(label:getColumnItem("Dose")),
          DataColumn(label:getColumnItem("Dose count")),
        ],
        rows: List.generate(visitModel.diagnosis.length, (index) {
          PrescriptionModel prescriptionModel = visitModel.diagnosis[index].prescription[index];
          return getDataRow(prescriptionModel: prescriptionModel,index: index);
        })
    );
  }

  Widget getPharmaBillTile(VisitModel visitModel, int index){
    TreatmentActivityModel treatmentActivityModel = visitModel.treatmentActivity[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Styles.cardColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(treatmentActivityModel.treatmentActivityStatus, style: themeData.textTheme.subtitle1,),
                const SizedBox(height: 2,),
                Row(
                  children: [
                    Container(
                        child: Text("Total amount: ${visitModel.pharmaBilling?.totalAmount ?? 0}", style: themeData.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w600,letterSpacing: 0.2,height: 1),)),
                    Visibility(
                      visible:  visitModel.pharmaBilling?.paymentStatus == PaymentStatus.paid,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(PaymentStatus.paid,style: themeData.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w600,fontSize: 12,letterSpacing: 0.3, color: Colors.green),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 3,),
                updatedDateTimeText(treatmentActivityModel.updatedTime ?? treatmentActivityModel.createdTime!)
              ],
            ),
          ),
          Visibility(
            visible: visitModel.pharmaBilling?.paymentStatus == PaymentStatus.pending,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CommonButton(verticalPadding:2, buttonName: "Cash", onTap: (){}),
                // const SizedBox(width: 10,),
                CommonButton(verticalPadding: 2,buttonName: "Online", onTap: (){}),
              ],
            ),
          ),
          Visibility(
            visible:  visitModel.pharmaBilling?.paymentStatus == PaymentStatus.paid,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                  color: themeData.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Invoice ",style: themeData.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w600,fontSize: 12,letterSpacing: 0.3,color: themeData.primaryColor),
                  ),
                  Icon(FontAwesomeIcons.fileInvoice,size: 13, color: themeData.primaryColor,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow getDataRow({ required PrescriptionModel prescriptionModel,int index = 0}){
    return DataRow(
        cells: [
          getDataCell(prescriptionModel.medicineName,),
          getDataCell(prescriptionModel.doses[index].dose,),
          getDataCell(prescriptionModel.doses[index].doseCount.toString()),
        ]
    );
  }

  Widget getColumnItem(String text){
    return Expanded(child:Center(child: Text(text,style: themeData.textTheme.bodySmall,)));
  }

  DataCell getDataCell(String text){
    return  DataCell(Center(
      child: Text(text,
        style: themeData.textTheme.bodySmall,
        overflow: TextOverflow.visible,
        softWrap: true,),
    ),);
  }

  Widget updatedDateTimeText(Timestamp timestamp){
    return  Text(DatePresentation.hhMM(timestamp),style: themeData.textTheme.bodySmall!.copyWith(height: 1,letterSpacing: 0.5,fontSize: 12),
    );
  }

}



// Container(
// // width: MediaQuery.of(context).size.width,
// // height: 200,
// child: Row(
// children: [
// Expanded(
// child: SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Wrap(
// direction: Axis.horizontal,
// // runSpacing: 100,
// runAlignment: WrapAlignment.spaceBetween,
// clipBehavior: Clip.antiAlias,
// // mainAxisSize: MainAxisSize.max,
// children: data.map((e) {
// return Container(
// decoration: BoxDecoration(
// border: Border.all(color: Colors.black),
// borderRadius: BorderRadius.circular(10)
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Text(e["data1"])
// ],
// ),
// Text(e["subtitle"],overflow: TextOverflow.ellipsis,maxLines: 1,)
// ],
// ),
// );
// }).toList(),
// ),
// ),
// ),
// ],
// ),
// )