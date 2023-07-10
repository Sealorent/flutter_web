import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/controller/detail_transaksi_detail_controller.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';

class TransactionTabunganDetailScreen extends StatefulWidget {
  int id;
  TransactionTabunganDetailScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<TransactionTabunganDetailScreen> createState() =>
      _TransactionTabunganDetailScreenState();
}

class _TransactionTabunganDetailScreenState
    extends State<TransactionTabunganDetailScreen> {
  Widget detailTransaksiTabungan() => GetBuilder<
          DetailTransaksiTabunganController>(
      initState: (state) =>
          DetailTransaksiTabunganController.to.detailTransaksi("${widget.id}"),
      builder: (_) {
        return _.isLoading
            ? ProgressLoading()
            : Column(
                children: [
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
                              "Detail Transaksi Tabungan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                          _.data?.status ?? "",
                          style: const TextStyle(color: Colors.green),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${_.data!.bayarVia!} ${_.data!.bank!}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _.data!.va.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () async => await Clipboard.setData(
                                    ClipboardData(text: _.data!.va.toString())),
                                icon: const Icon(Icons.copy))
                          ],
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
                          _.data?.expired ?? "",
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
                          _.data?.noref ?? "",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              );
      });

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
            color: MyColors.grey_5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Detail Transaksi Tabungan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          onRefresh: () async {}, child: detailTransaksiTabungan()),
    );
  }
}
