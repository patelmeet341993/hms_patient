import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/componants/common_bold_text.dart';

class MyExpansionTile extends StatelessWidget {
  List<Widget> children = [];
  bool initiallyExpanded = true;
  String title;
  double fontSize;
  double iconSize;
  EdgeInsets contentPadding;
  double titleGap = 0;
  MyExpansionTile({this.children = const [],
    this.initiallyExpanded = true,required this.title,
    this.fontSize=17,
    this.iconSize = 24,
    this.contentPadding = EdgeInsets.zero,
    this.titleGap = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        iconTheme: IconThemeData(
           size: iconSize,
        ),
        listTileTheme: ListTileThemeData(
          horizontalTitleGap: titleGap,
          minLeadingWidth: 25,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.black,
        collapsedTextColor: Colors.black,
        tilePadding: EdgeInsets.zero,
        childrenPadding:contentPadding,
        iconColor: Colors.black,
        textColor: Colors.black,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        initiallyExpanded: initiallyExpanded,
        title: CommonExtraBoldText(text: title,fontSize: fontSize,),
        controlAffinity: ListTileControlAffinity.leading,
        expandedAlignment: Alignment.center,
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
        children: children,

      ),
    );
  }
}
