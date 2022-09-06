import 'package:flutter/material.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/controllers/patient_controller.dart';
import 'package:patient/models/patient_model.dart';
import 'package:patient/providers/authentication_provider.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/views/common/components/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/authentication_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> futureGetPatientsData;

  Future<void> getPatientsData() async {
    AuthenticationProvider authenticationProvider = Provider.of(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(authenticationProvider.mobileNumber.isNotEmpty) {
      List<PatientModel> patients = await PatientController().getPatientsForMobileNumber(mobileNumber: authenticationProvider.mobileNumber);
      if(patients.isEmpty) {
        PatientModel? patientModel = await PatientController().createPatient(mobile: authenticationProvider.mobileNumber);

        await PatientController().getPatientsForMobileNumber(mobileNumber: authenticationProvider.mobileNumber);
      }
    }
  }

  @override
  void initState() {
    futureGetPatientsData = getPatientsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          actions: [
            IconButton(
              onPressed: () {
                AuthenticationController().logout(context: context, isNavigateToLogin: true);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: FutureBuilder<void>(
          future: futureGetPatientsData,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return Consumer<PatientProvider>(
                builder: (BuildContext context, PatientProvider patientProvider, Widget? child) {
                  PatientModel? currentPatient = patientProvider.getCurrentPatient();
                  return Center(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${patientProvider.patientsLength} Patients Available"),
                        Text(currentPatient != null ? "${currentPatient.id} Patient In Use" : "No Current Patient Available"),
                      ],
                    ),
                  );
                },
              );
            }
            else {
              return const Center(
                child: LoadingWidget(),
              );
            }
          },
        ),
      ),
    );
  }
}
