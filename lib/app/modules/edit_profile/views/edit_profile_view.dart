import 'dart:io';
import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/auth_controller.dart';
import '../../../theme/theme.dart';
import '../../../utils/button.dart';
import '../../../utils/loading.dart';
import '../../../utils/textfield.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController authC = Get.put(AuthController());
  final EditProfileController controller = Get.put(EditProfileController());
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showNotification();
    });
  }

  void showNotification() {
    overlayEntry = createOverlayEntry();
    Overlay.of(context)?.insert(overlayEntry!);
    Future.delayed(Duration(seconds: 7), () {
      overlayEntry?.remove();
    });
  }

  OverlayEntry createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.green,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Data anda telah tersimpan secara terenkripsi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var defaultImage =
        "https://ui-avatars.com/api/?background=fff38a&color=5175c0&font-size=0.33&size=256";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
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
                      controller.usernameEditProfileC.text =
                          data.username ?? '';
                      // Decrypt data before assigning to the text controllers
                      controller.namaLengkapEditProfileC.text =
                          controller.dekripsiData(data.namaLengkap!);
                      controller.noKtpEditProfileC.text =
                          controller.dekripsiData(data.noKTP!);
                      controller.noTelpEditProfileC.text =
                          controller.dekripsiData(data.nomorTelepon!);
                      controller.alamatEditProfileC.text =
                          controller.dekripsiData(data.alamat!);

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding:
                            EdgeInsets.only(right: 5.w, left: 5.w, top: 2.h),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Container(
                                height: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: blue_0C134F,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buttonWithIcon(
                                  onTap: () {
                                    controller.animUbahGambar();
                                    Future.delayed(
                                            const Duration(milliseconds: 120))
                                        .then((value) {
                                      controller.pickImage();
                                    });
                                  },
                                  animationController:
                                      controller.cAniUbahGambar,
                                  onLongPressEnd: (details) async {
                                    await controller.cAniUbahGambar.forward();
                                    await controller.cAniUbahGambar.reverse();
                                    controller.pickImage();
                                  },
                                  elevation: 0,
                                  btnColor: yellow1_F9B401,
                                  icon: Icon(
                                    PhosphorIconsBold.camera,
                                    size: 6.w,
                                  ),
                                  width: 40.w,
                                  text: 'Ubah Gambar',
                                  textColor: black,
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                GetBuilder<EditProfileController>(builder: (c) {
                                  return Stack(
                                    children: [
                                      if (c.image == null)
                                        InkWell(
                                          onTap: () {
                                            controller.pickImage();
                                          },
                                          child: ClipOval(
                                            child: Image.network(
                                              data.photoUrl! == ''
                                                  ? defaultImage
                                                  : data.photoUrl!,
                                              width: 45.w,
                                            ),
                                          ),
                                        )
                                      else
                                        InkWell(
                                          onTap: () {
                                            controller.pickImage();
                                          },
                                          child: ClipOval(
                                            child: Image.file(
                                              File(c.image!.path),
                                              width: 45.w,
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                                }),
                                SizedBox(
                                  height: 4.h,
                                ),
                                formRegister(
                                    key:
                                        controller.usernameEditProfileKey.value,
                                    textEditingController:
                                        controller.usernameEditProfileC,
                                    hintText: 'Username',
                                    iconPrefix: PhosphorIconsFill.user,
                                    keyboardType: TextInputType.name,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller
                                        .namaLengkapEditProfileKey.value,
                                    textEditingController:
                                        controller.namaLengkapEditProfileC,
                                    hintText: 'Nama Lengkap',
                                    iconPrefix: PhosphorIconsFill.userRectangle,
                                    keyboardType: TextInputType.name,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller.noKtpEditProfileKey.value,
                                    textEditingController:
                                        controller.noKtpEditProfileC,
                                    hintText: 'Nomor KTP',
                                    iconPrefix: PhosphorIconsFill.listNumbers,
                                    keyboardType: TextInputType.number,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller.noTelpEditProfileKey.value,
                                    textEditingController:
                                        controller.noTelpEditProfileC,
                                    hintText: 'Nomor Telepon',
                                    iconPrefix: PhosphorIconsFill.phone,
                                    keyboardType: TextInputType.number,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller.alamatEditProfileKey.value,
                                    textEditingController:
                                        controller.alamatEditProfileC,
                                    hintText: 'Alamat',
                                    iconPrefix: PhosphorIconsFill.house,
                                    keyboardType: TextInputType.name,
                                    validator: controller.normalValidator),
                                SizedBox(
                                  height: 4.h,
                                ),
                                buttonWithIcon(
                                  onTap: () {
                                    controller.animSimpan();
                                    Future.delayed(
                                            const Duration(milliseconds: 120))
                                        .then((value) {
                                      controller.simpan();
                                      showNotification(); // Show notification on save
                                    });
                                  },
                                  animationController: controller.cAniSimpan,
                                  onLongPressEnd: (details) async {
                                    await controller.cAniSimpan.forward();
                                    await controller.cAniSimpan.reverse();
                                    controller.simpan();
                                    showNotification(); // Show notification on save
                                  },
                                  elevation: 0,
                                  btnColor: yellow1_F9B401,
                                  icon: Icon(
                                    PhosphorIconsBold.floppyDisk,
                                    size: 6.w,
                                  ),
                                  width: 50.w,
                                  text: 'Simpan',
                                  textColor: black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  }
                });
          }),
    );
  }
}
