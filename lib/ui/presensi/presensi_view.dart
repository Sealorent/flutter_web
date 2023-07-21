import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/model/year_model.dart';
import 'package:pesantren_flutter/network/response/presensi_response.dart';
import 'package:pesantren_flutter/network/response/rekam_medis_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/pay_bills_screen.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_bloc.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_event.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_state.dart';
import 'package:pesantren_flutter/ui/saving/saving_bloc.dart';

import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/utils/year_util.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class PresensiView extends StatefulWidget {
  const PresensiView({Key? key}) : super(key: key);

  @override
  State<PresensiView> createState() => _PresensiViewState();
}

class _PresensiViewState extends State<PresensiView> {
  late RekamMedisBloc bloc;
  bool _isLoading = true;
  PresensiResponse? _presensiResponse;

  final listFilter = <ItemFilter>[
    ItemFilter(1, 'Semua Tahun', false),
  ];

  YearModel? selectedYear;
  int selectedMonth = DateTime.now().month - 6;

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
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 50,
                  height: 8,
                  decoration: BoxDecoration(
                    color: MyColors.grey_20,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pilih tahun ajaran",
                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                ),
              ),
              SizedBox(
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
                    SizedBox(
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

  void _monthBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 50,
                  height: 8,
                  decoration: BoxDecoration(
                    color: MyColors.grey_20,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pilih bulan",
                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 7;
                                Navigator.pop(context);
                              });
                              getData();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Januari",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 8;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Februari",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 9;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Maret",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 10;
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "April",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 11;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Mei",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 12;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Juni",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 1;
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Juli",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 2;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Agustus",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 3;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "September",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 4;
                                getData();
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Oktober",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 5;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "November",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMonth = 6;
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  border: Border.all(
                                    color: MyColors.grey_20,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Desember",
                                  style: TextStyle(color: MyColors.grey_80),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    bloc = BlocProvider.of<RekamMedisBloc>(context);
    getData();
    super.initState();
  }

  void getData() {
    bloc.add(GetPresensi(selectedMonth));
  }

  void listener(BuildContext context, RekamMedisState state) async {
    if (state is GetPresensiLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetPresensiSuccess) {
      setState(() {
        _isLoading = false;
        _presensiResponse = state.response;
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        // MySnackbar(context)
        //     .errorSnackbar("Terjadi kesalahan");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<RekamMedisBloc, RekamMedisState>(
      listener: listener,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            selectedYear = null;
            setState(() {});
            getData();
          },
          child: _isLoading
              ? ProgressLoading()
              : ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 32,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Tahun ajaran"),
                            ),
                            InkWell(
                              onTap: () {
                                // setState(() {
                                //   selectedYear = "2021/2022";
                                // });
                                _modalBottomSheetMenu();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: selectedYear != null
                                        ? MyColors.primary.withOpacity(0.3)
                                        : Color(0xffEBF6F3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
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
                                            Icon(
                                              Icons.check,
                                              color: MyColors.primary,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        selectedYear?.title ?? "Semua Tahun",
                                        style:
                                            TextStyle(color: MyColors.primary),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // setState(() {
                                //   selectedYear = "2021/2022";
                                // });
                                _monthBottomSheetMenu();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: selectedYear != null
                                        ? MyColors.primary.withOpacity(0.3)
                                        : Color(0xffEBF6F3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
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
                                            Icon(
                                              Icons.check,
                                              color: MyColors.primary,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        DateFormat("MMM").format(DateTime(
                                            2000, selectedMonth + 6, 2)),
                                        style:
                                            TextStyle(color: MyColors.primary),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: generateList().isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Text("Tidak ada data"),
                              ),
                            )
                          : Column(children: generateList()),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> generateList() {
    return _presensiResponse?.laporan
            ?.where((element) {
              var date = element.detail?.tanggal;
              if (selectedYear != null && date != null) {
                return date.isAfter(selectedYear!.startYear) &&
                    date.isBefore(selectedYear!.endYear);
              } else {
                return true;
              }
            })
            .map((e) => InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat("dd MMM yyyy")
                                .format(e.detail?.tanggal ?? DateTime.now()),
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            e.detail?.kehadiran == "H" ? "Hadir" : "Absen",
                            style: TextStyle(
                                fontSize: 12,
                                color: e.detail?.kehadiran == "H"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
            .toList() ??
        [];
  }
}
