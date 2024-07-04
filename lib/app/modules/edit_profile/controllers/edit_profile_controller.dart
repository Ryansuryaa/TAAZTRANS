// ignore_for_file: unnecessary_overrides, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../theme/textstyle.dart';
import '../../../theme/theme.dart';
import '../../../utils/dialog.dart';

class EditProfileController extends GetxController
    with GetTickerProviderStateMixin {
  TextEditingController usernameEditProfileC = TextEditingController();
  var usernameEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController namaLengkapEditProfileC = TextEditingController();
  var namaLengkapEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController noKtpEditProfileC = TextEditingController();
  var noKtpEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController alamatEditProfileC = TextEditingController();
  var alamatEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController noTelpEditProfileC = TextEditingController();
  var noTelpEditProfileKey = GlobalKey<FormState>().obs;

  final normalValidator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);

  var context = Get.context!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ImagePicker picker = ImagePicker();
  XFile? image;

  // Encryption and decryption setup
  final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromUtf8('AzTransReservasi'),
    mode: encrypt.AESMode.ecb,
  ));

  // Encryption and decryption methods
  String substitusiEnkripsi(String text, int shift) {
    return String.fromCharCodes(text.runes.map((int rune) {
      var start = 'a'.runes.single;
      if (rune >= 'A'.runes.single && rune <= 'Z'.runes.single) {
        start = 'A'.runes.single;
      } else if (rune < 'a'.runes.single || rune > 'z'.runes.single) {
        return rune; // Karakter non-huruf tidak digeser
      }
      return start + (rune - start + shift) % 26;
    }));
  }

  // Fungsi untuk transposisi dengan membaca dari atas ke bawah,
  // ditulis dari kiri ke kanan, 8 karakter setiap baris.
  String transposisiEnkripsi(String text) {
    int kolom = 8; // Tetapkan jumlah kolom untuk setiap baris
    int baris =
        (text.length / kolom).ceil(); // Hitung jumlah baris yang diperlukan

    // Buat buffer untuk membangun teks yang ditransposisi
    StringBuffer buffer = StringBuffer();

    // Iterasi melalui setiap kolom dan baris untuk mengatur ulang teks
    for (int c = 0; c < kolom; c++) {
      for (int r = 0; r < baris; r++) {
        int index = r * kolom + c; // Hitung indeks karakter
        if (index < text.length) {
          // Jika indeks valid, tambahkan ke buffer
          buffer.write(text[index]);
        }
      }
    }

    return buffer.toString(); // Kembalikan string yang telah ditransposisi
  }

  String enkripsiData(String data) {
    // Langkah 1: Enkripsi dengan substitusi
    String dataEnkripsi = substitusiEnkripsi(data, 8);

    // Langkah 2: Enkripsi dengan transposisi
    String dataEnkripsitr = transposisiEnkripsi(dataEnkripsi);

    // Langkah 3: Enkripsi dengan AES dalam mode ECB dan konversi ke Base64
    final encrypted = encrypter.encrypt(dataEnkripsitr);

    // Mengembalikan hasil enkripsi dalam bentuk base64
    return encrypted.base64;
  }

  // Fungsi untuk de-transposisi
  String transposisiDekripsi(String text) {
    int kolom = 8;
    int baris = (text.length / kolom).ceil();

    // Create a list to hold the transposed characters
    List<String> chars = List.filled(text.length, '');

    int index = 0;
    for (int c = 0; c < kolom; c++) {
      for (int r = 0; r < baris; r++) {
        int i = r * kolom + c;
        if (i < text.length) {
          chars[i] = text[index++];
        }
      }
    }

    return chars.join(''); // Return the de-transposed string
  }

  String substitusiDekripsi(String text, int shift) {
    return String.fromCharCodes(text.runes.map((int rune) {
      var start = 'a'.runes.single;
      if (rune >= 'A'.runes.single && rune <= 'Z'.runes.single) {
        start = 'A'.runes.single;
      } else if (rune < 'a'.runes.single || rune > 'z'.runes.single) {
        return rune;
      }
      return start + (rune - start - shift + 26) % 26;
    }));
  }

  String dekripsiData(String encryptedBase64) {
    try {
      // Langkah 1: Dekripsi dengan AES dari Base64
      final decrypted = encrypter.decrypt64(encryptedBase64);

      // Langkah 2: Dekripsi dengan transposisi
      String dataDekripsiTransposisi = transposisiDekripsi(decrypted);

      // Langkah 3: Dekripsi dengan substitusi
      String dataDekripsi = substitusiDekripsi(dataDekripsiTransposisi, 8);

      return dataDekripsi;
    } catch (e) {
      print("Error during decryption: $e");
      return '';
    }
  }

  Future<void> pickImage() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    if (storageStatus == PermissionStatus.granted) {
      var pickedImage =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
      if (pickedImage != null) {
        var croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
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

  Future<void> editProfil(String username, String namaLengkap, String noKTP,
      String nomorTelepon, String alamat) async {
    try {
      var email = auth.currentUser!.email;
      var dataPelangganReference = firestore.collection('DataPelanggan');
      final docRef = dataPelangganReference.doc(email);

      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        await storage.ref('datapelanggan/${docRef.id}.$ext').putFile(file);
        String urlImage = await storage
            .ref('datapelanggan/${docRef.id}.$ext')
            .getDownloadURL();
        await docRef.update({
          'username': username,
          'namaLengkap': enkripsiData(namaLengkap),
          'noKTP': enkripsiData(noKTP),
          'nomorTelepon': enkripsiData(nomorTelepon),
          'photoUrl': urlImage,
          'alamat': enkripsiData(alamat)
        });
      } else {
        await docRef.update({
          'username': username,
          'namaLengkap': enkripsiData(namaLengkap),
          'noKTP': enkripsiData(noKTP),
          'nomorTelepon': enkripsiData(nomorTelepon),
          'alamat': enkripsiData(alamat)
        });
      }

      Get.dialog(
        dialogAlertBtn(
          onPressed: () async {
            Get.back();
            Get.back();
          },
          animationLink: 'assets/lottie/finish_aztravel.json',
          widthBtn: 26.w,
          textBtn: "OK",
          text: "Berhasil!",
          textSub: "Data berhasil diubah.",
          textAlert: getTextAlert(context),
          textAlertSub: getTextAlertSub(context),
          textAlertBtn: getTextAlertBtn(context),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Data gagal diubah.",
          textAlert: getTextAlert(Get.context!),
          textAlertSub: getTextAlertSub(Get.context!),
        ),
      );
    }
  }

  late final AnimationController cAniUbahGambar;
  bool isUbahGambar = false;

  late final AnimationController cAniSimpan;
  bool isSimpan = false;

  @override
  void onInit() {
    super.onInit();
    cAniUbahGambar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniSimpan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
  }

  @override
  void onClose() {
    cAniUbahGambar.dispose();
    cAniSimpan.dispose();
    super.onClose();
  }

  void animUbahGambar() async {
    if (isUbahGambar == false) {
      isUbahGambar = true;
      update();
      await cAniUbahGambar.forward();
      await cAniUbahGambar.reverse();
      isUbahGambar = false;
      update();
    }
  }

  void animSimpan() async {
    if (isSimpan == false) {
      isSimpan = true;
      update();
      await cAniSimpan.forward();
      await cAniSimpan.reverse();
      isSimpan = false;
      update();
    }
  }

  void toBack() {
    Get.back();
  }

  void simpan() {
    if (usernameEditProfileKey.value.currentState!.validate() &&
        namaLengkapEditProfileKey.value.currentState!.validate() &&
        noKtpEditProfileKey.value.currentState!.validate() &&
        alamatEditProfileKey.value.currentState!.validate() &&
        noTelpEditProfileKey.value.currentState!.validate()) {
      editProfil(
        usernameEditProfileC.text,
        namaLengkapEditProfileC.text,
        noKtpEditProfileC.text,
        noTelpEditProfileC.text,
        alamatEditProfileC.text,
      );
    }
  }
}
