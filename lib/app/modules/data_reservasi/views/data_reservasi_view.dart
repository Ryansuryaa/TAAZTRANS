import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/theme.dart';
import '../controllers/data_reservasi_controller.dart';
import 'package:az_travel/app/data/models/pesananmobilmodel.dart';

class DataReservasiView extends GetView<DataReservasiController> {
  const DataReservasiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DataReservasiController());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            right: 2.5.w,
            left: 2.5.w,
          ),
          child: const Text('Reservasi Mobil'),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder<List<PesananMobil>>(
          stream: c.firestorePesananMobillList,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final pesananMobilList = snap.data!;

            if (pesananMobilList.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('Data kosong.'),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(
                top: 0.1.h,
              ),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: pesananMobilList.length,
              itemBuilder: (context, index) {
                var dataPesananMobil = pesananMobilList[index];

                // Decrypt the namaPemesan field
                String namaPemesanDecrypted = c.dekripsiData(
                    {'data': dataPesananMobil.namaPemesan})['data'];

                final formatCurrency = NumberFormat.simpleCurrency(
                    locale: 'id_ID', decimalDigits: 0);
                int hargaPerHariIDR = int.parse(dataPesananMobil.harga!);
                final dateFormatter = DateFormat('d MMMM yyyy', 'id-ID');
                var tanggalPesanStartFormatted = dateFormatter.format(
                    DateTime.parse(dataPesananMobil.tanggalPesanStart!));
                var tanggalPesanEndFormatted = dateFormatter
                    .format(DateTime.parse(dataPesananMobil.tanggalPesanEnd!));

                return Padding(
                  padding: EdgeInsets.only(bottom: 2.h, right: 5.w, left: 5.w),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 15.h,
                      decoration: BoxDecoration(
                        color: black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${dataPesananMobil.namaMobil}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Pemesan : $namaPemesanDecrypted'),
                                Text(
                                    'Tanggal Pesanan : \n$tanggalPesanStartFormatted ${dataPesananMobil.tanggalPesanEnd == dataPesananMobil.tanggalPesanStart ? '' : '- $tanggalPesanEndFormatted'}'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency.format(hargaPerHariIDR),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
