// ignore_for_file: unnecessary_overrides, use_build_context_synchronously

import 'dart:io';

import 'package:az_travel/app/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../theme/textstyle.dart';
import '../../../utils/dialog.dart';

class FormMobilController extends GetxController {
  TextEditingController namaMobilC = TextEditingController();
  var namaMobilFormKey = GlobalKey<FormState>().obs;
  TextEditingController merekC = TextEditingController();
  var merekFormKey = GlobalKey<FormState>().obs;
  TextEditingController noPolisiC = TextEditingController();
  var noPolisiFormKey = GlobalKey<FormState>().obs;
  TextEditingController hargaPerHariC = TextEditingController();
  var hargaPerHariFormKey = GlobalKey<FormState>().obs;
  TextEditingController tipeBahanBakarC = TextEditingController();
  var tipeBahanBakarFormKey = GlobalKey<FormState>().obs;
  TextEditingController tahunC = TextEditingController();
  var tahunFormKey = GlobalKey<FormState>().obs;
  TextEditingController deskripsiC = TextEditingController();
  var deskripsiFormKey = GlobalKey<FormState>().obs;

  final normalValidator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);

  var context = Get.context!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> pickImage() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    // var status = await Permission.storage.request();
    if (storageStatus == PermissionStatus.granted) {
      var pickedImage =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
      if (pickedImage != null) {
        var croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Potong Gambar',
                toolbarColor: yellow1_F9B401,
                toolbarWidgetColor: light,
                backgroundColor: light,
                statusBarColor: dark),
          ],
        );
        if (croppedImage != null) {
          image = XFile.fromData(await croppedImage.readAsBytes(),
              path: croppedImage.path);
          if (kDebugMode) {
            print(image!.name);
            print(image!.path);
          }
        } else {
          if (kDebugMode) {
            print("Image cropping cancelled");
          }
        }
      } else {
        if (kDebugMode) {
          print(image);
        }
      }
      update();
    } else if (storageStatus == PermissionStatus.denied) {
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Akses ke penyimpanan ditolak!",
          textAlert: getTextAlert(context),
          textAlertSub: getTextAlertSub(context),
        ),
      );
    } else {
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Akses ke penyimpanan ditolak! {err}",
          textAlert: getTextAlert(context),
          textAlertSub: getTextAlertSub(context),
        ),
      );
    }
  }

  Future<void> tambahDataMobil(
      String namaMobil,
      String merek,
      String noPolisi,
      String hargaPerHari,
      String tipeBahanBakar,
      String tahun,
      String deskripsi) async {
    try {
      var dataMobilReference = firestore.collection('DataMobil');
      final docRef = dataMobilReference.doc();
      final checkData = await docRef.get();

      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        await storage.ref('datamobil/${docRef.id}.$ext').putFile(file);
        String urlImage =
            await storage.ref('datamobil/${docRef.id}.$ext').getDownloadURL();
        if (checkData.exists == false) {
          await docRef.set({
            'id': docRef.id,
            'namaMobil': namaMobil,
            'merek': merek,
            'noPolisi': noPolisi,
            'hargaPerHari': hargaPerHari,
            'tipeBahanBakar': tipeBahanBakar,
            'tahun': tahun,
            'fotoMobil': urlImage,
            'deskripsi': deskripsi
          });

          Get.defaultDialog(
            title: "Berhasil",
            middleText: "Data berhasil ditambahkan.",
            textConfirm: 'Ya',
            onConfirm: () {
              Get.back();
              Get.back();
            },
          );
        } else {
          Get.snackbar("Error", "Data sudah ada!");
        }
      } else {
        Get.snackbar("Error", "Foto harus ada!");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Data tidak berhasil ditambahkan.");
    }
  }

  Future<void> editDataMobil(
      String id,
      String namaMobil,
      String merek,
      String noPolisi,
      String hargaPerHari,
      String tipeBahanBakar,
      String tahun,
      String deskripsi) async {
    try {
      var dataMobilReference = firestore.collection('DataMobil');
      final docRef = dataMobilReference.doc(id);

      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        await storage.ref('datamobil/${docRef.id}.$ext').putFile(file);
        String urlImage =
            await storage.ref('datamobil/${docRef.id}.$ext').getDownloadURL();
        await docRef.update({
          'namaMobil': namaMobil,
          'merek': merek,
          'noPolisi': noPolisi,
          'hargaPerHari': hargaPerHari,
          'tipeBahanBakar': tipeBahanBakar,
          'tahun': tahun,
          'fotoMobil': urlImage,
          'deskripsi': deskripsi
        });
      } else {
        await docRef.update({
          'namaMobil': namaMobil,
          'merek': merek,
          'noPolisi': noPolisi,
          'hargaPerHari': hargaPerHari,
          'tipeBahanBakar': tipeBahanBakar,
          'tahun': tahun,
          'deskripsi': deskripsi
        });
      }

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Data berhasil diubah.",
        textConfirm: 'Ya',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Data tidak berhasil ditambahkan.");
    }
  }

  Future<void> hapusDataMobil(
    String id,
  ) async {
    try {
      await firestore.collection('DataMobil').doc(id).delete();

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Data berhasil dihapus.",
        textConfirm: 'Ya',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Data tidak berhasil ditambahkan.");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
