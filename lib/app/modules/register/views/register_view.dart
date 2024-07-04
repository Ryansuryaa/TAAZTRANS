import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/theme.dart';
import '../../../utils/textfield.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    final authC = AuthController();
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
          body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/Login.svg',
                  width: 100.w,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 17.h),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/Logo.svg',
                      width: 35.w,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Center(
                    child: Container(
                      width: 85.w,
                      decoration: BoxDecoration(
                          color: light,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.5.h, bottom: 5.h),
                        child: Obx(
                          () => Column(
                            children: [
                              Text(
                                'Daftar',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                              formRegister(
                                  key: controller.usernameRegisterKey.value,
                                  textEditingController:
                                      controller.usernameRegisterC,
                                  hintText: 'Username',
                                  iconPrefix: PhosphorIconsFill.user,
                                  keyboardType: TextInputType.name,
                                  validator: controller.normalValidator),
                              formRegister(
                                  key: controller.namaLengkapRegisterKey.value,
                                  textEditingController:
                                      controller.namaLengkapRegisterC,
                                  hintText: 'Nama Lengkap',
                                  iconPrefix: PhosphorIconsFill.userRectangle,
                                  keyboardType: TextInputType.name,
                                  validator: controller.normalValidator),
                              formRegister(
                                  key: controller.noKtpRegisterKey.value,
                                  textEditingController:
                                      controller.noKtpRegisterC,
                                  hintText: 'Nomor KTP',
                                  iconPrefix: PhosphorIconsFill.listNumbers,
                                  keyboardType: TextInputType.number,
                                  validator: controller.normalValidator),
                              formRegister(
                                  key: controller.noTelpRegisterKey.value,
                                  textEditingController:
                                      controller.noTelpRegisterC,
                                  hintText: 'Nomor Telepon',
                                  iconPrefix: PhosphorIconsFill.phone,
                                  keyboardType: TextInputType.number,
                                  validator: controller.normalValidator),
                              formRegister(
                                  key: controller.alamatRegisterKey.value,
                                  textEditingController:
                                      controller.alamatRegisterC,
                                  hintText: 'Alamat',
                                  iconPrefix: PhosphorIconsFill.house,
                                  keyboardType: TextInputType.name,
                                  validator: controller.normalValidator),
                              formRegister(
                                  key: controller.emailRegisterKey.value,
                                  textEditingController: controller.emailC,
                                  hintText: 'Email',
                                  iconPrefix: PhosphorIconsFill.envelope,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: controller.emailValidator),
                              formPassAgainRegister(
                                key: controller.passRegisterKey.value,
                                textEditingController: controller.passC,
                                hintText: 'Kata Sandi',
                                iconPrefix: PhosphorIconsFill.key,
                                keyboardType: TextInputType.visiblePassword,
                                validator: controller.passValidator,
                                errorStatus: authC.errorStatusPass.value,
                                errorText: authC.errorTextPass.value,
                                hidePass: controller.isPasswordHidden,
                              ),
                              formPassAgainRegister(
                                key: controller.passRegisterAgainKey.value,
                                textEditingController: controller.passAgainC,
                                hintText: 'Ulangi Kata Sandi',
                                iconPrefix: PhosphorIconsFill.key,
                                keyboardType: TextInputType.visiblePassword,
                                validator: controller.passValidator,
                                errorStatus: authC.errorStatusPassAgain.value,
                                errorText: authC.errorTextPassAgain.value,
                                hidePass: controller.isPasswordHidden2,
                              ),
                              SizedBox(
                                height: 0.3.h,
                              ),
                              InkWell(
                                onTap: () {
                                  if (controller.usernameRegisterKey.value
                                          .currentState!
                                          .validate() &&
                                      controller.emailRegisterKey.value.currentState!
                                          .validate() &&
                                      controller.passRegisterKey.value.currentState!
                                          .validate() &&
                                      controller.passRegisterAgainKey.value.currentState!
                                          .validate() &&
                                      controller.namaLengkapRegisterKey.value
                                          .currentState!
                                          .validate() &&
                                      controller.noKtpRegisterKey.value.currentState!
                                          .validate() &&
                                      controller
                                          .noTelpRegisterKey.value.currentState!
                                          .validate() &&
                                      controller
                                          .alamatRegisterKey.value.currentState!
                                          .validate()) {
                                    authC.register(
                                      controller.usernameRegisterC.text,
                                      controller.emailC.text,
                                      controller.passC.text,
                                      controller.passAgainC.text,
                                      controller.namaLengkapRegisterC.text,
                                      controller.noKtpRegisterC.text,
                                      controller.noTelpRegisterC.text,
                                      controller.alamatRegisterC.text,
                                    );
                                  }
                                },
                                child: Container(
                                  width: 75.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    color: yellow1_F9B401,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 5.w, left: 5.w),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Daftar'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: 10.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offAllNamed(Routes.LOGIN);
                                    },
                                    child: Text(
                                      'Masuk',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
