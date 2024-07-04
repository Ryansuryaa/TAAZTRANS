import 'package:az_travel/app/controller/auth_controller.dart';
import 'package:az_travel/app/routes/app_pages.dart';
import 'package:az_travel/app/utils/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
                          child: Column(
                            children: [
                              Text(
                                'Masuk',
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
                              formLogin(
                                autofillHints: const [AutofillHints.email],
                                key: controller.emailLoginKey.value,
                                textEditingController: controller.emailC,
                                hintText: 'Email',
                                iconPrefix: PhosphorIconsFill.envelope,
                                keyboardType: TextInputType.emailAddress,
                                validator: controller.emailValidator,
                                errorStatus: authC.errorStatusLoginEmail.value,
                                errorText: authC.errorTextLoginEmail.value,
                              ),
                              formLoginPass(
                                autofillHints: const [AutofillHints.password],
                                key: controller.passLoginKey.value,
                                textEditingController: controller.passC,
                                hintText: 'Kata Sandi',
                                iconPrefix: PhosphorIconsFill.key,
                                keyboardType: TextInputType.visiblePassword,
                                validator: controller.passValidator,
                                hidePass: controller.isPasswordHidden,
                                errorStatus: authC.errorStatusLoginEmail.value,
                                errorText: authC.errorTextLoginEmail.value,
                              ),
                              SizedBox(
                                height: 0.3.h,
                              ),
                              InkWell(
                                onTap: () {
                                  if (controller
                                          .emailLoginKey.value.currentState!
                                          .validate() &&
                                      controller
                                          .passLoginKey.value.currentState!
                                          .validate()) {
                                    authC.login(
                                      controller.emailC.text,
                                      controller.passC.text,
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
                                        Text('Masuk'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const Text('atau'),
                              SizedBox(
                                height: 2.h,
                              ),
                              InkWell(
                                onTap: () {
                                  authC.signInGoogle();
                                },
                                child: Container(
                                  width: 75.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                      color: light,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                            color: dark,
                                            offset: const Offset(0, 1))
                                      ]),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 5.w, left: 5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text('Masuk dengan Google'),
                                        SvgPicture.asset(
                                          'assets/images/google_logo.svg',
                                          width: 5.w,
                                        ),
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
                                    'Belum punya akun? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: 10.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offAllNamed(Routes.REGISTER);
                                    },
                                    child: Text(
                                      'Daftar',
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
                              SizedBox(
                                height: 4.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
