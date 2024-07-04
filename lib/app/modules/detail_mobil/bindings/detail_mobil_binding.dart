import 'package:get/get.dart';

import '../controllers/detail_mobil_controller.dart';

class DetailMobilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMobilController>(
      () => DetailMobilController(),
    );
  }
}
