import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:tree_view/tree_view.dart';

import 'package:pesantren_flutter/network/response/ringkasan_response.dart';

class PaymentMethodScreen extends StatefulWidget {
  List<Bayar> bayar;
  Function(Bayar) onSelectPayment;

  PaymentMethodScreen(this.bayar, this.onSelectPayment);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool bankTransferExpanded = false;

  @override
  Widget build(BuildContext context) {
    var metodes =
        widget.bayar.map((e) => e.metodeBayar ?? "").toList().toSet().toList();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: MyColors.grey_60,
              ))
        ],
        title: const Text(
          "Pilih metode pembayaran",
          style: TextStyle(color: MyColors.grey_50, fontSize: 14),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: TreeView(
          startExpanded: false,
          children: metodes
                  .map((e) => Column(
                        children: [
                          TreeViewChild(
                              startExpanded: true,
                              parent: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          bankTransferExpanded =
                                              !bankTransferExpanded;
                                          setState(() {});
                                        },
                                        child: Text(
                                          e ?? "",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: MyColors.primary),
                                        )),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          bankTransferExpanded =
                                              !bankTransferExpanded;
                                          setState(() {});
                                        },
                                        child: bankTransferExpanded
                                            ? const Icon(
                                                Icons.keyboard_arrow_down_sharp)
                                            : const Icon(Icons
                                                .keyboard_arrow_right_sharp))
                                  ],
                                ),
                              ),
                              children: widget.bayar
                                  .where((element) => element.metodeBayar == e)
                                  .map(
                                    (ev) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: InkWell(
                                        onTap: () {
                                          widget.onSelectPayment(ev);
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: Image.network(
                                                ev.detail?.metodeBankLogo ?? "",
                                                width: 50,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Center(
                                                    child: Container(
                                                      child: const Text(
                                                        "No Image",
                                                        style: TextStyle(
                                                            fontSize: 7),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ev.detail?.kode ?? "",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  // Text("Rp.125.000",style: TextStyle(color: MyColors.grey_60),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()),
                          const Divider(),
                        ],
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
