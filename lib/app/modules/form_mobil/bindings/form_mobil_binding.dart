import 'package:get/get.dart';

import '../controllers/form_mobil_controller.dart';

class FormMobilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormMobilController>(
      () => FormMobilController(),
    );
  }
}
