import 'package:az_travel/app/data/models/pesananmobilmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class DataReservasiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<List<PesananMobil>> firestorePesananMobillList;

  // Deklarasikan Encrypter di sini
  final encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromUtf8('AzTransReservasi'),
    mode: encrypt.AESMode.ecb,
  ));

  @override
  void onInit() {
    super.onInit();
    firestorePesananMobillList = firestore
        .collection('Orderan')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => PesananMobil.fromJson(documentSnapshot))
            .toList());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Metode untuk melakukan dekripsi data
  Map<String, dynamic> dekripsiData(Map<String, dynamic> encryptedData) {
    try {
      Map<String, dynamic> decryptedData = {};
      encryptedData.forEach((key, value) {
        if (value is String) {
          // Decrypt the AES-encrypted string
          final decryptedAES =
              encrypter.decrypt(encrypt.Encrypted.fromBase64(value));

          // Apply transposition decryption
          String transposed = transposisiDekripsi(decryptedAES);

          // Apply substitution (Caesar Cipher) decryption
          decryptedData[key] = substitusiDekripsi(transposed, 8);
        } else {
          decryptedData[key] = value; // Non-string values are not encrypted
        }
      });
      return decryptedData;
    } catch (e) {
      print("Error during decryption: $e");
      return {}; // Kembalikan map kosong atau nilai default lain jika terjadi kesalahan
    }
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

  // Fungsi untuk de-substitusi (Caesar Cipher)
  String substitusiDekripsi(String text, int shift) {
    return String.fromCharCodes(text.runes.map((int rune) {
      var start = 'a'.runes.single;
      if (rune >= 'A'.runes.single && rune <= 'Z'.runes.single) {
        start = 'A'.runes.single;
      } else if (rune < 'a'.runes.single || rune > 'z'.runes.single) {
        return rune; // Non-letter characters are not shifted
      }
      return start + (rune - start - shift + 26) % 26;
    }));
  }

  // Contoh penggunaan fungsi dekripsi dalam metode lain
  void showDecryptedData(String encryptedData) {
    final decryptedData = dekripsiData({'data': encryptedData})['data'];
    print('Data terdekripsi: $decryptedData');
  }
}
