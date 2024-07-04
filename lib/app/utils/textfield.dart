import 'package:az_travel/app/theme/textstyle.dart';
import 'package:az_travel/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

Widget formLogin({
  required Key key,
  required TextEditingController textEditingController,
  required String hintText,
  required IconData iconPrefix,
  required TextInputType? keyboardType,
  required String? Function(String?)? validator,
  Iterable<String>? autofillHints,
  required bool errorStatus,
  required String errorText,
}) {
  FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  return Form(
    key: key,
    child: SizedBox(
      width: 75.w,
      height: 10.h,
      child: TextFormField(
        autofillHints: autofillHints,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        keyboardType: keyboardType,
        validator: validator,
        onTap: () {
          // if (!currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          // }
        },
        onTapOutside: (event) {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        decoration: InputDecoration(
          helperText: ' ',
          errorText: errorStatus ? errorText : null,
          helperStyle: getTextErrorFormLogin(),
          hintText: hintText,
          hintStyle: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(
                fontSize: 12.sp,
              ),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 0.8.w,
            ),
            child: Align(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Icon(
                iconPrefix,
                size: 18,
                color: Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          ),
          filled: true,
          fillColor: Theme.of(Get.context!).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: black, width: 1),
          ),
        ),
      ),
    ),
  );
}

Widget formRegister({
  required Key key,
  required TextEditingController textEditingController,
  required String hintText,
  required IconData iconPrefix,
  required TextInputType? keyboardType,
  required String? Function(String?)? validator,
  Iterable<String>? autofillHints,
}) {
  FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  return Form(
    key: key,
    child: SizedBox(
      width: 75.w,
      height: 10.h,
      child: TextFormField(
        autofillHints: autofillHints,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        keyboardType: keyboardType,
        validator: validator,
        onTap: () {
          // if (!currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          // }
        },
        onTapOutside: (event) {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        decoration: InputDecoration(
          helperText: ' ',
          helperStyle: getTextErrorFormLogin(),
          hintText: hintText,
          hintStyle: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(
                fontSize: 12.sp,
              ),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 0.8.w,
            ),
            child: Align(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Icon(
                iconPrefix,
                size: 18,
                color: Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          ),
          filled: true,
          fillColor: Theme.of(Get.context!).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: black, width: 1),
          ),
        ),
      ),
    ),
  );
}

