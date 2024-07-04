import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/welcome_screen_controller.dart';

class WelcomeScreenView extends GetView<WelcomeScreenController> {
  const WelcomeScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Text(
          'Cepat, Mudah, Solusi Keluarga',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
