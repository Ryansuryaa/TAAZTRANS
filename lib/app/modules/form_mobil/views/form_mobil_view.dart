import 'dart:io';

import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:az_travel/app/utils/textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/theme.dart';
import '../controllers/form_mobil_controller.dart';

class FormMobilView extends GetView<FormMobilController> {
  const FormMobilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FormMobilController());
    final updateStatus = Get.arguments[0];
    final updateData =
        updateStatus == 'update' ? Get.arguments[1] as DataMobilModel : null;
    String? fotoMobil = '';

    var defaultImage =
        "https://ui-avatars.com/api/?background=fff38a&color=5175c0&font-size=0.33&size=256";

    if (updateStatus == 'update') {
      controller.namaMobilC.text = updateData!.namaMobil!;
      controller.merekC.text = updateData.merek!;
      controller.noPolisiC.text = updateData.noPolisi!;
      controller.hargaPerHariC.text = updateData.hargaPerHari!;
      controller.tipeBahanBakarC.text = updateData.tipeBahanBakar!;
      controller.tahunC.text = updateData.tahun!;
      controller.deskripsiC.text = updateData.deskripsi!;
      fotoMobil = updateData.fotoMobil!;
      if (kDebugMode) {
        print(' FOto MOBIL GES $fotoMobil');
      }
    } else if (updateStatus == 'create') {
      controller.namaMobilC.text = '';
      controller.merekC.text = '';
      controller.noPolisiC.text = '';
      controller.hargaPerHariC.text = '';
      controller.tipeBahanBakarC.text = '';
      controller.tahunC.text = '';
      controller.deskripsiC.text = '';
      fotoMobil = '';
    }

    return PopScope(
      onPopInvoked: (didPop) {
        controller.image = null;
        if (kDebugMode) {
          print('back');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${updateStatus == 'update' ? 'Ubah' : 'Tambah'} Data Mobil"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 6.w, left: 6.w, top: 2.h),
                child: Column(
                  children: [
                    formInput(
                      key: controller.namaMobilFormKey.value,
                      textEditingController: controller.namaMobilC,
                      hintText: 'Nama Mobil',
                      iconPrefix: PhosphorIconsBold.car,
                      keyboardType: TextInputType.name,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    formInput(
                      key: controller.merekFormKey.value,
                      textEditingController: controller.merekC,
                      hintText: 'Merek',
                      iconPrefix: PhosphorIconsBold.brandy,
                      keyboardType: TextInputType.name,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    formInput(
                      key: controller.noPolisiFormKey.value,
                      textEditingController: controller.noPolisiC,
                      hintText: 'Nomor Polisi',
                      iconPrefix: PhosphorIconsBold.numberCircleFour,
                      keyboardType: TextInputType.text,
                      maxLength: 12,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    formInput(
                      key: controller.hargaPerHariFormKey.value,
                      textEditingController: controller.hargaPerHariC,
                      hintText: 'Harga per Hari',
                      iconPrefix: PhosphorIconsBold.currencyDollarSimple,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      validator: controller.normalValidator,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      isDatePicker: false,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    formInput(
                      key: controller.tipeBahanBakarFormKey.value,
                      textEditingController: controller.tipeBahanBakarC,
                      hintText: 'Tipe Bahan Bakar',
                      iconPrefix: PhosphorIconsBold.engine,
                      keyboardType: TextInputType.name,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    formInput(
                      key: controller.tahunFormKey.value,
                      textEditingController: controller.tahunC,
                      hintText: 'Tahun Mobil',
                      iconPrefix: PhosphorIconsBold.calendar,
                      keyboardType: TextInputType.number,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    formInputMultiLine(
                      key: controller.deskripsiFormKey.value,
                      textEditingController: controller.deskripsiC,
                      hintText: 'Deskripsi Mobil',
                      iconPrefix: PhosphorIconsBold.carProfile,
                      validator: controller.normalValidator,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    GetBuilder<FormMobilController>(builder: (c) {
                      if (updateStatus != 'update') {
                        return Container(
                          height: c.image != null ? 50.h : 20.h,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 1.5.h, left: 3.5.w, right: 3.5.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          PhosphorIconsBold.car,
                                          size: 18,
                                          color: Theme.of(Get.context!)
                                              .iconTheme
                                              .color,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          'Foto Mobil',
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: c.image != null ? true : false,
                                      child: InkWell(
                                        onTap: () {
                                          controller.pickImage();
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            color: yellow1_F9B401,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 5.w, left: 5.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                const Text('Ubah gambar'),
                                                Icon(
                                                  PhosphorIconsBold.camera,
                                                  size: 25,
                                                  color: Theme.of(Get.context!)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: c.image != null ? 2.5.h : 3.8.h,
                                ),
                                if (c.image == null)
                                  InkWell(
                                    onTap: () {
                                      controller.pickImage();
                                    },
                                    child: Container(
                                      width: 60.w,
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        color: yellow1_F9B401,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.w, left: 5.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text('Ambil dari galeri'),
                                            Icon(
                                              PhosphorIconsBold.camera,
                                              size: 25,
                                              color: Theme.of(Get.context!)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Image.file(
                                        File(c.image!.path),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 1.5.h, left: 3.5.w, right: 3.5.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          PhosphorIconsBold.car,
                                          size: 18,
                                          color: Theme.of(Get.context!)
                                              .iconTheme
                                              .color,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          'Foto Mobil',
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: InkWell(
                                        onTap: () {
                                          controller.pickImage();
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            color: yellow1_F9B401,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 5.w, left: 5.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                const Text('Ubah gambar'),
                                                Icon(
                                                  PhosphorIconsBold.camera,
                                                  size: 25,
                                                  color: Theme.of(Get.context!)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                if (c.image != null)
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Image.file(
                                        File(c.image!.path),
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Image.network(
                                        fotoMobil! != ''
                                            ? fotoMobil
                                            : defaultImage,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              InkWell(
                onTap: () {
                  if (controller.namaMobilFormKey.value.currentState!
                          .validate() &&
                      controller.merekFormKey.value.currentState!.validate() &&
                      controller.noPolisiFormKey.value.currentState!
                          .validate() &&
                      controller.hargaPerHariFormKey.value.currentState!
                          .validate() &&
                      controller.tipeBahanBakarFormKey.value.currentState!
                          .validate() &&
                      controller.tahunFormKey.value.currentState!.validate()) {
                    if (updateStatus == 'update') {
                      controller.editDataMobil(
                        updateData!.id!,
                        controller.namaMobilC.text,
                        controller.merekC.text,
                        controller.noPolisiC.text,
                        controller.hargaPerHariC.text,
                        controller.tipeBahanBakarC.text,
                        controller.tahunC.text,
                        controller.deskripsiC.text,
                      );
                    } else {
                      controller.tambahDataMobil(
                        controller.namaMobilC.text,
                        controller.merekC.text,
                        controller.noPolisiC.text,
                        controller.hargaPerHariC.text,
                        controller.tipeBahanBakarC.text,
                        controller.tahunC.text,
                        controller.deskripsiC.text,
                      );
                    }
                  }
                },
                child: Container(
                  width: 35.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: yellow1_F9B401,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w, left: 5.w),
                    child: const Center(child: Text('Kirim')),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
