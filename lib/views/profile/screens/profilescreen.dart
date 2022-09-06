import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:patient/views/common/componants/common_text.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/container/container.dart';


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
    return Container(
      color: themeData.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: FxSpacing.fromLTRB(24, 52, 24, 24),
            children: [
              SizedBox(height: 10,),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(120),
                  ),
                  child:Image.asset('assets/extra/viren.jpg',width: 100,height: 100,fit: BoxFit.cover,),

                ),
              ),
              FxSpacing.height(24),
              CommonText(text: "Viren Desai",fontSize: 22,fontWeight: FontWeight.w600,textAlign: TextAlign.center),
              FxSpacing.height(4),
              getTreatmentActiveWidget(isActive: true),
              FxSpacing.height(24),
              CommonText(text: "General",fontSize: 15,),
              FxSpacing.height(24),
              _buildSingleRow(
                  title: 'Edit Profile Details', icon: FeatherIcons.edit2),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'My Treatment History', icon: FeatherIcons.list),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'My QR Code', icon: Icons.qr_code_2),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'Notifications', icon: FeatherIcons.bell),
              FxSpacing.height(8),
              Divider(),
              FxSpacing.height(8),
              _buildSingleRow(title: 'Logout', icon: FeatherIcons.logOut),
            ],
          ),
        ),
      ),
    );


  }


  Widget _buildSingleRow({String? title, IconData? icon}) {
    return Row(
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
        SizedBox(width: 6,),
        CommonText(text: isActive?"Treatment Active":"Treatment Not Active",fontSize: 12,color: isActive?Colors.green:Colors.grey,),

      ],
    );

  }

}
