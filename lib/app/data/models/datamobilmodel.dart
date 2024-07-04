import 'package:cloud_firestore/cloud_firestore.dart';

class DataMobilModel {
  String? id;
  String? namaMobil;
  String? merek;
  String? noPolisi;
  String? hargaPerHari;
  String? tipeBahanBakar;
  String? tahun;
  String? deskripsi;
  String? fotoMobil;

  DataMobilModel({
    this.id,
    this.namaMobil,
    this.merek,
    this.noPolisi,
    this.hargaPerHari,
    this.tipeBahanBakar,
    this.tahun,
    this.deskripsi,
    this.fotoMobil,
  });

  factory DataMobilModel.fromJson(DocumentSnapshot data) {
    final json = data.data() as Map<String, dynamic>;
    return DataMobilModel(
      id: json['id'],
      namaMobil: json['namaMobil'],
      merek: json['merek'],
      noPolisi: json['noPolisi'],
      hargaPerHari: json['hargaPerHari'],
      tipeBahanBakar: json['tipeBahanBakar'],
      tahun: json['tahun'],
      deskripsi: json['deskripsi'],
      fotoMobil: json['fotoMobil'],
    );
  }
}
