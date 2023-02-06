import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/konfirmasi/model_konfirmasi.dart';

class DetailKOnfirmasi extends StatefulWidget {
  Data? konfirmasi;
  DetailKOnfirmasi(this.konfirmasi, {Key? key}) : super(key: key);

  @override
  State<DetailKOnfirmasi> createState() => _DetailKOnfirmasiState();
}

class _DetailKOnfirmasiState extends State<DetailKOnfirmasi> {
  List status = [
    'Dibatalkan',
    'Diverifikasi',
    'Menunggu Verifikasi',
    'Ditolak'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${status[int.parse(widget.konfirmasi?.detail?.status ?? '')]}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat("dd MMM yyyy").format(DateTime.parse(
                    (widget.konfirmasi?.tanggal ?? '').split(' ').first))),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.konfirmasi?.detail?.catatan ?? ''),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    imageUrl: widget.konfirmasi?.detail?.gambar ?? '',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                        backgroundColor:
                            MaterialStateProperty.all(MyColors.primary),
                      ),
                      onPressed: () async {
                        // Get.to(AddIzin(isIzinKeluar: true));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Batalkan",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                        backgroundColor:
                            MaterialStateProperty.all(MyColors.primary),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Kembali",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
