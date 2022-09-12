import 'package:flutter/material.dart';


class CommonBoldText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color? color;
  TextAlign? textAlign;
  int? maxLines;
  TextOverflow? textOverFlow;
  TextDecoration? textDecoration;


  CommonBoldText(
      {required this.text,
        this.fontSize = 15,
        this.fontWeight = FontWeight.bold,
        this.color,
        this.textAlign,
        this.maxLines,
        this.textDecoration,
        this.textOverFlow,});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,
      style: TextStyle(
        letterSpacing: 0.4,
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
