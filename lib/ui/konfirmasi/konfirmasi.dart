import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/konfirmasi/controller_konfirmasi.dart';
import 'package:pesantren_flutter/ui/konfirmasi/detail_konfirmasi.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';

class Konfirmasi extends StatefulWidget {
  const Konfirmasi({Key? key}) : super(key: key);

  @override
  State<Konfirmasi> createState() => _KonfirmasiState();
}

class _KonfirmasiState extends State<Konfirmasi> {
  @override
  void initState() {
    Get.put(KonfirmasiController());
    super.initState();
  }

  int def = 0;
  List status = [
    'Dibatalkan',
    'Diverifikasi',
    'Menunggu Verifikasi',
    'Ditolak'
  ];
  List warna = [Colors.red, Colors.green, Colors.grey, Colors.red];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text("Konfirmasi Pembayaran"),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<KonfirmasiController>(
          initState: (state) => KonfirmasiController.to.getKonfirmasi(),
          builder: (_) {
            return _.listKonfirmasi.isEmpty
                ? const Center(
                    child: Text('Tidak Ada'),
                  )
                : _.isLoadingKonfirmasi
                    ? ProgressLoading()
                    : ListView(
                        children: [
                          // ignore: prefer_const_constructors
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _.listKonfirmasi.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(DetailKOnfirmasi(
                                          _.listKonfirmasi[index]));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons
                                                  .confirmation_num_outlined),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(_.listKonfirmasi[index]
                                                            .detail?.catatan ??
                                                        ''),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(DateFormat("dd MMM yyyy")
                                                      .format(DateTime.parse((_
                                                                  .listKonfirmasi[
                                                                      index]
                                                                  .tanggal ??
                                                              '')
                                                          .split(' ')
                                                          .first))),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    status[int.parse(_
                                                            .listKonfirmasi[
                                                                index]
                                                            .detail
                                                            ?.status ??
                                                        '$def')],
                                                    style: TextStyle(
                                                        color: warna[int.parse(_
                                                                .listKonfirmasi[
                                                                    index]
                                                                .detail
                                                                ?.status ??
                                                            '$def')]),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      );
          }),
      bottomSheet: Container(
        color: const Color(0xffF9F9F9),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
            backgroundColor: MaterialStateProperty.all(const Color(0xffF9F9F9)),
          ),
          onPressed: () async {
            // Get.to(AddIzin(isIzinKeluar: true));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  // ignore: unnecessary_const
                  color: MyColors.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Upload Bukti",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.apply(color: MyColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
