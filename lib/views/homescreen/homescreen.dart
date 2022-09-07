import 'package:flutter/material.dart';
import 'package:patient/controllers/navigation_controller.dart';
import 'package:patient/controllers/patient_controller.dart';
import 'package:patient/models/patient_model.dart';
import 'package:patient/providers/authentication_provider.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/views/common/components/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/authentication_controller.dart';
import 'components/custom_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData themeData;

  late Future<void> futureGetPatientsData;

  Future<void> getPatientsData() async {
    AuthenticationProvider authenticationProvider = Provider.of(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(authenticationProvider.mobileNumber.isNotEmpty) {
      List<PatientModel> patients = await PatientController().getPatientsForMobileNumber(mobileNumber: authenticationProvider.mobileNumber);
      if(patients.isEmpty) {
        PatientModel? patientModel = await PatientController().createPatient(mobile: authenticationProvider.mobileNumber);

        if(patientModel != null) {
          await PatientController().getPatientsForMobileNumber(mobileNumber: authenticationProvider.mobileNumber);
        }
        else {
          AuthenticationController().logout(context: context, isNavigateToLogin: true);
        }
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
    themeData = Theme.of(context);
    return getMainBody2();
  }

  Widget getMainBody2() {
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

  Widget mainBody(){
    return CustomBottomNavigation(
      icons: const [
        Icons.dashboard_outlined,
        Icons.history,
        Icons.file_copy_outlined
      ],
      activeIcons: const [
        Icons.dashboard,
        Icons.history,
        Icons.file_copy
      ],
      screens: const [
        Text("Dashboard"),
        Text("History"),
        Text("Treatment"),
      ],
      titles: const ["Dashboard", "History", "Treatment"],
      color: themeData.colorScheme.onBackground,
      activeColor: themeData.colorScheme.primary,
      navigationBackground: themeData.backgroundColor,
      brandTextColor: themeData.colorScheme.onBackground,
      initialIndex: 2,
      splashColor: themeData.splashColor,
      highlightColor: themeData.highlightColor,
      backButton: Container(),
      floatingActionButton: Container(),
      iconSize: 20,
      activeIconSize: 20,
      verticalDividerColor: themeData.dividerColor,
      bottomNavigationElevation: 8,
    );
  }
}
