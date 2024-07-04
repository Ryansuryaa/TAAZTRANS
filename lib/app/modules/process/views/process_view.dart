import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/process_controller.dart';

class ProcessView extends GetView<ProcessController> {
  const ProcessView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProcessView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProcessView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
