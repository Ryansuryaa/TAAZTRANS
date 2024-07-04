import 'package:az_travel/app/theme/theme.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:az_travel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import 'app/controller/auth_controller.dart';
import 'app/modules/splash_screen/views/splash_screen_view.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/textstyle.dart';
import 'app/utils/dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null)
      .then((value) => runApp(AZTravelApp()));
}

class AZTravelApp extends StatelessWidget {
  AZTravelApp({
    Key? key,
  }) : super(key: key);

  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init,
        builder: (context, snap) {
          if (snap.hasError) {
            return Scaffold(
              backgroundColor: error.withOpacity(0.5),
              body: dialogAlertOnly(
                animationLink: 'assets/lottie/warning_aztravel.json',
                text: "Terjadi Kesalahan!",
                textSub: "Hubungi Developer",
                textAlert: getTextAlert(context),
                textAlertSub: getTextAlertSub(context),
              ),
            );
          }
          if (snap.connectionState == ConnectionState.done) {
            return Sizer(builder: (context, orientation, deviceType) {
              return FutureBuilder(
                  future: simulateDelay(),
                  builder: (context, snap) {
                    var authC = Get.put(AuthController());
                    if (snap.connectionState == ConnectionState.done) {
                      return Obx(
                        () => GetMaterialApp(
                          title: "AZ Travel",
                          debugShowCheckedModeBanner: false,
                          theme: AZTravelTheme.lightTheme,
                          initialRoute:
                              authC.isAuth.isTrue ? Routes.HOME : Routes.LOGIN,
                          getPages: AppPages.routes,
                        ),
                      );
                    } else {
                      return FutureBuilder(
                          future: authC.firstInitialized(),
                          builder: (context, snap) {
                            return const SplashScreenView();
                          });
                    }
                  });
            });
          }
          return Center(
              child: Lottie.asset('assets/lottie/loading_aztravel.json',
                  height: 145));
        });
  }
}
