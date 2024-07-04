import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  var currentIndex = 0.obs;
  changePage(int i) {
    currentIndex.value = i;
  }

  var currentIndex2 = 0.obs;
  changePage2(int i) {
    currentIndex2.value = i;
  }

  late final AnimationController cAniDashboard;
  bool isDashboardClicked = false;

  late final AnimationController cAniHistory;
  bool isHistoryClicked = false;

  late final AnimationController cAniUsers;
  bool isUsersClicked = false;

  late final AnimationController cAniProfile;
  bool isProfileClicked = false;

  late final AnimationController cAniDashboardUser;
  bool isDashboardUserClicked = false;

  late final AnimationController cAniProfileUser;
  bool isProfileUserClicked = false;

  var authC = Get.put(AuthController());
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();

    cAniDashboard = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniHistory = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniUsers = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniProfile = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniDashboardUser = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniProfileUser = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
  }
}
