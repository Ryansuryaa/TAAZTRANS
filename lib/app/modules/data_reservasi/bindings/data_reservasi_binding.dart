import 'package:get/get.dart';

import '../controllers/data_reservasi_controller.dart';

class DataReservasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataReservasiController>(
      () => DataReservasiController(),
    );
  }
}
