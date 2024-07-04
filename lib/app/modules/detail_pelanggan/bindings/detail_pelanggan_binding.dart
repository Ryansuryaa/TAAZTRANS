import 'package:get/get.dart';

import '../controllers/detail_pelanggan_controller.dart';

class DetailPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPelangganController>(
      () => DetailPelangganController(),
    );
  }
}