Widget formLoginPass({
  required Key key,
  required TextEditingController textEditingController,
  required String hintText,
  required IconData iconPrefix,
  required TextInputType? keyboardType,
  required String? Function(String?)? validator,
  Iterable<String>? autofillHints,
  required RxBool hidePass,
  required bool errorStatus,
  required String errorText,
}) {
  FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  return Form(
    key: key,
    child: Obx(
      () => SizedBox(
        width: 75.w,
        height: 10.h,
        child: TextFormField(
          autofillHints: autofillHints,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: textEditingController,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: hidePass.value,
          onTap: () {
            // if (!currentFocus.hasPrimaryFocus) {
            //   currentFocus.unfocus();
            // }
          },
          onTapOutside: (event) {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          decoration: InputDecoration(
            helperText: ' ',
            errorText: errorStatus ? errorText : null,
            helperStyle: getTextErrorFormLogin(),
            hintText: hintText,
            hintStyle: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(
                  fontSize: 12.sp,
                ),
            isDense: true,
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: 1.w,
                right: 0.8.w,
              ),
              child: Align(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Icon(
                  iconPrefix,
                  size: 18,
                  color: Theme.of(Get.context!).iconTheme.color,
                ),
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(
                right: 0.35.w,
              ),
              child: IconButton(
                splashRadius: 1,
                iconSize: 18,
                icon: Icon(hidePass.value
                    ? PhosphorIconsFill.eye
                    : PhosphorIconsFill.eyeSlash),
                onPressed: () {
                  hidePass.value = !hidePass.value;
                },
              ),
            ),
            filled: true,
            fillColor: Theme.of(Get.context!).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: black, width: 1),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget formPassAgainRegister({
  required Key key,
  required TextEditingController textEditingController,
  required String hintText,
  required IconData iconPrefix,
  required TextInputType? keyboardType,
  required String? Function(String?)? validator,
  Iterable<String>? autofillHints,
  required bool errorStatus,
  required String errorText,
  required RxBool hidePass,
}) {
  FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  return Form(
    key: key,
    child: SizedBox(
      width: 75.w,
      height: 10.h,
      child: TextFormField(
        autofillHints: autofillHints,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        keyboardType: keyboardType,
        validator: validator,
        onTap: () {
          // if (!currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          // }
        },
        onTapOutside: (event) {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        decoration: InputDecoration(
          helperText: ' ',
          errorText: errorStatus ? errorText : null,
          helperStyle: getTextErrorFormLogin(),
          hintText: hintText,
          hintStyle: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(
                fontSize: 12.sp,
              ),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 0.8.w,
            ),
            child: Align(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Icon(
                iconPrefix,
                size: 18,
                color: Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(
              right: 0.35.w,
            ),
            child: IconButton(
              splashRadius: 1,
              iconSize: 18,
              icon: Icon(hidePass.value
                  ? PhosphorIconsFill.eye
                  : PhosphorIconsFill.eyeSlash),
              onPressed: () {
                hidePass.value = !hidePass.value;
              },
            ),
          ),
          filled: true,
          fillColor: Theme.of(Get.context!).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: black, width: 1),
          ),
        ),
      ),
    ),
  );
}

Widget formInput(
    {required Key key,
    required TextEditingController textEditingController,
    required String hintText,
    required IconData iconPrefix,
    required TextInputType? keyboardType,
    required String? Function(String?)? validator,
    double? width,
    double? height,
    double? hintTextFontSize,
    bool? readOnly,
    required bool isDatePicker,
    void Function()? onPressedDatePicker,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength}) {
  FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  return Form(
    key: key,
    child: SizedBox(
      height: height ?? 10.h,
      width: width,
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        onTap: () {
          // if (!currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          // }
        },
        readOnly: readOnly ?? false,
        onTapOutside: (event) {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(
                fontSize: hintTextFontSize ?? 12.sp,
              ),
          isDense: true,
          contentPadding: const EdgeInsets.all(5),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 0.8.w,
            ),
            child: Align(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Icon(
                iconPrefix,
                size: 18,
                color: Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          ),
          suffixIcon: isDatePicker
              ? Padding(
                  padding: EdgeInsets.only(
                    right: 0.35.w,
                  ),
                  child: IconButton(
                    splashRadius: 1,
                    iconSize: 18,
                    icon: const Icon(PhosphorIconsFill.calendar),
                    onPressed: onPressedDatePicker,
                  ),
                )
              : null,
          filled: true,
          fillColor: Theme.of(Get.context!).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: black, width: 0.5),
          ),
        ),
      ),
    ),
  );
}

Widget formInputMultiLine({
  required Key key,
  required TextEditingController textEditingController,
  required String hintText,
  required IconData iconPrefix,
  required String? Function(String?)? validator,
}) {
  FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  return Form(
    key: key,
    child: SizedBox(
      height: 10.h,
      child: TextFormField(
        controller: textEditingController,
        keyboardType: TextInputType.multiline,
        validator: validator,
        maxLines: null,
        onTap: () {
          // if (!currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          // }
        },
        onTapOutside: (event) {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(Get.context!).textTheme.displaySmall!.copyWith(
                fontSize: 12.sp,
              ),
          isDense: true,
          contentPadding: const EdgeInsets.all(5),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 0.8.w,
            ),
            child: Align(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Icon(
                iconPrefix,
                size: 18,
                color: Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          ),
          filled: true,
          fillColor: Theme.of(Get.context!).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: black, width: 0.5),
          ),
        ),
      ),
    ),
  );
}
