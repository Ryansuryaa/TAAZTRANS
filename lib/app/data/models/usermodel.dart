import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? photoUrl;
  String? email;
  String? roles;
  String? noKTP;
  String? username;
  String? namaLengkap;
  String? nomorTelepon;
  String? alamat;

  UserModel({
    this.uid,
    this.photoUrl,
    this.email,
    this.roles,
    this.noKTP,
    this.username,
    this.namaLengkap,
    this.nomorTelepon,
    this.alamat,
  });

  factory UserModel.fromJson(DocumentSnapshot data) {
    final json = data.data() as Map<String, dynamic>;
    return UserModel(
      uid: json['uid'],
      photoUrl: json['photoUrl'],
      email: json['email'],
      roles: json['roles'],
      noKTP: json['noKTP'],
      username: json['username'],
      namaLengkap: json['namaLengkap'],
      nomorTelepon: json['nomorTelepon'],
      alamat: json['alamat'],
    );
  }
}
