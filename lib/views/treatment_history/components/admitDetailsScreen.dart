import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/views/common/componants/common_button.dart';

class AdmittedDetailScreen extends StatefulWidget {
  VisitModel? visitModel;
  AdmittedDetailScreen({Key? key, this.visitModel}) : super(key: key);

  @override
  State<AdmittedDetailScreen> createState() => _AdmittedDetailScreenState();
}

class _AdmittedDetailScreenState extends State<AdmittedDetailScreen> {

  ObservationModel? selectedObservation, selectedMedication;

  ObservationModel observationModel = ObservationModel();
  List<ObservationModel> observationList = [],medicationsList = [],observationListNew = [], medicationList = [],  selectedObservationsList = [], selectedMedicationList = [];
  AdmitModel admitModel = AdmitModel();
  // Map<int, ObservationModel> observationListNew2 = {};
  List<ObservationModel> tempList = [];
  ObservationsDataModel observationDataModel = ObservationsDataModel();
  List<ObservationsDataModel> observationsDataList = [];

  late ThemeData themeData;

  Future? futureData;
  PropertyModel propertyModel = PropertyModel();
  TextEditingController observationController =  TextEditingController();
  TextEditingController medicationController =  TextEditingController();

  Future<void> getPropertyData() async {
    DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection("admin").doc("property").get();
    propertyModel = PropertyModel.fromMap(Map.castFrom(documentSnapshot.data() ?? {}));
    MyPrint.printOnConsole("propertyModel: ${propertyModel.observations}");
    if(propertyModel.observations.checkNotEmpty) {
      for (var element in propertyModel.observations) {
        observationList.add(element);
      }
      MyPrint.printOnConsole("propertyModel.length: ${observationList.length}");
    }
    if(propertyModel.medications.checkNotEmpty){
      for (var element in propertyModel.medications) {
        medicationsList.add(element);
      }
    }
    setState(() {});
  }

  Future<void> saveData() async {
    try {
      VisitModel visitModel = widget.visitModel ?? VisitModel();
      if(visitModel.isAdmitted) {
        visitModel.admitModel = admitModel;
        DocumentReference ref = FirestoreController.documentReference(
            collectionName: FirebaseNodes.visitsCollection,
            documentId: visitModel.id);
        await ref.update(visitModel.toMap());
      }
    }catch(e,s){
      MyPrint.printOnConsole("error in saving data: ${e}");
      MyPrint.printOnConsole(s);
    }
  }


