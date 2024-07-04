// ignore_for_file: unnecessary_overrides

import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataPelangganController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<List<UserModel>> firestoreDataPelangganList;

  @override
  void onInit() {
    super.onInit();
    firestoreDataPelangganList = firestore
        .collection('DataPelanggan')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => UserModel.fromJson(documentSnapshot))
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
}
