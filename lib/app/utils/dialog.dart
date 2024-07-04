import 'package:az_travel/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

Widget dialogAlertBtn(
    {required VoidCallback onPressed,
    required String animationLink,
    required double widthBtn,
    required String textBtn,
    required String text,
    required String? textSub,
    required TextStyle textAlert,
    required TextStyle? textAlertSub,
    required TextStyle textAlertBtn}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: light,
    child: SizedBox(
      height: 30.h,
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 10.h,
            decoration: BoxDecoration(
                border: Border.all(color: blue_0C134F, width: 2.0),
                borderRadius: BorderRadius.circular(12)),
            child: Lottie.asset(
              animationLink,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textAlert,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            textSub!,
            textAlign: TextAlign.center,
            style: textAlertSub,
          ),
          SizedBox(
            height: 2.h,
          ),
          InkWell(
            onTap: onPressed,
            child: Container(
              width: 25.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: yellow1_F9B401,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 5.w, left: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      textBtn,
                      style: textAlertBtn,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget dialogAlertOnly({
  required String animationLink,
  required String text,
  required String? textSub,
  required TextStyle textAlert,
  required TextStyle? textAlertSub,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: light,
    child: SizedBox(
      height: 30.h,
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 10.h,
            decoration: BoxDecoration(
                border: Border.all(color: blue_0C134F, width: 2.0),
                borderRadius: BorderRadius.circular(12)),
            child: Lottie.asset(
              animationLink,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textAlert,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            textSub!,
            textAlign: TextAlign.center,
            style: textAlertSub,
          ),
        ],
      ),
    ),
  );
}
