import 'package:cloud_firestore/cloud_firestore.dart';

class PesananMobil {
  String? id;
  String? idMobil;
  String? harga;
  String? namaMobil;
  String? namaPemesan;
  String? noKTPPemesan;
  String? noTelpPemesan;
  String? alamatPemesan;
  String? tanggalPesanStart;
  String? tanggalPesanEnd;

  PesananMobil({
    this.id,
    this.idMobil,
    this.harga,
    this.namaMobil,
    this.namaPemesan,
    this.noKTPPemesan,
    this.noTelpPemesan,
    this.alamatPemesan,
    this.tanggalPesanStart,
    this.tanggalPesanEnd,
  });

  factory PesananMobil.fromJson(DocumentSnapshot data) {
    final json = data.data() as Map<String, dynamic>;
    return PesananMobil(
      id: json['id'],
      idMobil: json['idMobil'],
      harga: json['harga'],
      namaMobil: json['namaMobil'],
      namaPemesan: json['namaPemesan'],
      noKTPPemesan: json['noKTPPemesan'],
      alamatPemesan: json['alamatPemesan'],
      tanggalPesanStart: json['tanggalPesanStart'],
      tanggalPesanEnd: json['tanggalPesanEnd'],
    );
  }
}
