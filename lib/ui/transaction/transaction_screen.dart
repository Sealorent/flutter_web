import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/response/history_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/tabungantransaction_screen.dart';
import 'package:pesantren_flutter/ui/transaction/transaction_view/transaction_view.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/transaction/controller/list_transaksi_controller.dart';
import 'package:pesantren_flutter/ui/transaction/model/model_list_transaksi.dart';
import 'package:pesantren_flutter/ui/transaction/transaction_detail_screen.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/year_model.dart';
import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/screen_utils.dart';
import '../../utils/year_util.dart';
import '../../widget/option_radio.dart';
import '../payment/payment_bloc.dart';
import '../payment/payment_state.dart';
import 'model/item_filter_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late PaymentBloc bloc;
  // bool _isLoading = true;
  List<ListTransaksi>? _ListTransaksiresponse;

  // @override
  // void initState() {
  //   bloc = BlocProvider.of<PaymentBloc>(context);
  //   getData();
  //   super.initState();
  // }

  // void getData(){
  //   bloc.add(GetHistory());
  // }

  List<ItemFilter> listFilter = [
    ItemFilter(1, 'Semua Tahun', false),
    ItemFilter(2, 'Selesai', false),
    ItemFilter(3, 'Menunggu Pembayaran', false),
  ];

  YearModel? selectedYear;

  int ParseDateResponse(date) {
    return int.parse(
        DateFormat("y").format(DateTime.parse((date!).split(" ").first)));
  }

  int ParseSelectedDate(date) {
    return int.parse(
        DateFormat("y").format(DateTime.parse(date.split(" ").first)));
  }

  whereDate(resStartYear, resEndYear, startYear, endYear) {
    return ParseDateResponse(resStartYear) >= ParseSelectedDate(startYear) &&
        ParseDateResponse(resEndYear) >= ParseSelectedDate(endYear);
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 50,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: MyColors.grey_20,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pilih tahun ajaran",
                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedYear = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            const Text(
                              "Semua",
                              style: TextStyle(fontSize: 18),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: YearUtils.getYearModel(2020)
                          .reversed
                          .map((e) => Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedYear = e;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            e.title,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  // void listener(BuildContext context, PaymentState state) async {
  //   if (state is GetHistoryLoading) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //   } else if (state is GetHistorySuccess) {
  //     setState(() {
  //       _isLoading = false;
  //       _response = state.response;
  //     });
  //   } else if (state is FailedState) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (state.code == 401 || state.code == 0) {
  //       // MySnackbar(context)
  //       //     .errorSnackbar("Terjadi kesalahan");
  //       return;
  //     }

  //     MySnackbar(context)
  //         .errorSnackbar(state.message + " : " + state.code.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
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
            "Transaksi",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white),
            tabs: [
              Tab(
                text: "Transaksi",
              ),
              Tab(
                text: "Tabungan",
              ),
            ],
            indicatorColor: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [TransactionView(), TabunganTransaction()],
        ),
      ),
    );
  }
}
