import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/network/param/ipaymu_param.dart';
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/cara_pembayaran_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/payment_method.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class PaymentDetailScreen extends StatefulWidget {
  String? noIpayMu;

  PaymentDetailScreen(this.noIpayMu);

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  late PaymentBloc bloc;
  bool _isLoading = true;
  RingkasanResponse? _response;
  Bayar? _selectedPayment;
  bool _insertIsLoading = false;
  IpaymuParam? _ipaymuParam;
  List<int> removedBebas = [];
  List<int> removedBulanan = [];

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    getData();
    super.initState();
  }

  void listener(BuildContext context, PaymentState state) async {
    if (state is GetRingkasanLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetRingkasanSuccess) {
      setState(() {
        _isLoading = false;
        _response = state.response;
      });
    } else if (state is InsertIpaymuLoading) {
      setState(() {
        _insertIsLoading = true;
      });
      ScreenUtils(context)
          .navigateTo(CaraPembayaranScreen(_ipaymuParam, _selectedPayment,false));
    } else if (state is InsertIpaymuSuccess) {
      setState(() {
        _insertIsLoading = false;
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
        _insertIsLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context).errorSnackbar(
            "Terjadi kesalahan, respon API tidak dapat terbaca.");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  void getData() {
    bloc.add(GetRingkasan(widget.noIpayMu ?? "", removedBebas, removedBulanan));
  }

  double getTotal() {
    var totalBebas = (_response?.bebas
            ?.map((e) => int.tryParse(e.nominal ?? "0") ?? 0)
            .toList() ??
        []); //.reduce((a, b) => a + b);
    var totalBulan = (_response?.bulan
            ?.map((e) => int.tryParse(e.nominal ?? "0") ?? 0)
            .toList() ??
        []); //.reduce((a, b) => a + b);
    var tbeb = 0;
    var tbul = 0;
    if (totalBebas.isNotEmpty) tbeb = totalBebas.reduce((a, b) => a + b);
    if (totalBulan.isNotEmpty) tbul = totalBulan.reduce((a, b) => a + b);

    return tbeb.toDouble() + tbul.toDouble();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<PaymentBloc, PaymentState>(
      listener: listener,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Ringkasan Pembayaran",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {},
          child: _isLoading
              ? ProgressLoading()
              : ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("No Ref"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            _response?.noref ?? "",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                  "ITEM (${(_response?.bulan?.length ?? 0) + (_response?.bebas?.length ?? 0)})",
                                  style: TextStyle(
                                      color: MyColors.grey_60, fontSize: 12)),
                              Spacer(),
                              Text(
                                "JUMLAH",
                                style: TextStyle(
                                    color: MyColors.grey_60, fontSize: 12),
                              ),
                              SizedBox(
                                width: 50,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: _response?.bulan
                                    ?.map((e) => Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        e.namaBayar ?? "")),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(NumberUtils.toRupiah(
                                                    double.tryParse(
                                                            e.nominal ?? "") ??
                                                        0.0)),
                                                Container(
                                                  width: 50,
                                                  child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "bebasId : ${e.bebasId}");
                                                        removedBulanan.add(
                                                            int.tryParse(
                                                                    e.bulanId ??
                                                                        "0") ??
                                                                0);
                                                        getData();
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .restore_from_trash_outlined,
                                                        color: Colors.red,
                                                      )),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ))
                                    .toList() ??
                                [],
                          ),
                          Column(
                            children: _response?.bebas
                                    ?.map((e) => Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        e.namaBayar ?? "")),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(NumberUtils.toRupiah(
                                                    double.tryParse(
                                                            e.nominal ?? "") ??
                                                        0.0)),
                                                Container(
                                                  width: 50,
                                                  child: InkWell(
                                                      onTap: () {
                                                        removedBebas.add(
                                                            int.tryParse(
                                                                    e.bebasId ??
                                                                        "0") ??
                                                                0);
                                                        getData();
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .restore_from_trash_outlined,
                                                        color: Colors.red,
                                                      )),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ))
                                    .toList() ??
                                [],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("TOTAL"),
                              Spacer(),
                              Text(
                                NumberUtils.toRupiah(getTotal()),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
        bottomSheet: PaymentMethod(
            context, _response?.bayar ?? [], _selectedPayment, (selected) {
          setState(() {
            _selectedPayment = selected;
          });
        }, () {
          var param = IpaymuParam(
            noref: _response?.noref,
            ipaymu_no_trans: widget.noIpayMu,
            nominal: getTotal().toInt().toString(),
            payment_channel: _selectedPayment?.metode,
          );

          if (param.isValid()) {
            _ipaymuParam = param;
            bloc.add(InsertIpaymu(param,false));
          } else {
            MySnackbar(context).errorSnackbar(
                "Data tidak valid, pilih metode pembayaran atau cek data lainnya.");
          }
        }, _insertIsLoading, false,
            () {

            }
        ),
      ),
    );
  }
}
