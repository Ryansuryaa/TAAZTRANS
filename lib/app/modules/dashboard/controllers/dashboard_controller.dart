// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/datamobilmodel.dart';

class DashboardController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<List<DataMobilModel>> firestoreDataMobilList;

  @override
  void onInit() {
    super.onInit();
    firestoreDataMobilList = firestore.collection('DataMobil').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map(
                (documentSnapshot) => DataMobilModel.fromJson(documentSnapshot))
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
