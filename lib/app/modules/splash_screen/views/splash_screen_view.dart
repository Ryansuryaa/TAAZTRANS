import 'package:az_travel/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: blue_0C134F,
              body: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/Welcome.svg',
                    width: 100.w,
                  ),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/Logo.svg',
                      width: 35.w,
                    ),
                  ),
                ],
              )),
        ));
  }
}