  @override
  void initState() {
    super.initState();
    futureData = getPropertyData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Observations"),
      ),
      body: getMainBody(),
    );
  }

  Widget getMainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            observationView(),
            const SizedBox(height: 10,),
            Visibility(
                // visible: observationModel?.observations?.isNotEmpty ?? false,
                child: observationData()),
            const SizedBox(height: 10,),
            medicationView(),
            Visibility(
              // visible: observationModel?.observations?.isNotEmpty ?? false,
                child: medicationData()),
            const SizedBox(height: 10,),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget observationView(){
    return Row(
      children: [
        Expanded(child: dropDownView()),
      ],
    );
  }

  Widget dropDownView(){
    return Theme(
      data: themeData,
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        padding: const EdgeInsets.only(left: 10),
        child: DropdownButton<ObservationModel>(
            dropdownColor: Colors.white,
            underline: Container(),
            isExpanded: true,
            hint: const Text("Select observation"),
            value: selectedObservation,
            items: observationList.map((e) {
              return DropdownMenuItem<ObservationModel>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
            onChanged: (ObservationModel? value){
              selectedObservation = value;
              Map<String,dynamic> valuesMap = selectedObservation?.values ?? {};
              valuesMap.forEach((key, value) {
                valuesMap[key] = TextEditingController();
              });
              ObservationModel observation = ObservationModel(
                  icon: selectedObservation?.icon ?? "",
                  name: selectedObservation?.name ?? "",
                  value: observationController.text.trim(),
                  priority: selectedObservation?.priority ?? 0,
                  note: "note note note",
                  values: valuesMap
              );
              observationDataModel.observation = observationListNew;
              observationListNew.add(observation);
              setState(() {});
            }),
      ),
    );
  }

  Widget medicationView(){
    return Row(
      children: [
        Expanded(child: dropDownView2()),
        const SizedBox(width: 10,),
        Expanded(
          child: TextFormField(

            controller:medicationController,
            decoration: const InputDecoration(
              hintText: "Value",
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder()
            ),
          ),
        ),
        const SizedBox(width: 10,),

        addButton(
          onTap: (){

            ObservationModel medication = ObservationModel(
                icon: selectedMedication?.icon ?? "",
                name: selectedMedication?.name ?? "",
                value: medicationController.text.trim(),
                priority: selectedMedication?.priority ?? 0,
                note: "note note note"
            );

            if(medicationList.where((element) => element.name == selectedMedication?.name).isEmpty){
              medicationList.add(medication);
            }
            // observationDataModel.medications = [];
            // observationDataModel = ObservationsData(
            //   medications: medicationList
            // );
            observationDataModel.medications = medicationList;


            setState(() {});
          }
        )
      ],
    );
  }

  Widget dropDownView2(){
    return Theme(
      data: themeData,
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        padding: const EdgeInsets.only(left: 10),
        child: DropdownButton(
            dropdownColor: Colors.white,
            underline: Container(),

            isExpanded: true,
            hint: const Text("Select Medications"),

            value: selectedMedication,
            items: medicationsList.map((e) {
                return DropdownMenuItem(
                    value: e,
                    child: Text(e.name));
              }).toList(),
            onChanged: (dynamic value){
              selectedMedication = value;
              setState(() {});
            }),
      ),
    );
  }

  Widget addButton({Function()? onTap}){
   return CommonButton(
       buttonName: "Add",
       onTap: onTap
   );
  }

  Widget observationData(){
   return Column(
     children: observationListNew.map((e) {
       return Container(
         margin: const EdgeInsets.all(8),
         padding: const EdgeInsets.all(8),
         decoration: BoxDecoration(
           shape: BoxShape.rectangle,
           border: Border.all(color: Colors.black45,width: 0.5)
         ),
         child: Column(
           children: [
             Row(
               children: [
                 Text(e.name,style: const TextStyle(color: Colors.black),),
                 const Text(" : "),
                 Flexible(
                   child: TextFormField(
                     controller: TextEditingController(text: e.value),
                     onChanged: (String val){
                       e.value = val;
                       // setState(() {});
                     },
                     decoration: InputDecoration(
                       contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                       hintText: e.value,
                     ),
                   ),
                 ),

                 // Text(e.value,style: const TextStyle(color: Colors.black),),
                 const SizedBox(width: 10,),
                 InkWell(
                   onTap: (){
                     FocusScope.of(context).requestFocus(FocusNode());

                   },
                   child: const Icon(Icons.check,size: 20,),
                 ),
                 const SizedBox(width: 10,),
                 InkWell(
                   onTap: (){
                     ObservationModel observation = ObservationModel(
                         icon: selectedObservation?.icon ?? "",
                         name: selectedObservation?.name ?? "",
                         value: observationController.text.trim(),
                         priority: selectedObservation?.priority ?? 0,
                         note: "note note note",
                         values: Map.castFrom(selectedObservation?.values ?? {})
                     );
                     observationDataModel.observation = observationListNew;
                     observationListNew.add(observation);


                     MyPrint.printOnConsole("observationListNewobservationListNew: ${observationListNew}");
                     MyPrint.printOnConsole("selectedObservation?.values: ${selectedObservation?.values}");
                     setState(() {});
                   },
                   child: const Icon(Icons.add,size: 20,),
                 ),
                 const SizedBox(width: 10,),
                 InkWell(
                   onTap: (){
                     observationListNew.remove(e);
                     setState(() {});
                   },
                   child: const Icon(Icons.delete,size: 20,),
                 ),
               ],
             ),
             const SizedBox(height: 10,),
             Visibility(
                 visible: e.values.isEmpty ? false:true,
                 child: ListView(
                   physics: const NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   children: List.generate(
                       e.values.keys.length, (index) {
                     return Container(
                       margin: EdgeInsets.only(bottom: 8),
                       child: Row(
                         children: [
                           Text("${e.values.keys.toList()[index]} : "),
                           const SizedBox(width: 10,),
                           Expanded(
                               child: TextFormField(
                                 controller:e.values.values.toList()[index],
                               onChanged: (String? val){
                               // dataValue[element] = val;
                               // e.values[element] = val;
                               // if(e.value.c){

                               // if(!tempList.contains(e)){
                               // }
                               // if(observationListNew.indexO33f(e))

                               // if(e.value == e.v) {
                               // if(e.value == observationListNew[listIndex].value){
                               //   observationListNew[listIndex].values[e.values.keys.toList()[index]] = val;
                               // }
                               // }
                               // }
                             },
                             decoration: InputDecoration(
                                 contentPadding: EdgeInsets.zero
                             ),
                            ),
                           )
                         ],
                       ),
                     );
                  })

                   // e.values.keys.map((element){
                   //   // textEditingController = TextEditingController();
                   //   return Container(
                   //     margin: EdgeInsets.only(bottom: 8),
                   //     child: Row(
                   //       children: [
                   //         Text("$element : "),
                   //         const SizedBox(width: 10,),
                   //         Expanded(child: TextFormField(
                   //           onChanged: (String? val){
                   //              MyPrint.printOnConsole("innnn:");
                   //              // dataValue[element] = val;
                   //               // e.values[element] = val;
                   //             // if(e.value.c){
                   //               e.values[element] = val;
                   //             // }
                   //           },
                   //           decoration: InputDecoration(
                   //             contentPadding: EdgeInsets.zero
                   //           ),
                   //         ))
                   //       ],
                   //     ),
                   //   );
                   // }).toList(),
                 )
             ),
             /*saveButton(onTap:(){
               MyPrint.printOnConsole("sduhfijs : ${observationListNew}");
               // observationListNew.where((element) =>)

               setState(() {

               });
             })*/
           ],
         ),
       );
     }).toList(),
   );
  }

  Widget medicationData(){
   return Column(
     children: medicationList.map((e) {
       return Row(
         children: [
           Text(e.name,style: const TextStyle(color: Colors.black),),
           const Text(" : "),
           Text(e.value,style: const TextStyle(color: Colors.black),),
         ],
       );
     }).toList(),
   );
  }

  Widget saveButton({Function()? onTap}){
    return CommonButton(buttonName: "Save", onTap: onTap ?? () async {
      observationDataModel.createdTime = Timestamp.now();
      observationsDataList.add(observationDataModel);
      admitModel.observationDataList = observationsDataList;

      MyPrint.printOnConsole("addmitted : ${admitModel.toMap()}");
      await saveData();

    });
  }
}
