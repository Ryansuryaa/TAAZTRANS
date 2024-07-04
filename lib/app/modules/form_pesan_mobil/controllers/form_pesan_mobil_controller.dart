import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class FormPesanMobilController extends GetxController {
  TextEditingController namaLengkapFormPesanC = TextEditingController();
  var namaLengkapFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController noKtpFormPesanC = TextEditingController();
  var noKtpFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController alamatFormPesanC = TextEditingController();
  var alamatFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController noTelpFormPesanC = TextEditingController();
  var noTelpFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController datePesanFormPesanC = TextEditingController();
  var datePesanFormPesanKey = GlobalKey<FormState>().obs;

  final normalValidator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);

  DateTime? start;
  final end = DateTime.now().obs;
  final dateFormatter = DateFormat('d MMMM yyyy', 'id-ID');
  final dateFormatterDefault = DateFormat('yyyy-MM-dd');
  var dateRange = 0.obs;
  var datePesanStart = ''.obs;
  var datePesanEnd = ''.obs;

  DateRangePickerController datePesanController = DateRangePickerController();

  void selectDatePesan(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end.value = pickEnd;
    update();
    var startFormatted = dateFormatter.format(start!);
    var endFormatted = dateFormatter.format(end.value);
    datePesanStart.value = dateFormatterDefault.format(start!);
    datePesanEnd.value = dateFormatterDefault.format(end.value);
    dateRange.value = end.value.difference(start!).inDays + 1;
    print('DateRange COY : ${dateRange.value}');
    update();
    datePesanFormPesanC.text = '$startFormatted - $endFormatted';
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Encryption setup
  final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromUtf8('AzTransReservasi'),
    mode: encrypt.AESMode.ecb,
  ));

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

  void pesanMobil(
    String idMobil,
    String harga,
    String namaMobil,
    String namaPemesan,
    String noKTPPemesan,
    String noTelpPemesan,
    String alamatPemesan,
  ) async {
    try {
      var pesananMobilReference = firestore.collection('Orderan');
      final docRef = pesananMobilReference.doc();
      await docRef.set({
        'id': docRef.id,
        'idMobil': idMobil,
        'harga': harga,
        'namaMobil': namaMobil,
        'namaPemesan': enkripsiData(namaPemesan),
        'noKTPPemesan': enkripsiData(noKTPPemesan),
        'noTelpPemesan': enkripsiData(noTelpPemesan),
        'alamatPemesan': enkripsiData(alamatPemesan),
        'tanggalPesanStart': datePesanStart.value,
        'tanggalPesanEnd': datePesanEnd.value,
      });
      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Pesanan berhasil dikirim.",
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
      Get.snackbar("Error", "Pesanan tidak berhasil dikirim.");
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
