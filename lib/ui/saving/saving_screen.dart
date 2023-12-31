import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/pay_bills_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_bloc.dart';
import 'package:pesantren_flutter/ui/saving/saving_event.dart';
import 'package:pesantren_flutter/ui/saving/saving_state.dart';
import 'package:pesantren_flutter/ui/saving/saving_topup.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class SavingScreen extends StatefulWidget {
  const SavingScreen({Key? key}) : super(key: key);

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  late SavingBloc bloc;
  bool _isLoading = true;
  SavingResponse? _savingResponse;

  @override
  void initState() {
    bloc = BlocProvider.of<SavingBloc>(context);
    getData();
    super.initState();
  }

  void getData() {
    bloc.add(GetSavings());
  }

  void listener(BuildContext context, SavingState state) async {
    if (state is GetSavingLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetSavingSuccess) {
      setState(() {
        _isLoading = false;
        _savingResponse = state.response;
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

  void _detailBottomSheet(Laporan laporan) {
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: laporan.detail?.debit == "0"
                    ? Text(
                        "Kredit",
                        style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                      )
                    : Text(
                        "Debit",
                        style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "CATATAN",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  laporan.detail?.catatan ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Tanggal ",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  DateFormat("dd MMM yyyy")
                      .format(laporan.tanggal ?? DateTime.now()),
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Nominal",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (laporan.detail?.debit == "0")
                      Text(
                          "-${NumberUtils.toRupiah(double.tryParse(laporan.detail?.kredit ?? "") ?? 0.0)}")
                    else
                      Text(
                          "+${NumberUtils.toRupiah(double.tryParse(laporan.detail?.debit ?? "") ?? 0.0)}")
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          );
        });
  }

  DateTimeRange? timeRange;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: BlocListener<SavingBloc, SavingState>(
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
              "Tabungan",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (test) {},
                itemBuilder: (BuildContext context) {
                  return {'Cetak buku tabungan'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Row(
                        children: [
                          Icon(
                            Icons.download,
                            color: Colors.black26,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(choice),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              getData();
            },
            child: _isLoading
                ? ProgressLoading()
                : ListView(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text("Tanggal"),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: timeRange != null
                                    ? Text(
                                        "${DateFormat("d MMM yyyy").format(timeRange!.start)}-${DateFormat("d MMM yyyy").format(timeRange!.end)}",
                                        style: TextStyle(color: MyColors.primary),
                                      )
                                    : Icon(Icons.calendar_month,
                                        color: MyColors.primary),
                                selected: timeRange != null,
                                backgroundColor: Color(0xffEBF6F3),
                                shape: StadiumBorder(
                                    side: BorderSide(color: MyColors.grey_20)),
                                selectedColor: MyColors.primary.withOpacity(0.3),
                                checkmarkColor: MyColors.primary,
                                onSelected: (val) async {
                                  DateTimeRange? result =
                                      await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(
                                        2022, 1, 1), // the earliest allowable
                                    lastDate: DateTime(
                                        2050, 12, 31), // the latest allowable
                                    currentDate: DateTime.now(),
                                    saveText: 'Done',
                                  );
                                  timeRange = result;

                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saldo",
                                  style: TextStyle(color: MyColors.grey_60),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  NumberUtils.toRupiah(
                                      _savingResponse?.saldo?.toDouble() ?? 0.0),
                                  style: TextStyle(fontSize: 24),
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
                                            "DEBIT",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            NumberUtils.toRupiah(_savingResponse
                                                    ?.getTotalDebit() ??
                                                0.0),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "KREDIT",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            NumberUtils.toRupiah(_savingResponse
                                                    ?.getTotalCredit() ??
                                                0.0),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0)))),
                                        onPressed: () async {
                                          ScreenUtils(context)
                                              .navigateTo(SavingTopUpScreen(),
                                                  listener: (val) {
                                            if (val == 200) getData();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Setor Tabungan",
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
                                    Expanded(
                                      child: Container(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: generateList()),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateList() {
    return _savingResponse?.laporan
            ?.where((element) {
              var curDate = element.tanggal;
              var start = timeRange?.start;
              var end = timeRange?.end;

              if (curDate != null && start != null && end != null) {
                return (curDate.isAfter(start) && curDate.isBefore(end)) ||
                    curDate.isAtSameMomentAs(start) ||
                    curDate.isAtSameMomentAs(end);
              }

              return true;
            })
            .map((e) => InkWell(
                  onTap: () {
                    _detailBottomSheet(e);
                  },
                  child: Column(
                    children: [
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (e.detail?.debit == "0")
                                Text(
                                  "Kredit",
                                  style: TextStyle(fontSize: 16),
                                )
                              else
                                Text(
                                  "Debit",
                                  style: TextStyle(fontSize: 16),
                                ),
                              Text(
                                DateFormat("dd MMM yyyy")
                                    .format(e.tanggal ?? DateTime.now()),
                                style: TextStyle(
                                    fontSize: 12, color: MyColors.grey_50),
                              ),
                            ],
                          ),
                          Spacer(),
                          if (e.detail?.debit == "0")
                            Text(
                                "-${NumberUtils.toRupiah(double.tryParse(e.detail?.kredit ?? "") ?? 0.0)}")
                          else
                            Text(
                                "+${NumberUtils.toRupiah(double.tryParse(e.detail?.debit ?? "") ?? 0.0)}")
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
