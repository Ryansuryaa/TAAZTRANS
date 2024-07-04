import 'dart:developer';
import 'dart:convert';

import 'package:az_travel/app/theme/textstyle.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

import '../data/models/usermodel.dart';
import '../routes/app_pages.dart';
import '../utils/dialog.dart';

class AuthController extends GetxController {
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //akun yg sudah login disimpan di _currentUser
  GoogleSignInAccount? _currentUser;

  //data yang diperlukan untuk login disimpan di userCredential
  UserCredential? userCredential;

  //inisialisasi database firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  //inisiasi model data user
  var userData = UserModel().obs;

  late Stream<UserModel> firestoreUserModel;

  var buildContext = Get.context?.obs;

  // Enkripsi AES-128 Mode ECB
  final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromUtf8('AzTransReservasi'),
    mode: encrypt.AESMode.ecb,
  ));

  Stream<UserModel> getUserData() async* {
    var email = auth.currentUser!.email;
    yield* firestoreUserModel = firestore
        .collection('DataPelanggan')
        .doc(email)
        .snapshots()
        .map((documentSnapshot) => UserModel.fromJson(documentSnapshot));
  }

  // variabel reactive untuk text error form
  var errorStatusPass = false.obs;
  var errorTextPass = ''.obs;
  var errorStatusPassAgain = false.obs;
  var errorTextPassAgain = ''.obs;
  var errorStatusLoginEmail = false.obs;
  var errorTextLoginEmail = ''.obs;
  var errorStatusLoginPass = false.obs;
  var errorTextLoginPass = ''.obs;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
        firestoreUserModel = firestore
            .collection('DataPelanggan')
            .doc(auth.currentUser!.email)
            .snapshots()
            .map((documentSnapshot) => UserModel.fromJson(documentSnapshot));
      }
    });
  }

  Future<bool> autoLogin() async {
    //auto login
    try {
      final isSignIn = auth.currentUser;
      if (isSignIn != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //membuat user
  Future<UserCredential> createUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  // register untuk membuat data user
  Future<void> register(
    String username,
    String email,
    String password,
    String passwordAgain,
    String namaLengkap,
    String noKTP,
    String noTelp,
    String alamat,
  ) async {
    try {
      log('step pertama');
      var context = buildContext!.value;
      if (password != passwordAgain) {
        errorStatusPass.value = true;
        errorTextPass.value = 'Kata sandi harus sama!';
        errorStatusPassAgain.value = true;
        errorTextPassAgain.value = 'Kata sandi harus sama!';
      }

      // Enkripsi data sebelum disimpan ke firestore
      final encryptedNamaLengkap = enkripsiData(namaLengkap);
      final encryptedNoKTP = enkripsiData(noKTP);
      final encryptedAlamat = enkripsiData(alamat);
      final encryptedNoTelp = enkripsiData(noTelp);

      final userData = firestore.collection('DataPelanggan');

      final docRef = userData.doc(email);
      final checkData = await docRef.get();

      if (checkData.exists == false) {
        UserCredential user = await createUser(email, password);

        Get.back();

        String uid = user.user?.uid ?? '';

        User? userNow = await auth
            .authStateChanges()
            .firstWhere((user) => user?.uid == uid);

        if (userNow != null) {
          await userNow.updateDisplayName(namaLengkap);
        }

        // Simpan data yang telah dienkripsi ke firestore
        await userData.doc(email).set({
          "uid": uid,
          "photoUrl": '',
          "roles": 'user',
          "email": email,
          "noKTP": encryptedNoKTP,
          "username": username,
          "namaLengkap": encryptedNamaLengkap,
          "nomorTelepon": encryptedNoTelp,
          "alamat": encryptedAlamat,
        });

        if (kDebugMode) {
          print('User berhasil dibuat dan bisa login');
        }

        await Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/finish_aztravel.json',
            text: "Berhasil!",
            textSub:
                "Akun berhasil dibuat. Silahkan masuk dan verifikasi akun anda.",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );

        await Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Akun sudah ada dan pernah dibuat.",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        log('$e');
      }
    }
  }

  // Fungsi untuk substitusi pergeseran huruf (Caesar Cipher)
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

  // Metode untuk enkripsi data
  String enkripsiData(String data) {
    // Langkah 1: Enkripsi dengan substitusi
    String dataEnkripsi = substitusiEnkripsi(data, 8);

    // Langkah 2: Enkripsi dengan transposisi
    final dataEnkripsitr = transposisiEnkripsi(dataEnkripsi);

    // Langkah 3: Enkripsi dengan AES dalam mode ECB dan konversi ke Base64
    final encrypted = encrypter.encrypt(dataEnkripsitr);

    // Mengembalikan hasil enkripsi dalam bentuk base64
    return encrypted.base64;
    //return dataEnkripsitr;
  }

  Future<UserModel> readUser() async {
    var users = firestore.collection('DataPelanggan');
    String emailUser = auth.currentUser!.email.toString();
    final checkuser = await users.doc(emailUser).get();

    final checkUserData = checkuser.data() as Map<String, dynamic>;

    userData.value = (UserModel(
      uid: auth.currentUser!.uid,
      photoUrl: checkUserData['photoUrl'],
      email: auth.currentUser!.email,
      roles: checkUserData['roles'],
      noKTP: checkUserData['noKTP'],
      username: checkUserData['username'],
      namaLengkap: checkUserData['namaLengkap'],
      nomorTelepon: checkUserData['nomorTelepon'],
      alamat: checkUserData['alamat'],
    ));

    return userData.value;
  }

  void login(String email, String password) async {
    try {
      var context = buildContext!.value;
      UserCredential myUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (myUser.user!.emailVerified) {
        isAuth.value = true;
        await readUser();

        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/loading_aztravel.json',
            text: "Memuat...",
            textSub: "",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );

        await simulateDelay();
        Get.back();

        await Get.offAllNamed(Routes.HOME);
      } else {
        Get.dialog(
          dialogAlertBtn(
            onPressed: () async {
              myUser.user!.sendEmailVerification();
              Get.back();
              Future.delayed(const Duration(microseconds: 0), () async {
                await auth.signOut();
              });
              await Get.dialog(
                dialogAlertBtn(
                  onPressed: () async {
                    Get.back();
                  },
                  animationLink: 'assets/lottie/finish_aztravel.json',
                  widthBtn: 26.w,
                  textBtn: "OK",
                  text: "Email Sukses Terkirim!",
                  textSub: "Cek inbox email Anda",
                  textAlert: getTextAlert(context),
                  textAlertSub: getTextAlertSub(context),
                  textAlertBtn: getTextAlertBtn(context),
                ),
              );
            },
            animationLink: 'assets/lottie/warning_aztravel.json',
            widthBtn: 26.w,
            textBtn: "Kirim",
            text: "Email Belum Diverifikasi!",
            textSub: "klik tombol Kirim untuk mengirim email verifikasi",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
            textAlertBtn: getTextAlertBtn(context),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      var context = buildContext!.value;
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Akun tidak ditemukan.",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        errorStatusLoginPass.value = true;
        errorTextLoginPass.value = 'Kata sandi yang dimasukkan salah.';
      } else if (e.code == 'invalid-email') {
        if (kDebugMode) {
          print('Email address is not valid.');
        }
        errorStatusLoginEmail.value = true;
        errorTextLoginEmail.value = 'Email salah. Periksa kembali email anda.';
      } else {
        if (kDebugMode) {
          print('Error : $e');
        }
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Periksa isian form anda.",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );
      }
    } catch (e) {
      var context = buildContext!.value;
      if (kDebugMode) {
        print(e);
      }
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Tidak dapat masuk.",
          textAlert: getTextAlert(context),
          textAlertSub: getTextAlertSub(context),
        ),
      );
    }
  }

  Future signInGoogle() async {
    var context = buildContext!.value;
    await _googleSignIn.signOut();

    _currentUser =
        await _googleSignIn.signIn().then((value) => _currentUser = value);

    final isSignIn = await _googleSignIn.isSignedIn();

    if (isSignIn) {
      GoogleSignInAuthentication? googleAuthSign =
          await _currentUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuthSign?.accessToken,
          idToken: googleAuthSign?.idToken);

      await auth
          .signInWithCredential(credential)
          .then((value) => userCredential = value);

      log("$userCredential");

      //inisiasi collection yg akan dipakai
      var users = firestore.collection("DataPelanggan");

      String emailUser = auth.currentUser!.email.toString();

      final docRef = users.doc(emailUser);
      final checkData = await docRef.get();

      if (checkData.exists == false) {
        users.doc(emailUser).set({
          "uid": auth.currentUser!.uid,
          "photoUrl": _currentUser!.photoUrl ?? '',
          "email": emailUser,
          "roles": 'user',
          "noKTP": '',
          "username": _currentUser!.displayName ?? '',
          "namaLengkap": '',
          "nomorTelepon": '',
          "alamat": '',
        });

        isAuth.value = true;

        await readUser();

        if (kDebugMode) {
          print("ROLES GUA APA? ROLES GUA ADLAAH : ${userData.value.roles}");
        }

        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/loading_aztravel.json',
            text: "Memuat...",
            textSub: "",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );

        await simulateDelay();
        Get.back();

        await Get.offAllNamed(Routes.HOME);
      } else {
        users.doc(emailUser).update({
          "uid": auth.currentUser!.uid,
          "photoUrl": _currentUser!.photoUrl ?? '',
          "username": _currentUser!.displayName ?? '',
        });
        isAuth.value = true;

        await readUser();

        if (kDebugMode) {
          print("ROLES GUA APA? ROLES GUA ADLAAH : ${userData.value.roles}");
        }
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/loading_aztravel.json',
            text: "Memuat...",
            textSub: "",
            textAlert: getTextAlert(context),
            textAlertSub: getTextAlertSub(context),
          ),
        );

        await simulateDelay();
        Get.back();

        await Get.offAllNamed(Routes.HOME);
      }
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    if (kDebugMode) {
      print('berhasil logout');
    }
    // await _googleSignIn.disconnect();
    // await _googleSignIn.signOut();

    Get.offAllNamed(Routes.LOGIN);
  }
}
