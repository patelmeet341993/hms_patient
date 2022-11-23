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


  CommonText(
      {required this.text,
        this.fontSize = 15,
        this.fontWeight = FontWeight.normal,
        this.color,
        this.textAlign,
        this.maxLines,
        this.textDecoration,
        this.textOverFlow,
        });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,
      style: TextStyle(
        //height: 1,
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
