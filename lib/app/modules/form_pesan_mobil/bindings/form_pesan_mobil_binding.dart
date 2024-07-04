import 'package:get/get.dart';

import '../controllers/form_pesan_mobil_controller.dart';

class FormPesanMobilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormPesanMobilController>(
      () => FormPesanMobilController(),
    );
  }
}
