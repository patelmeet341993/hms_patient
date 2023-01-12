import 'package:flutter/material.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';

import '../../common/componants/common_topbar.dart';

class AdmitDetailsScreen extends StatefulWidget {
  static const String routeName = "/AdmitDetailsScreen";
  VisitModel? visitModel;
  AdmitDetailsScreen({Key? key, this.visitModel}) : super(key: key);

  @override
  _AdmitDetailsScreenState createState() => _AdmitDetailsScreenState();
}

class _AdmitDetailsScreenState extends State<AdmitDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            child: Column(
              children: [
                CommonTopBar(title: "Admit Details",),

              ],
            ),
          )
      ),
    );
  }
}
