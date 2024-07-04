import 'package:az_travel/app/controller/auth_controller.dart';
import 'package:az_travel/app/modules/dashboard_user/views/dashboard_user_view.dart';
import 'package:az_travel/app/modules/data_pelanggan/views/data_pelanggan_view.dart';
import 'package:az_travel/app/modules/data_reservasi/views/data_reservasi_view.dart';
import 'package:az_travel/app/modules/profile_user/views/profile_user_view.dart';
import 'package:az_travel/app/utils/dialog.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../data/models/usermodel.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/textstyle.dart';
import '../../../theme/theme.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var authC = Get.put(AuthController());

    return FutureBuilder(
        future: simulateDelay(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          return StreamBuilder<UserModel>(
              stream: authC.getUserData(),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data == null) {
                    return Scaffold(
                      backgroundColor: error.withOpacity(0.5),
                      body: dialogAlertBtn(
                        onPressed: () async {
                          authC.logout();
                        },
                        animationLink: 'assets/lottie/warning_aztravel.json',
                        widthBtn: 26.w,
                        textBtn: "OK",
                        text: "Terjadi Kesalahan!",
                        textSub: "Silahkan Login Ulang",
                        textAlert: getTextAlert(context),
                        textAlertSub: getTextAlertSub(context),
                        textAlertBtn: getTextAlertBtn(context),
                      ),
                    );
                  } else {
                    var data = snap.data!;
                    String? roles = data.roles;
                    if (kDebugMode) {
                      print("BISA MASUK");
                      print("ROLE : $roles");
                    }
                    if (roles == null || roles == '') {
                      return Scaffold(
                        backgroundColor: error.withOpacity(0.5),
                        body: dialogAlertBtn(
                          onPressed: () async {
                            authC.logout();
                          },
                          animationLink: 'assets/lottie/warning_aztravel.json',
                          widthBtn: 26.w,
                          textBtn: "OK",
                          text: "Terjadi Kesalahan!",
                          textSub: "Silahkan Login Ulang",
                          textAlert: getTextAlert(context),
                          textAlertSub: getTextAlertSub(context),
                          textAlertBtn: getTextAlertBtn(context),
                        ),
                      );
                    } else {
                      if (roles == 'admin') {
                        var pagesAdmin = <Widget>[
                          const DashboardView(),
                          const DataReservasiView(),
                          const DataPelangganView(),
                          const ProfileView(),
                        ];
                        return Scaffold(
                          body: Obx(
                              () => pagesAdmin[controller.currentIndex.value]),
                          bottomNavigationBar: Container(
                            decoration: BoxDecoration(
                              color: light,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 2.w, left: 2.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  navBarItem(context, PhosphorIconsLight.house,
                                      'Beranda', 0, controller.cAniDashboard),
                                  navBarItem(
                                      context,
                                      PhosphorIconsLight.clockCounterClockwise,
                                      'Reservasi',
                                      1,
                                      controller.cAniHistory),
                                  navBarItem(
                                      context,
                                      PhosphorIconsLight.userList,
                                      'Pengguna',
                                      2,
                                      controller.cAniUsers),
                                  navBarItem(context, PhosphorIconsLight.user,
                                      'Profil', 3, controller.cAniProfile),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (roles == 'user') {
                        var pagesUser = <Widget>[
                          const DashboardUserView(),
                          const ProfileUserView(),
                        ];
                        return Scaffold(
                          body: Obx(
                              () => pagesUser[controller.currentIndex2.value]),
                          bottomNavigationBar: Container(
                            decoration: BoxDecoration(
                              color: light,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 2.w, left: 2.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  navBarItem2(
                                      context,
                                      PhosphorIconsLight.house,
                                      'Beranda',
                                      0,
                                      controller.cAniDashboardUser),
                                  navBarItem2(context, PhosphorIconsLight.user,
                                      'Profil', 1, controller.cAniProfileUser),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Scaffold(
                          backgroundColor: error.withOpacity(0.5),
                          body: dialogAlertBtn(
                            onPressed: () async {
                              authC.logout();
                            },
                            animationLink:
                                'assets/lottie/warning_aztravel.json',
                            widthBtn: 26.w,
                            textBtn: "OK",
                            text: "Terjadi Kesalahan!",
                            textSub: "Silahkan Login Ulang",
                            textAlert: getTextAlert(context),
                            textAlertSub: getTextAlertSub(context),
                            textAlertBtn: getTextAlertBtn(context),
                          ),
                        );
                      }
                    }
                  }
                } else {
                  return const LoadingView();
                }
              });
        });
  }

  Widget navBarItem(BuildContext context, IconData icon, String text, int index,
      AnimationController animationController) {
    final controller = Get.put(HomeController());
    return GestureDetector(
        onTap: () {
          animationController.forward();
          Future.delayed(const Duration(milliseconds: 70), () {
            animationController.reverse();
          });
          Future.delayed(const Duration(milliseconds: 120)).then((value) {
            controller.changePage(index);
          });
        },
        onLongPressDown: (details) {
          animationController.forward();
        },
        onLongPressEnd: (details) async {
          await animationController.forward();
          await animationController.reverse();
          await Get.offAllNamed(Routes.HOME);
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return ScaleTransition(
              scale: Tween(begin: 1.0, end: 0.90).animate(animationController),
              child: child,
            );
          },
          child: SizedBox(
            height: 81,
            child: Obx(
              () => Padding(
                padding: EdgeInsets.only(top: 1.8.h),
                child: SizedBox(
                  width: 20.w,
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 8.w,
                        color: (index == controller.currentIndex.value ||
                                Get.currentRoute == Routes.DASHBOARD)
                            ? black
                            : black.withOpacity(0.4),
                      ),
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: 9.sp,
                              color: (index == controller.currentIndex.value ||
                                      Get.currentRoute == Routes.DASHBOARD)
                                  ? black
                                  : black.withOpacity(0.4),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget navBarItem2(BuildContext context, IconData icon, String text,
      int index, AnimationController animationController) {
    final controller = Get.put(HomeController());
    return GestureDetector(
        onTap: () {
          animationController.forward();
          Future.delayed(const Duration(milliseconds: 70), () {
            animationController.reverse();
          });
          Future.delayed(const Duration(milliseconds: 120)).then((value) {
            controller.changePage2(index);
          });
        },
        onLongPressDown: (details) {
          animationController.forward();
        },
        onLongPressEnd: (details) async {
          await animationController.forward();
          await animationController.reverse();
          await Get.offAllNamed(Routes.HOME);
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return ScaleTransition(
              scale: Tween(begin: 1.0, end: 0.90).animate(animationController),
              child: child,
            );
          },
          child: SizedBox(
            height: 81,
            child: Obx(
              () => Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: SizedBox(
                  width: 20.w,
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 8.w,
                        color: (index == controller.currentIndex2.value ||
                                Get.currentRoute == Routes.DASHBOARD_USER)
                            ? black
                            : black.withOpacity(0.4),
                      ),
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: 9.sp,
                              color: (index == controller.currentIndex2.value ||
                                      Get.currentRoute == Routes.DASHBOARD_USER)
                                  ? black
                                  : black.withOpacity(0.4),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
