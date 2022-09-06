import 'package:flutter/material.dart';

class QRCodeView extends StatelessWidget {
  const QRCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width*.5,
        height: MediaQuery.of(context).size.height*.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Container(),
      ),
    );
  }
}






