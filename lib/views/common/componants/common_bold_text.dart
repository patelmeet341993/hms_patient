import 'package:flutter/material.dart';

import '../../../configs/app_theme.dart';

class CommonBoldText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color? color;
  TextAlign? textAlign;
  int? maxLines;
  TextOverflow? textOverFlow;
  TextDecoration? textDecoration;
  double? height;


  CommonBoldText(
      {required this.text,
        this.fontSize = 15,
        this.fontWeight = FontWeight.bold,
        this.color,
        this.textAlign,
        this.maxLines,
        this.textDecoration,
        this.textOverFlow,
        this.height
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,

      style: TextStyle(
        height: height,
        letterSpacing: 0.4,
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}




class CommonExtraBoldText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color? color;
  TextAlign? textAlign;
  int? maxLines;
  TextOverflow? textOverFlow;
  double? height;


  CommonExtraBoldText(
      {required this.text,
        this.fontSize = 15,
        this.fontWeight =  FontWeight.w800,
        this.color,
        this.textAlign,
        this.maxLines,
        this.textOverFlow,
        this.height
      });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,
      style: AppTheme.getTextStyle(
        themeData.textTheme.headline5!,
        height: height,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),);

  }
}

