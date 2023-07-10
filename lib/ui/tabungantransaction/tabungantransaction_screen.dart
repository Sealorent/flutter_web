import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/controller/list_transaksi_tabungan_controller.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/model/model_list_transaksi_tabungan.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/tabungan_transaction_detail_screen.dart';
import 'package:pesantren_flutter/ui/transaction/model/item_filter_model.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/year_model.dart';
import '../../utils/year_util.dart';

class TabunganTransaction extends StatefulWidget {
  const TabunganTransaction({super.key});

  @override
  State<TabunganTransaction> createState() => _TabunganTransactionState();
}

class _TabunganTransactionState extends State<TabunganTransaction> {
  List<ListTransaksiTabungan>? _listTransaksiTabunganResponse;
  List<ListTransaksiTabungan> _listTransaksiPaginate = [];
  PaginationResponse? paginationResponse;
  int page = 0;
  int lastPage = 0;
  int numberPost = 10;
  bool endPage = false;
  bool first = true;
  bool loader = false;

  YearModel? selectedYear;

  List<ItemFilter> listFilter = [
    ItemFilter(1, 'Semua Tahun', false),
    ItemFilter(2, 'Selesai', false),
    ItemFilter(3, 'Menunggu Pembayaran', false),
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    _refreshController.resetNoData();
    _onLoading();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  int ParseDateResponse(date) {
    return int.parse(
        DateFormat("y").format(DateTime.parse((date!).split(" ").first)));
  }

  int ParseSelectedDate(date) {
    return int.parse(
        DateFormat("y").format(DateTime.parse(date.split(" ").first)));
  }

  whereDate(resYear, startYear, endYear) {
    return ParseDateResponse(resYear) >= ParseSelectedDate(startYear) &&
        ParseDateResponse(resYear) <= ParseSelectedDate(endYear);
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
                        reset();
                        setState(() {
                          selectedYear = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: const [
                            Text(
                              "Semua",
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            Icon(
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
                                      reset();
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

  void reset() {
    page = 1;
    _listTransaksiPaginate = [];
    first = true;
  }

  void setAwal() async {
    if (first == true) {
      if (page == 0) {
        page = page + 1;
        paginationResponse =
            paginateList(_listTransaksiTabunganResponse, page, numberPost);
        _listTransaksiPaginate.addAll(paginationResponse!.data!.toList());
        print("paginate${paginationResponse!.data!.map((e) => e.idTransaksi)}");
      } else {
        paginationResponse =
            paginateList(_listTransaksiTabunganResponse, page, numberPost);
        _listTransaksiPaginate = [];
        _listTransaksiPaginate.addAll(paginationResponse!.data!.toList());
      }
      loader = false;
      setState(() {});
    } else {
      first = false;
    }
  }

  void _onLoading() async {
    first = false;
    lastPage = (_listTransaksiTabunganResponse!.length / numberPost).round();

    if (page > lastPage) {
      endPage = true;
      setState(() {});
    } else {
      page = page + 1;
      paginationResponse =
          paginateList(_listTransaksiTabunganResponse, page, numberPost);
      _listTransaksiPaginate.addAll(paginationResponse!.data!.toList());
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<ListTransaksiTabunganController>(
            initState: (state) =>
                ListTransaksiTabunganController.to.getHistory(),
            builder: (_) {
              _listTransaksiTabunganResponse =
                  _.listTransaksiTabungan.where((el) {
                if (selectedYear != null) {
                  if (listFilter[1].isFilterActive == true) {
                    return el.status != "PENDING" &&
                        whereDate(
                            el.tanggal,
                            selectedYear!.startYear.toString(),
                            selectedYear!.endYear.toString());
                  } else if (listFilter[2].isFilterActive == true) {
                    return el.status == "PENDING" &&
                        whereDate(
                            el.tanggal,
                            selectedYear!.startYear.toString(),
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
              setAwal();
              return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  // header: WaterDropHeader(),
                  // footer: const Text('s'),
                  footer: CustomFooter(
                    builder: (BuildContext context, mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        if (endPage) {
                          body = const Text("No more Data");
                        } else {
                          body = const CupertinoActivityIndicator();
                        }
                      } else if (mode == LoadStatus.loading) {
                        body = const CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        _.getHistory();
                        body = const Text("Load Failed! Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const CupertinoActivityIndicator();
                      } else {
                        body = const Text("No more Data");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: loader
                      ? ProgressLoading()
                      : ListView(
                          children: [
                            SizedBox(height: 15),
                            SizedBox(
                              height: 32,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: listFilter.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
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
                                          selectedColor:
                                              MyColors.primary.withOpacity(0.3),
                                          checkmarkColor: MyColors.primary,
                                          onSelected: (_) {
                                            setState(() => item.isFilterActive =
                                                !item.isFilterActive);
                                            listFilter;
                                            reset();
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
                                itemCount: _listTransaksiPaginate.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(TransactionTabunganDetailScreen(
                                            int.parse(_listTransaksiPaginate[i]
                                                    .idTransaksi ??
                                                "")));
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "No. Trans#${_listTransaksiPaginate[i].idTransaksi ?? "0"}",
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
                                                      _listTransaksiPaginate[i]
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
                                                        .format(DateTime.parse(
                                                            (_listTransaksiPaginate[
                                                                            i]
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
                                                    ((_listTransaksiPaginate[i]
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
                          ],
                        ));
              }
            
            ));
  }
}
