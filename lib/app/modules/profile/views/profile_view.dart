import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Admin'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Halaman Profile Admin. ',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                authC.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
