import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/konfirmasi/controller_konfirmasi.dart';
import 'package:pesantren_flutter/ui/konfirmasi/detail_konfirmasi.dart';
import 'package:pesantren_flutter/ui/konfirmasi/upload_bukti.dart';
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
  List iconConfrim = [
    'assets/ikon ditolak.svg',
    'assets/ikon verif.svg',
    'assets/ikon menunggu.svg',
    'assets/ikon ditolak.svg'
  ];
  List warna = [Colors.red, Colors.green, Colors.grey, Colors.red];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            return RefreshIndicator(
              onRefresh: () async {
                _.getKonfirmasi();
              },
              child: _.check
                  ? _.isLoadingKonfirmasi
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
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10, bottom: 7),
                                    child: Card(
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
                                                  SvgPicture.asset(
                                                    iconConfrim[int.parse(_
                                                            .listKonfirmasi[
                                                                index]
                                                            .detail
                                                            ?.status ??
                                                        '$def')],
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(_
                                                                .listKonfirmasi[
                                                                    index]
                                                                .detail
                                                                ?.catatan ??
                                                            ''),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(DateFormat(
                                                              "dd MMM yyyy")
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
                                    ),
                                  );
                                }),
                            const SizedBox(
                              height: 80,
                            )
                          ],
                        )
                  : const Center(
                      child: Text('Tidak Ada'),
                    ),
            );
          }),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () async {
            Get.to(const UploadBuktiPage());
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
