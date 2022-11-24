import 'package:flutter/material.dart';
import 'package:patient/configs/my_print.dart';
import 'package:patient/controllers/visit_controller.dart';
import 'package:patient/providers/patient_provider.dart';
import 'package:patient/providers/visit_provider.dart';
import 'package:patient/utils/logger_service.dart';
import 'package:patient/views/homescreen/screens/visit_screen.dart';
import 'package:patient/views/profile/screens/profilescreen.dart';
import 'package:provider/provider.dart';

import '../../../configs/styles.dart';
import '../../../controllers/authentication_controller.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../controllers/patient_controller.dart';
import '../../../models/patient_model.dart';
import '../../../packages/flux/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../providers/authentication_provider.dart';
import '../../common/components/loading_widget.dart';
import '../../my_prescription/screens/prescription_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData themeData;

  Future<void>? futureGetPatientsData;

  @override
  void initState() {
    // MyPrint.printOnConsole("startTreatmentActivityStream :}");
    PatientProvider patientProvider = Provider.of(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    if(patientProvider.patientsLength > 0 && patientProvider.getCurrentPatient() != null) {

    }
    else {
      futureGetPatientsData = PatientController().getPatientsDataForMainPage(isRefresh: false, isFromCache: true);
    }
    // futureGetPatientsData = PatientController().getPatientsDataForMainPage(isRefresh: false, isFromCache: true);

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      color: themeData.backgroundColor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: futureGetPatientsData != null ? FutureBuilder(
          future: futureGetPatientsData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Log().i("Connection State:${snapshot.connectionState}");
            if(snapshot.connectionState == ConnectionState.done) {
              return getMainBody();
            }
            else {
              return Center(
                child: LoadingWidget(),
              );
            }
          },
        ) : getMainBody(),
      ),
    );
  }

  Widget getMainBody() {
    return FxBottomNavigationBar(
      containerDecoration: BoxDecoration(
        color: Styles.cardColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      activeContainerColor:themeData.primaryColor.withAlpha(30),
      fxBottomNavigationBarType: FxBottomNavigationBarType.containered,
      showActiveLabel: false,
      showLabel: false,
      activeIconSize: 24,
      iconSize: 24,
      activeIconColor: themeData.primaryColor,
      iconColor: Colors.grey,
      itemList: [
        FxBottomNavigationBarItem(
          page: VisitScreen(visitProvider: Provider.of<VisitProvider>(context)),
          activeIconData: Icons.house,
          iconData: Icons.house_outlined,
        ),
        FxBottomNavigationBarItem(
          page: MyPrescriptionScreen(),
          activeIconData: Icons.date_range,
          iconData: Icons.date_range_outlined,
        ),
        // FxBottomNavigationBarItem(
        //   page: Container(),
        //   activeIconData: Icons.chat_bubble,
        //   iconData: Icons.chat_bubble_outline_rounded,
        // ),
        FxBottomNavigationBarItem(
          page: ProfileScreen(),
          activeIconData: Icons.person,
          iconData: Icons.person_outline_rounded,
        ),
      ],
    );
  }
}
