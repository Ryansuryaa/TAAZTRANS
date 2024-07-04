import 'package:get/get.dart';

import '../controllers/data_pelanggan_controller.dart';

class DataPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataPelangganController>(
      () => DataPelangganController(),
    );
  }
}
