import 'package:az_travel/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/theme.dart';
import '../controllers/data_pelanggan_controller.dart';
import 'package:az_travel/app/modules/detail_pelanggan/controllers/detail_pelanggan_controller.dart';
import 'package:az_travel/app/data/models/usermodel.dart';

class DataPelangganView extends GetView<DataPelangganController> {
  const DataPelangganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DataPelangganController());

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            right: 2.5.w,
            left: 2.5.w,
          ),
          child: const Text('Data Pelanggan'),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder(
          stream: c.firestoreDataPelangganList,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final pelangganList = snap.data!;

            if (pelangganList.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('Data kosong.'),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(top: 0.1.h),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: pelangganList.length,
              itemBuilder: (context, index) {
                final dataPelanggan = pelangganList[index];
                var defaultImage =
                    "https://ui-avatars.com/api/?background=B60000&color=FFF6F6&name=${dataPelanggan.username}&font-size=0.33&size=256";

                return Padding(
                  padding: EdgeInsets.only(bottom: 2.h, right: 5.w, left: 5.w),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.DETAIL_PELANGGAN,
                          arguments: dataPelanggan);
                    },
                    child: Container(
                      height: 15.h,
                      decoration: BoxDecoration(
                        color: black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${dataPelanggan.username}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 8.5.h,
                                  child: Image.network(
                                    dataPelanggan.photoUrl! == ''
                                        ? defaultImage
                                        : dataPelanggan.photoUrl!,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
