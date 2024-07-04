import 'package:az_travel/app/controller/auth_controller.dart';
import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:az_travel/app/theme/theme.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:az_travel/app/utils/textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../data/models/datamobilmodel.dart';
import '../../../theme/textstyle.dart';
import '../../../utils/dialog.dart';
import '../controllers/form_pesan_mobil_controller.dart';

class FormPesanMobilView extends GetView<FormPesanMobilController> {
  const FormPesanMobilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());
    final c = Get.put(FormPesanMobilController());
    final dataMobil = Get.arguments as DataMobilModel;
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    int hargaPerHariIDR = int.parse(dataMobil.hargaPerHari!);
    int hargaPerHariCalculated = c.dateRange.value == 0
        ? hargaPerHariIDR
        : hargaPerHariIDR * c.dateRange.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan dan Bayar Mobil'),
      ),
      body: FutureBuilder(
          future: simulateDelay(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }
            return StreamBuilder<UserModel>(
                stream: authC.getUserData(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const LoadingView();
                  } else {
                    if (snap.data == null) {
                      return const LoadingView();
                    } else {
                      var data = snap.data!;
                      // Assign the original values for namaLengkap and username
                      //controller.namaLengkapFormPesanC.text =
                      //data.namaLengkap ?? '';
                      // Decrypt data before assigning to the text controllers
                      controller.namaLengkapFormPesanC.text =
                          controller.dekripsiData(data.namaLengkap!);
                      controller.noKtpFormPesanC.text =
                          controller.dekripsiData(data.noKTP!);
                      controller.noTelpFormPesanC.text =
                          controller.dekripsiData(data.nomorTelepon!);
                      controller.alamatFormPesanC.text =
                          controller.dekripsiData(data.alamat!);
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: 6.w, left: 6.w, top: 1.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataMobil.namaMobil!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontSize: 16.sp,
                                            ),
                                      ),
                                      Text(
                                        '${dataMobil.merek!} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontSize: 12.sp,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${formatCurrency.format(hargaPerHariIDR)}/hari',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 12.sp,
                                          height: 1,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              formInput(
                                key: controller.namaLengkapFormPesanKey.value,
                                textEditingController:
                                    controller.namaLengkapFormPesanC,
                                hintText: 'Nama Lengkap',
                                iconPrefix: PhosphorIconsFill.userRectangle,
                                keyboardType: TextInputType.name,
                                validator: controller.normalValidator,
                                isDatePicker: false,
                              ),
                              formInput(
                                key: controller.noKtpFormPesanKey.value,
                                textEditingController:
                                    controller.noKtpFormPesanC,
                                hintText: 'Nomor KTP',
                                iconPrefix: PhosphorIconsFill.listNumbers,
                                keyboardType: TextInputType.number,
                                validator: controller.normalValidator,
                                isDatePicker: false,
                              ),
                              formInput(
                                key: controller.noTelpFormPesanKey.value,
                                textEditingController:
                                    controller.noTelpFormPesanC,
                                hintText: 'Nomor Telepon',
                                iconPrefix: PhosphorIconsFill.phone,
                                keyboardType: TextInputType.number,
                                validator: controller.normalValidator,
                                isDatePicker: false,
                              ),
                              formInput(
                                key: controller.alamatFormPesanKey.value,
                                textEditingController:
                                    controller.alamatFormPesanC,
                                hintText: 'Alamat',
                                iconPrefix: PhosphorIconsFill.house,
                                keyboardType: TextInputType.name,
                                validator: controller.normalValidator,
                                isDatePicker: false,
                              ),
                              formInput(
                                key: controller.datePesanFormPesanKey.value,
                                textEditingController: controller.end.value
                                        .isAtSameMomentAs(DateTime.now())
                                    ? TextEditingController(text: '')
                                    : c.datePesanFormPesanC,
                                readOnly: true,
                                hintText: 'Tanggal Pesan',
                                iconPrefix: PhosphorIconsFill.calendar,
                                keyboardType: TextInputType.name,
                                validator: controller.normalValidator,
                                isDatePicker: true,
                                onPressedDatePicker: () {
                                  Get.dialog(Dialog(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 1.h,
                                          bottom: 1.h,
                                          right: 5.w,
                                          left: 5.w),
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: light,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: SfDateRangePicker(
                                        backgroundColor: light,
                                        headerStyle: DateRangePickerHeaderStyle(
                                            backgroundColor: light),
                                        viewSpacing: 10,
                                        todayHighlightColor: blue_0C134F,
                                        selectionColor: blue_0C134F,
                                        rangeSelectionColor:
                                            blue_0C134F.withOpacity(0.2),
                                        startRangeSelectionColor:
                                            blue_0C134F.withOpacity(0.5),
                                        endRangeSelectionColor:
                                            blue_0C134F.withOpacity(0.5),
                                        view: DateRangePickerView.month,
                                        monthViewSettings:
                                            const DateRangePickerMonthViewSettings(
                                          firstDayOfWeek: 7,
                                        ),
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        enablePastDates: false,
                                        showActionButtons: true,
                                        onCancel: () => Get.back(),
                                        controller: c.datePesanController,
                                        onSubmit: (value) {
                                          if (value != null) {
                                            if ((value as PickerDateRange)
                                                    .endDate !=
                                                null) {
                                              c.selectDatePesan(
                                                  value.startDate!,
                                                  value.endDate!);
                                              Get.back();
                                            } else {
                                              Get.dialog(
                                                dialogAlertOnly(
                                                  animationLink:
                                                      'assets/lottie/warning_aztravel.json',
                                                  text: "Terjadi Kesalahan.",
                                                  textSub:
                                                      "Pilih tanggal jangkauan\n(Senin-Sabtu, dsb)\n(tekan tanggal dua kali \nuntuk memilih tanggal yang sama)",
                                                  textAlert:
                                                      getTextAlert(context),
                                                  textAlertSub:
                                                      getTextAlertSub(context),
                                                ),
                                              );
                                            }
                                          } else {
                                            Get.dialog(
                                              dialogAlertOnly(
                                                animationLink:
                                                    'assets/lottie/warning_aztravel.json',
                                                text: "Terjadi Kesalahan.",
                                                textSub:
                                                    "Tanggal tidak dipilih.",
                                                textAlert:
                                                    getTextAlert(context),
                                                textAlertSub:
                                                    getTextAlertSub(context),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ));
                                },
                              ),
                              Obx(
                                () => Text(
                                  'Total Bayar : ${formatCurrency.format(c.dateRange.value == 0 ? hargaPerHariIDR : hargaPerHariIDR * c.dateRange.value)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 12.sp,
                                        height: 1,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    if (c.namaLengkapFormPesanKey.value
                                            .currentState!
                                            .validate() &&
                                        c.noKtpFormPesanKey.value.currentState!
                                            .validate() &&
                                        c.noTelpFormPesanKey.value.currentState!
                                            .validate() &&
                                        c.alamatFormPesanKey.value.currentState!
                                            .validate()) {
                                      c.pesanMobil(
                                          dataMobil.id!,
                                          hargaPerHariCalculated.toString(),
                                          dataMobil.namaMobil!,
                                          c.namaLengkapFormPesanC.text,
                                          c.noKtpFormPesanC.text,
                                          c.noTelpFormPesanC.text,
                                          c.alamatFormPesanC.text);
                                    }
                                  },
                                  child: Container(
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: yellow1_F9B401,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 5.w, left: 5.w),
                                      child: const Center(
                                          child: Text('Bayar Sekarang')),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                });
          }),
    );
  }
}
