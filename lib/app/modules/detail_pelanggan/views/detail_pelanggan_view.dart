import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../controllers/detail_pelanggan_controller.dart';

class DetailPelangganView extends GetView<DetailPelangganController> {
  const DetailPelangganView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dataPelanggan = Get.arguments as UserModel;
    // Dekripsi data sebelum menampilkan
    String namaLengkapDecrypted =
        controller.dekripsiData(dataPelanggan.namaLengkap ?? '');
    String noKTPDecrypted = controller.dekripsiData(dataPelanggan.noKTP ?? '');
    String alamatDecrypted =
        controller.dekripsiData(dataPelanggan.alamat ?? '');
    String noTelpDecrypted =
        controller.dekripsiData(dataPelanggan.nomorTelepon ?? '');

    // Sembunyikan bagian pertama dari no KTP dan alamat
    String hiddenNoKTP = controller.hidePartialData(noKTPDecrypted);
    String hiddenAlamat = controller.hidePartialData(alamatDecrypted);

    var defaultImage =
        "https://ui-avatars.com/api/?background=B60000&color=FFF6F6&name=${dataPelanggan.username}&font-size=0.33&size=256";
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
          body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, rect.top, 0, rect.bottom));
                  },
                  blendMode: BlendMode.dstOut,
                  child: Image.network(
                    dataPelanggan.photoUrl! == ''
                        ? defaultImage
                        : dataPelanggan.photoUrl!,
                    width: 100.w,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, top: 8.h, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          PhosphorIconsBold.arrowLeft,
                          size: 6.w,
                        ),
                      ),
                      Text(
                        'Detail Pelanggan',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 16.sp,
                                  height: 1,
                                ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, top: 2.h, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataPelanggan.username!,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 16.sp,
                                ),
                      ),
                      Text(
                        'Nama Lengkap : ${namaLengkapDecrypted == '' ? '--' : namaLengkapDecrypted}',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 12.sp,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Row(
                    children: [
                      Icon(PhosphorIconsBold.cardholder),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Email : ${dataPelanggan.email == '' ? '--' : dataPelanggan.email}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12.sp,
                                ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(PhosphorIconsBold.identificationCard),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'No KTP : ${hiddenNoKTP == '' ? '--' : hiddenNoKTP}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12.sp,
                                ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(PhosphorIconsBold.phoneCall),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'No Telepon : ${noTelpDecrypted == '' ? '--' : noTelpDecrypted}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12.sp,
                                ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(PhosphorIconsBold.houseLine),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Alamat : ${alamatDecrypted == '' ? '--' : alamatDecrypted}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12.sp,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
