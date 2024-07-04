import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Widget buttonWithIcon(
    {Function()? onTap,
    void Function(LongPressEndDetails)? onLongPressEnd,
    required double elevation,
    required Color btnColor,
    required Widget icon,
    required String text,
    double? width,
    required Color textColor,
    required AnimationController animationController}) {
  final context = Get.context!;
  return AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      return ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(animationController),
        child: child,
      );
    },
    child: GestureDetector(
      onLongPressDown: (details) {
        animationController.forward();
      },
      onLongPressEnd: onLongPressEnd,
      child: Material(
        elevation: elevation,
        color: btnColor,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Container(
            width: width ?? 75.w,
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 10.sp, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buttonNoIcon(
    {Function()? onTap,
    void Function(LongPressEndDetails)? onLongPressEnd,
    required double elevation,
    required Color btnColor,
    required String text,
    required Color textColor,
    double? width,
    required AnimationController animationController}) {
  final context = Get.context!;
  return AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      return ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(animationController),
        child: child,
      );
    },
    child: GestureDetector(
      onLongPressDown: (details) {
        animationController.forward();
      },
      onLongPressEnd: onLongPressEnd,
      child: Material(
        elevation: elevation,
        color: btnColor,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Container(
            width: width ?? 75.w,
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontSize: 10.sp, color: textColor),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
