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
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/transaction/controller/list_transaksi_controller.dart';
import 'package:pesantren_flutter/ui/transaction/model/model_list_transaksi.dart';
import 'package:pesantren_flutter/ui/transaction/transaction_detail_screen.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/year_model.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/my_snackbar.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/year_util.dart';
import '../../../widget/option_radio.dart';
import '../../payment/payment_bloc.dart';
import '../../payment/payment_state.dart';
import '../model/item_filter_model.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  late PaymentBloc bloc;
  // bool _isLoading = true;
  List<ListTransaksi>? _ListTransaksiresponse;
  List<History>? _historyResponse;

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

  int ParseDateHistoryResponse(date) {
    return int.parse(DateFormat("y").format(DateTime.parse(date)));
  }

  whereDate(resYear, startYear, endYear) {
    return ParseDateResponse(resYear) >= ParseSelectedDate(startYear) &&
        ParseDateResponse(resYear) <= ParseSelectedDate(endYear);
  }

  whereDateHistory(resYear, startYear, endYear) {
    return ParseDateHistoryResponse(resYear) >= ParseSelectedDate(startYear) &&
        ParseDateHistoryResponse(resYear) <= ParseSelectedDate(endYear);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ListTransaksiController>(
          initState: (state) => ListTransaksiController.to.getHistory(),
          builder: (_) {
            _ListTransaksiresponse = _.listTransaksi.where((el) {
              if (selectedYear != null) {
                if (listFilter[1].isFilterActive == true) {
                  return el.status != "PENDING" &&
                      whereDate(el.tanggal, selectedYear!.startYear.toString(),
                          selectedYear!.endYear.toString());
                } else if (listFilter[2].isFilterActive == true) {
                  return el.status == "PENDING" &&
                      whereDate(el.tanggal, selectedYear!.startYear.toString(),
                          selectedYear!.endYear.toString());
                } else {
                  return whereDate(
                      el.tanggal,
                      selectedYear!.startYear.toString(),
                      selectedYear!.endYear.toString());
                }
              } else {
                if (listFilter[1].isFilterActive == true) {
                  return el.status != "PENDING";
                } else if (listFilter[2].isFilterActive == true) {
                  return el.status == "PENDING";
                } else {
                  return true;
                }
              }
            }).toList();

            _historyResponse = _.listHistory.where((el) {
              if (selectedYear != null) {
                return whereDateHistory(
                    el.tanggal,
                    selectedYear!.startYear.toString(),
                    selectedYear!.endYear.toString());
              } else {
                return true;
              }
            }).toList();

            _.status = ["LUNAS", "EXPIRED", "PENDING"];
            return RefreshIndicator(
                onRefresh: () async {
                  _.getHistory();
                },
                child: _.check
                    ? _.isLoadingHistory
                        ? ProgressLoading()
                        : ListView(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 32,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listFilter.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  itemBuilder: (context, index) {
                                    var item = listFilter[index];
                                    if (index == 0) {
                                      return InkWell(
                                        onTap: () {
                                          _modalBottomSheetMenu();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: selectedYear != null
                                                  ? MyColors.primary
                                                      .withOpacity(0.3)
                                                  : const Color(0xffEBF6F3),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16.0)),
                                              border: Border.all(
                                                color: MyColors.grey_20,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Center(
                                                child: Row(
                                              children: [
                                                Visibility(
                                                  visible: selectedYear != null,
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.check,
                                                        color: MyColors.primary,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  selectedYear?.title ??
                                                      "Semua Tahun",
                                                  style: const TextStyle(
                                                      color: MyColors.primary),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: FilterChip(
                                            label: Text(
                                              item.name,
                                              style: const TextStyle(
                                                  color: MyColors.primary),
                                            ),
                                            selected: item.isFilterActive,
                                            backgroundColor:
                                                const Color(0xffEBF6F3),
                                            shape: const StadiumBorder(
                                                side: BorderSide(
                                                    color: MyColors.grey_20)),
                                            selectedColor: MyColors.primary
                                                .withOpacity(0.3),
                                            checkmarkColor: MyColors.primary,
                                            onSelected: (_) {
                                              setState(() =>
                                                  item.isFilterActive =
                                                      !item.isFilterActive);
                                              listFilter;
                                              setState(() {});
                                            }),
                                      );
                                    }
                                  },
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _ListTransaksiresponse!.length,
                                  itemBuilder: (context, indexTransaksi) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(TranscationDetailScreen(
                                              int.parse(_
                                                      .listTransaksi[
                                                          indexTransaksi]
                                                      .idTransaksi ??
                                                  ""),
                                              false));
                                        },
                                        child: Column(
                                          children: [
                                            const Divider(),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              children: [
                                                const FaIcon(
                                                  FontAwesomeIcons.moneyBill,
                                                  color: Colors.black54,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "No. Trans#${_.listTransaksi[indexTransaksi].idTransaksi ?? "0"}",
                                                        style: const TextStyle(
                                                          fontFamily: "Mulish",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 17,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.87),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 1,
                                                      ),
                                                      Text(
                                                        _
                                                                .listTransaksi[
                                                                    indexTransaksi]
                                                                .status ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontFamily: 'Mulish',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.87),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat("dd MMM yyyy")
                                                          .format(DateTime.parse((_
                                                                      .listTransaksi[
                                                                          indexTransaksi]
                                                                      .tanggal ??
                                                                  "")
                                                              .split(" ")
                                                              .first)),
                                                      style: const TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.87),
                                                      ),
                                                    ),
                                                    Text(
                                                      ((_
                                                                  .listTransaksi[
                                                                      indexTransaksi]
                                                                  .tanggal ??
                                                              "")
                                                          .split(" ")
                                                          .last),
                                                      style: const TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.87),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              const SizedBox(
                                height: 6,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _historyResponse!.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                              TranscationDetailScreen(i, true));
                                        },
                                        child: Column(
                                          children: [
                                            const Divider(),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              children: [
                                                const FaIcon(
                                                  FontAwesomeIcons.wallet,
                                                  color: Colors.black54,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        (_historyResponse![i]
                                                                    .namaBayar ??
                                                                '')
                                                            .split('-')
                                                            .first,
                                                        style: const TextStyle(
                                                          fontFamily: "Mulish",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 17,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.87),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 1,
                                                      ),
                                                      const Text(
                                                        "LUNAS",
                                                        style: TextStyle(
                                                          fontFamily: 'Mulish',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.87),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat("dd MMM yyyy")
                                                          .format(DateTime.parse(
                                                              _historyResponse![
                                                                          i]
                                                                      .tanggal ??
                                                                  '')),
                                                      style: const TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.87),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "15:31",
                                                      style: TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.87),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              //   child:
                              //   InkWell(
                              //     onTap: (){
                              //       SnackBar()
                              //       ScreenUtils(context).navigateTo(TranscationDetailScreen());
                              //     },
                              //     child:
                              //     Column(
                              //       children: _response?.laporan?.where((element) {
                              //         var date = element.tanggal;
                              //         if(selectedYear != null && date != null){
                              //           return date.isAfter(selectedYear!.startYear) && date.isBefore(selectedYear!.endYear);
                              //         }else{
                              //           return true;
                              //         }
                              //         return true;
                              //       }).map((e) => Column(
                              //         children: [
                              //           Row(
                              //             children: [
                              //               FaIcon(FontAwesomeIcons.moneyBill, color: MyColors.grey_50,),
                              //               SizedBox(width: 20,),
                              //               Column(
                              //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(e.detail?.bayarVia ?? "", style: TextStyle(fontSize: 16),),
                              //                   Text(e.detail?.nominal ?? "", style: TextStyle(color: Colors.red),),
                              //                 ],
                              //               ),
                              //               Spacer(),
                              //               Column(
                              //                 crossAxisAlignment: CrossAxisAlignment.end,
                              //                 children: [
                              //                   Text(e.detail?.tanggal ?? "", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),
                              //                   // Text("15:31", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),

                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              //           SizedBox(height: 10,),
                              //           Divider(),
                              //           SizedBox(height: 10,),
                              //         ],
                              //       )).toList() ?? [],
                              //     ),
                              //   ),
                              // )
                            ],
                          )
                    : Container());
          }),
    );
  }
}
