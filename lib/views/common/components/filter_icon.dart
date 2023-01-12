import 'package:flutter/material.dart';

import '../../../packages/flux/widgets/container/container.dart';


class FilterIcon extends StatelessWidget {
  Function()? onTap;
  FilterIcon({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FxContainer(
        paddingAll: 7,
        borderRadiusAll: 4,
        color: Colors.white,
        child: Image.asset(
         'assets/icons/filter.png',
          height: 15,
         ),
      ),
    );
  }
}
