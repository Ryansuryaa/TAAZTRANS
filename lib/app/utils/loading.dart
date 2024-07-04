import 'package:az_travel/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: light,
          body: Center(
              child: Lottie.asset('assets/lottie/loading_aztravel.json',
                  height: 135))),
    );
  }
}

Future<void> simulateDelay() async {
  await Future.delayed(const Duration(milliseconds: 1500));
}
