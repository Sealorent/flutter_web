import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/edit_profile/edit_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/transaction/controller/detail_transaksi_detail_controller.dart';
import 'package:pesantren_flutter/ui/transaction/controller/list_transaksi_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/response/pesantren_login_response.dart';
import '../../../network/response/student_login_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/screen_utils.dart';
import '../../utils/number_utils.dart';

class TranscationDetailScreen extends StatefulWidget {
  int id;
  bool isHistory;
  TranscationDetailScreen(this.id,this.isHistory,{Key? key}) : super(key: key);

  @override
  State<TranscationDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TranscationDetailScreen> {

   Widget detailHistory() => GetBuilder<ListTransaksiController>(
      initState: (state) =>
          ListTransaksiController.to.getHistory(),
      builder: (_) {
        return ListView(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.money),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Bayar Tagihan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "STATUS",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Selesai",
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Center(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                _.listHistory[widget.id].bayarVia??"",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(( _.listHistory[widget.id].namaBayar??"")
                                  .split('-')
                                  .first)
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_sharp,
                              color: Colors.black54)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "TANGGAL TRANSAKSI",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat("dd MMM yyyy")
                      .format(DateTime.parse( _.listHistory[widget.id].tanggal??"")),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "NO. REF",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                   _.listHistory[widget.id].noRef??"",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            color: Colors.black12,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("RINCIAN PEMBAYARAN"),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text("Item (1)", style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    const Text(
                      "Jumlah",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                        ( _.listHistory[widget.id].namaBayar??"").split(' ').first +
                            ' ' +
                            DateFormat("MMM yyyy").format(
                                DateTime.parse( _.listHistory[widget.id].tanggal??"")),
                        style: const TextStyle(fontSize: 16)),
                    const Spacer(),
                    Text(
                      _.listHistory[widget.id].nominal??"",
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text("TOTAL", style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(
                       _.listHistory[widget.id].nominal??"",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]);
      });

      Widget detailTransaksi() => GetBuilder<DetailTransaksiController>(
      initState: (state) =>
          DetailTransaksiController.to.detailTransaksi("${widget.id}"),
      builder: (_) {
        return ListView(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.money),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Detail Transaksi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "STATUS",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _.dataRingkasan?.status??"",
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Center(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                               _.dataRingkasan?.bayarVia??"",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(  _.dataRingkasan?.bank??"")                    
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_sharp,
                              color: Colors.black54)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "TANGGAL TRANSAKSI",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _.dataRingkasan?.expired??"",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "NO. REF",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                   _.dataRingkasan?.noref??"",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            color: Colors.black12,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("RINCIAN PEMBAYARAN"),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text("Item (${_.ringkasanBulan.length + _.ringkasanBebas.length ?? 0})", style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    const Text(
                      "Jumlah",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _.ringkasanBulan.length,
                              itemBuilder: (context, index) {
                                return _.ringkasanBulan.isNotEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    _.ringkasanBulan[index]
                                                            .namaBayar ??
                                                        ""),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Text(NumberUtils.toRupiah(
                                                  double.parse(_
                                                          .ringkasanBulan[
                                                              index]
                                                          .nominal ??
                                                      ""))),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              
                                            ],
                                          ),
                                          // const Divider(),
                                        ],
                                      ),
                                    )
                                    : Container();
                              }),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _.ringkasanBebas.length,
                              itemBuilder: (context, index) {
                                return _.ringkasanBebas.isNotEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    _.ringkasanBebas[index]
                                                            .namaBayar ??
                                                        ""),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Text(NumberUtils.toRupiah(
                                                  double.parse(_
                                                          .ringkasanBebas[
                                                              index]
                                                          .nominal ??
                                                      ""))),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                             
                                            ],
                                          ),
                                          // const Divider(),
                                        ],
                                      ),
                                    )
                                    : Container();
                              }),
                // Row(
                //   children: [
                //     Text(
                //         ( _.listHistory[widget.id].namaBayar??"").split(' ').first +
                //             ' ' +
                //             DateFormat("MMM yyyy").format(
                //                 DateTime.parse( _.listHistory[widget.id].tanggal??"")),
                //         style: const TextStyle(fontSize: 16)),
                //     const Spacer(),
                //     Text(
                //       _.listHistory[widget.id].nominal??"",
                //       style: const TextStyle(fontSize: 16),
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text("TOTAL", style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(
                       NumberUtils.toRupiah(
                                                  double.parse("${_.nominal}")),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColors.grey_5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Detail Transaksi", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
        },
        child: widget.isHistory ? detailHistory() : detailTransaksi()
      ),
    );
  }
}
