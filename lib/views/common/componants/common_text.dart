import 'package:flutter/material.dart';


class CommonText extends StatelessWidget {
  String text;
  double fontSize;
  double height;
  FontWeight fontWeight;
  Color? color;
  TextAlign? textAlign;
  int? maxLines;
  TextOverflow? textOverFlow;
  TextDecoration? textDecoration;


  CommonText(
      {required this.text,
        this.fontSize = 15,
        this.fontWeight = FontWeight.normal,
        this.color,
        this.textAlign,
        this.maxLines,
        this.textDecoration,
        this.textOverFlow,
        this.height = 1.1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,
      style: TextStyle(
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
