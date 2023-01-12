import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/widgets/container/container.dart';
import 'common_bold_text.dart';


class CommonTopBar extends StatelessWidget {
  String title;
  bool isNotification = true;
   CommonTopBar({required this.title,this.isNotification = true});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap:(){
                    Navigator.pop(context);
                  },
                  child: FxContainer(
                    paddingAll: 6,
                    borderRadiusAll: 4,
                    color: Colors.transparent,
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(child: CommonBoldText(text: title,textAlign: TextAlign.center,fontSize: 20,)),
                isNotification
                    ? FxContainer(
                  paddingAll: 7,
                  borderRadiusAll: 4,
                  color: Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.none,

                    children: [
                      FxContainer(
                        paddingAll: 0,
                        borderRadiusAll: 4,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.notifications,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: FxContainer.rounded(
                          paddingAll: 4,
                          color: Colors.red.withOpacity(.9),
                          child: Container(),
                        ),
                      )
                    ],
                  ),
                )
                    :  FxContainer(
                  paddingAll: 6,
                  borderRadiusAll: 4,
                  color: Colors.transparent,
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.transparent,
                  ),
                ),

              ],
            )
        ),
        Divider(
          color: Colors.grey.withOpacity(.2),
          thickness: 1.5,
          height: 2,
        )
      ],
    );
  }
}
