import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hms_models/hms_models.dart';
import 'package:patient/views/common/componants/common_text.dart';
import 'package:patient/views/common/components/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../configs/styles.dart';
import '../../../controllers/authentication_controller.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/container/container.dart';
import '../../../providers/patient_provider.dart';
import '../../about_us/screens/about_us_screen.dart';
import '../../common/componants/common_dialog.dart';
import '../../common/componants/qr_view_dialog.dart';
import '../../common/screens/notification_screen.dart';
import '../../treatment_history/screens/treatment_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData themeData;


  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<PatientProvider>(
      builder: (BuildContext context, PatientProvider patientProvider, Widget? child) {
        PatientModel? currentPatient = patientProvider.getCurrentPatient();

        MyPrint.printOnConsole("currentPatient?.profilePicture:${currentPatient?.profilePicture}");

        return Container(
          color: themeData.backgroundColor,
          child: SafeArea(
            child: Scaffold(
              body: ListView(
                padding: FxSpacing.fromLTRB(24, 52, 24, 24),
                children: [
                  const SizedBox(height: 10,),
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(120),),
                      child: (currentPatient?.profilePicture).checkNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: currentPatient!.profilePicture,
                            placeholder: (_, __) => const LoadingWidget(),
                          )
                        : Image.asset('assets/extra/viren.jpg',width: 100,height: 100,fit: BoxFit.cover,),

                    ),
                  ),
                  FxSpacing.height(15),
                  //CommonText(text: "${currentPatient?.id ?? ""}",fontSize: 22,fontWeight: FontWeight.w600,textAlign: TextAlign.center),
                  currentPatient!.name.isNotEmpty ? FxSpacing.height(4) : const SizedBox.shrink(),
                  currentPatient.name.isNotEmpty ? CommonText(text: currentPatient.name,fontSize: 22,fontWeight: FontWeight.w600,textAlign: TextAlign.center):const SizedBox.shrink(),
                  FxSpacing.height(4),
                  getTreatmentActiveWidget(isActive: true),
                  FxSpacing.height(20),
                  CommonText(text: "General",fontSize: 15,),
                  FxSpacing.height(24),
                  _buildSingleRow(title: 'Edit Profile Details', icon: FeatherIcons.edit2),
                  FxSpacing.height(8),
                  const Divider(),
                  FxSpacing.height(8),
                  _buildSingleRow(title: 'My Treatment History', icon: FeatherIcons.list,
                    onTap: (){
                      Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,TreatmentHistoryScreen.routeName);
                    },
                  ),
                  FxSpacing.height(8),
                  const Divider(),
                  FxSpacing.height(8),
                  _buildSingleRow(title: 'My QR Code', icon: Icons.qr_code_2,
                    onTap: (){
                      showDialog(context: context, builder: (context){
                        return QRCodeView(userId: currentPatient.id,);
                      });
                    },
                  ),
                  FxSpacing.height(8),
                  const Divider(),
                  FxSpacing.height(8),
                  _buildSingleRow(title: 'Notifications', icon: FeatherIcons.bell,
                  onTap: (){
                    Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,NotificationScreen.routeName);
                  }
                  ),
                  FxSpacing.height(8),
                  const Divider(),
                  FxSpacing.height(8),
                  _buildSingleRow(title: 'About Us', icon: FeatherIcons.info,
                      onTap: (){
                        Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!,AboutUsScreen.routeName);
                      }
                  ),
                  FxSpacing.height(8),
                  const Divider(),
                  FxSpacing.height(8),
                  _buildSingleRow(title: 'Logout', icon: FeatherIcons.logOut, onTap: () {
                    showDialog(context: context, builder: (context){
                      return CommonDialog(text: "Are you sure you want to log out ?",
                        rightText: "Logout",
                        leftText: "No",
                        rightOnTap: (){
                            AuthenticationController().logout(context: context, isNavigateToLogin: true);
                        },
                      );
                    });
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSingleRow({String? title, IconData? icon,Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          FxContainer(
            paddingAll: 8,
            borderRadiusAll: 4,
            color: Styles.cardColor,
            child: Icon(
              icon,
              color: themeData.primaryColor,
              size: 20,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: CommonText(text: title ?? "General",fontSize: 13,fontWeight: FontWeight.w500,),

          ),
          FxSpacing.width(16),
          Icon(
            Icons.keyboard_arrow_right,
            color: Colors.black.withOpacity(.5),
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget getTreatmentActiveWidget({bool isActive=false}){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FxContainer.rounded(
          color: isActive?Colors.green:Colors.grey,
          height: 6,
          width: 6,
          child: Container(),
        ),
        const SizedBox(width: 6,),
        CommonText(text: isActive?"Treatment Active":"Treatment Not Active",fontSize: 12,color: isActive?Colors.green:Colors.grey,),

      ],
    );

  }

}
