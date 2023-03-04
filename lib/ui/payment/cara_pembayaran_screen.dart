import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/param/ipaymu_param.dart';
import 'package:pesantren_flutter/network/response/cara_pembayaran_response.dart';
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';
import 'package:pesantren_flutter/ui/transaction/controller/list_transaksi_controller.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/payment_method.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';
import 'package:collection/collection.dart';

class CaraPembayaranScreen extends StatefulWidget {
  IpaymuParam? ipaymuParam;
  Bayar? _selectedPayment;
  CaraPembayaranScreen(this.ipaymuParam, this._selectedPayment);

  @override
  State<CaraPembayaranScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<CaraPembayaranScreen> {
  late PaymentBloc bloc;
   bool sppExpanded = true;
  bool _isLoading = true;
  CaraPembayaranResponse? _response;

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    getData();
    super.initState();
  }

  void getData() {
    bloc.add(GetCaraPembayaran(widget.ipaymuParam));
  }

  void listener(BuildContext context, PaymentState state) async {
    if (state is GetCaraPembayaranLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetCaraPembayaranSuccess) {
      setState(() {
        _isLoading = false;
        _response = state.response;
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: listener,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => DashboardScreen(null)),
              (Route<dynamic> route) => route is DashboardScreen);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DashboardScreen(null)),
                    (Route<dynamic> route) => route is DashboardScreen);
                // Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            title: Text(
              "Cara Pembayaran",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.white,
          body: _isLoading
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
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      _response?.bank?.toUpperCase() ?? "",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      _response?.bayarVia ?? "",
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                              Image.network(widget._selectedPayment?.logo ?? "",
                                  width: 50, errorBuilder:
                                      (BuildContext context, Object exception,
                                          StackTrace? stackTrace) {
                                return Center(
                                  child: SvgPicture.network(widget._selectedPayment?.logo ?? "",height: 20,)
                                );
                              }),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "No Virtual Account",
                                    ),
                                    Text(
                                      _response?.va ?? "Tidak ada data",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                              Text(
                                "Salin",
                                style: TextStyle(color: MyColors.primary),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Column(
                                // ignore: sort_child_properties_last
                                children: [
                                  Text(
                                    "Total Pembayaran",
                                  ),
                                  TreeViewChild(startExpanded: false,parent: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  sppExpanded = !sppExpanded;
                                  setState(() {});
                                },
                                child: Text(
                                  NumberUtils.toRupiah(double.parse(
                                          _response?.nominal ?? "0")),
                                  style: TextStyle(fontSize: 20),
                                ),),
                                SizedBox(height: 40,),
                              InkWell(
                                onTap: () {
                                  sppExpanded = !sppExpanded;
                                  setState(() {});
                                },
                                child: sppExpanded
                                    ? Icon(Icons.keyboard_arrow_right_sharp)
                                    : Icon(Icons.keyboard_arrow_down_sharp))
                            ],
                          ), children: [Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Row(mainAxisSize: MainAxisSize.max,children: [
                              Text("Total Item ",style: TextStyle(fontSize: 15),),SizedBox(width: 50,),
                              Text(
                                      NumberUtils.toRupiah(double.parse(
                                              _response?.nominal ?? "0")-double.parse(
                                              _response?.fee ?? "0")),
                                      style: TextStyle(fontSize: 15)),
                            ],
                          ),Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                               Text("Biaya Admin",style: TextStyle(fontSize: 15),),SizedBox(width: 50,),
                              Text(
                                      NumberUtils.toRupiah(double.parse(
                                              _response?.fee ?? "0")),
                                      style: TextStyle(fontSize: 15)),
                            ],
                          )],)]),                        
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              Spacer(),
                              const Text(
                                "Salin",
                                style: TextStyle(color: MyColors.primary),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Bayar Sebelum",
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Tanggal "+DateFormat("dd MMM yyyy").format(DateTime.parse( (_response?.expired ?? "")
                                                  .split(" ")
                                                  .first))
                                          +
                                              ", Pukul " +
                                              (_response?.expired ?? "")
                                                  .split(" ")
                                                  .last,
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Petunjuk Pembayaran",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Html(
                            data:
                                _response?.carabayar?.firstOrNull?.bayar ?? "-",
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0)))),
                            onPressed: () async {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DashboardScreen(null)),
                                  (Route<dynamic> route) =>
                                      route is DashboardScreen);
                                      ListTransaksiController.to.getHistory();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Kembali ke Home",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.apply(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
