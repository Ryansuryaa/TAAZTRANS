import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class DetailPelangganController extends GetxController {
  // Deklarasikan Encrypter di sini
  final encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromUtf8('AzTransReservasi'),
    mode: encrypt.AESMode.ecb,
  ));

  // Metode untuk melakukan dekripsi data
  String dekripsiData(String encryptedBase64) {
    try {
      // Decrypt the AES-encrypted string
      final decryptedAES =
          encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedBase64));

      // Apply transposition decryption
      String transposed = transposisiDekripsi(decryptedAES);

      // Apply substitution (Caesar Cipher) decryption
      return substitusiDekripsi(transposed, 8);
    } catch (e) {
      print("Error during decryption: $e");
      return ''; // Kembalikan string kosong jika terjadi kesalahan
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
    final decryptedData = dekripsiData(encryptedData);
    print('Data terdekripsi: $decryptedData');
  }

  // Metode untuk menyembunyikan bagian pertama dari data
  String hidePartialData(String data, {int visibleCharacters = 4}) {
    if (data.length <= visibleCharacters) {
      return data;
    } else {
      return '*' * (data.length - visibleCharacters) +
          data.substring(data.length - visibleCharacters);
    }
  }

  final count = 0.obs;

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

  void increment() => count.value++;
}
