import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'textstyle.dart';

Widget btnItem(
    {required String textBtn,
    required IconData icon,
    required void Function()? onTap,
    required BuildContext context}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Icon(
          icon,
          size: 7.w,
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text(
          textBtn,
          textAlign: TextAlign.center,
          style: getTextAlertSub(context),
        )
      ],
    ),
  );
}
