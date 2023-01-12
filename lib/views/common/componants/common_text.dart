import 'package:flutter/material.dart';


class CommonText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color? color;
  TextAlign? textAlign;
  int? maxLines;
  TextOverflow? textOverFlow;
  TextDecoration? textDecoration;
  double height;


  CommonText(
      {required this.text,
        this.fontSize = 15,
        this.fontWeight = FontWeight.normal,
        this.color,
        this.textAlign,
        this.maxLines,
        this.textDecoration,
        this.textOverFlow,
        this.height = 1
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
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
