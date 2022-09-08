import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/widgets/container/container.dart';
import 'common_bold_text.dart';


class CommonTopBar extends StatelessWidget {
  String title;
   CommonTopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FxContainer(
              paddingAll: 6,
              borderRadiusAll: 4,
              color: Styles.cardColor,
              child: InkWell(
                onTap:(){
                  Navigator.pop(context);
                },
                child: Icon(
                  FeatherIcons.chevronLeft,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(child: CommonBoldText(text: title,textAlign: TextAlign.center,fontSize: 20,)),
            FxContainer(
              paddingAll: 6,
              borderRadiusAll: 4,
              color: Colors.transparent,
              child: Icon(
                FeatherIcons.chevronLeft,
                size: 22,
                color: Colors.transparent,
              ),
            ),

          ],
        )
    );
  }
}
