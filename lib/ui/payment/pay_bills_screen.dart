import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/network/param/bayar_param.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/payment/payment_detail_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_process_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../network/response/bayar_bebas_response.dart' as Bebas;
import '../../network/response/bayar_bulanan_response.dart';
import '../../network/response/tahun_ajaran_response.dart';
import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../widget/tahun_ajaran_widget.dart';
import '../transaction/model/item_filter_model.dart';

class PayBillsScreen extends StatefulWidget {
  bool isBebas;

  PayBillsScreen(this.isBebas);

  @override
  State<PayBillsScreen> createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends State<PayBillsScreen> {
  int? selectedButton;
  bool sppExpanded = true;
  bool kostExpanded = true;
  bool otherExpanded = true;
  List<String> listBulan = [
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
  ];
  late PaymentBloc bloc;
  bool _isLoading = true;
  bool _isBayarLoading = false;
  Bebas.BayarBebasResponse? _bebasResponse;
  BayarBulananResponse? _bulananResponse;
  TextEditingController _nominalController = TextEditingController();

  TahunAjaranResponse? _tahunAjaranResponse;

  Future<void> _getTahunAjaran() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.TAHUN_AJARAN);
    print("student : $student");
    var objectStudent =
        TahunAjaranResponse.fromJson(json.decode(student ?? ""));

    setState(() {
      print(student);
      _tahunAjaranResponse = objectStudent;
      setAllPeriods();
    });
    getData();
  }

  void setAllPeriods() {
    setState(() {
      selectedPeriods = _tahunAjaranResponse?.tahunajaran
              ?.map((e) => int.tryParse(e.id ?? "0") ?? 0)
              .toList() ??
          [];
    });
  }

  List<int> selectedPeriods = [];

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    _getTahunAjaran();
    super.initState();
  }

  void listener(BuildContext context, PaymentState state) async {
    if (state is BayarLoading) {
      setState(() {
        _isBayarLoading = true;
      });
    } else if (state is BayarSuccess) {
      setState(() {
        _isBayarLoading = false;
      });
      print("no ipaymu : ${state.response.noIpaymu}");
      if (state.response.noIpaymu != null) {
        ScreenUtils(context)
            .navigateTo(PaymentDetailScreen(state.response.noIpaymu));
      } else {
        MySnackbar(context).errorSnackbar("Proses pembayaran gagal");
      }
    } else if (state is GetDetailBayarLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetDetailBayarSuccess) {
      setState(() {
        _isLoading = false;
        if (state.response is Bebas.BayarBebasResponse) {
          _bebasResponse = state.response as Bebas.BayarBebasResponse?;
        } else {
          _bulananResponse = state.response as BayarBulananResponse?;
        }
      });
    } else if (state is FailedState) {
      print("homeee");
      _bebasResponse = null;
      _bulananResponse = null;
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        // MySnackbar(context)
        //     .errorSnackbar("Terjadi kesalahan");
        return;
      }

      MySnackbar(context).errorSnackbar("${state.message} : ${state.code}");
    }
  }

  void getData() {
    if (widget.isBebas) {
      bloc.add(GetDetailPaymentBebas(selectedPeriods));
    } else {
      bloc.add(GetDetailPaymentBulanan(selectedPeriods));
    }
  }

  void _modalBebasInputSheetMenu(Bebas.Detail e) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          var bottom = MediaQuery.of(context).viewInsets.bottom;

          return Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    "Pembayaran Bebas",
                    style: TextStyle(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              e.detailBulan?.bebas ?? "",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Total Tagihan",
                            style: TextStyle(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            "${NumberUtils.toRupiah(double.tryParse(e.detailBulan?.bebasBill ?? "0") ?? 0)}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Sudah dibayar",
                            style: TextStyle(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            "${NumberUtils.toRupiah(double.tryParse(e.detailBulan?.bebasTotalPay ?? "0") ?? 0)}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Kekurangan",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                          Spacer(),
                          Text(
                            "${NumberUtils.toRupiah(e.detailBulan?.sisa?.toDouble() ?? 0)}",
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _nominalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Nominal',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Masukkan nominal yang ingin dibayar",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                            backgroundColor: e.detailBulan?.processPaid == false
                                ? MaterialStateProperty.all(MyColors.primary)
                                : MaterialStateProperty.all(Colors.white)),
                        onPressed: () async {
                          var nominal =
                              double.tryParse(_nominalController.text.trim()) ??
                                  0;
                          if (nominal != 0) {
                            setState(() {
                              e.detailBulan?.processPaid =
                                  !(e.detailBulan?.processPaid ?? true);
                              e.detailBulan?.nominalBayar = nominal;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bayar",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 70,
                )
              ],
            ),
          );
        });
  }

  List<Widget> buildBebasWidget() {
    return _bebasResponse?.detail
            ?.where((element) => element.detailBulan?.sisa != 0)
            .map((e) => Column(
                  children: [
                    TreeViewChild(
                        startExpanded: true,
                        parent: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    sppExpanded = !sppExpanded;
                                    setState(() {});
                                  },
                                  child: Text(
                                    e.detailBulan?.bebas ?? "",
                                    style: TextStyle(
                                        fontSize: 18, color: MyColors.primary),
                                  )),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    sppExpanded = !sppExpanded;
                                    setState(() {});
                                  },
                                  child: sppExpanded
                                      ? Icon(Icons.keyboard_arrow_down_sharp)
                                      : Icon(Icons.keyboard_arrow_right_sharp))
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      NumberUtils.toRupiah(
                                          (e.detailBulan?.sisa ?? 0)
                                              .toDouble()),
                                      style: TextStyle(color: MyColors.grey_60),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(18.0))),
                                          backgroundColor:
                                              e.detailBulan?.processPaid ==
                                                      false
                                                  ? MaterialStateProperty.all(
                                                      MyColors.primary)
                                                  : MaterialStateProperty.all(
                                                      Colors.white)),
                                      onPressed: () async {
                                        if (e.detailBulan?.processPaid ==
                                            false) {
                                          _modalBebasInputSheetMenu(e);
                                        } else {
                                          setState(() {
                                            e.detailBulan?.processPaid =
                                                !(e.detailBulan?.processPaid ??
                                                    true);
                                            e.detailBulan?.nominalBayar = null;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              e.detailBulan?.processPaid ==
                                                      false
                                                  ? "Bayar"
                                                  : "Batalkan",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  ?.apply(
                                                      color: e.detailBulan
                                                                  ?.processPaid ==
                                                              false
                                                          ? Colors.white
                                                          : Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                        visible:
                                            e.detailBulan?.nominalBayar != null,
                                        child: Text(
                                            "${NumberUtils.toRupiah(e.detailBulan?.nominalBayar ?? 0)}"))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]),
                    Divider(),
                  ],
                ))
            .toList() ??
        [];
  }

  List<Widget> buildBulananWidget() {
    return _bulananResponse?.detail
            ?.map((e) => Column(
                  children: [
                    TreeViewChild(
                        startExpanded: true,
                        parent: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      sppExpanded = !sppExpanded;
                                      setState(() {});
                                    },
                                    child: Text(
                                      "${(e.detailBulan?.row ?? "").split("/").first}/${(e.detailBulan?.row ?? "").split("/").last.split(" ").first}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: MyColors.primary),
                                    )),
                              ),
                              InkWell(
                                  onTap: () {
                                    sppExpanded = !sppExpanded;
                                    setState(() {});
                                  },
                                  child: sppExpanded
                                      ? Icon(Icons.keyboard_arrow_down_sharp)
                                      : Icon(Icons.keyboard_arrow_right_sharp))
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < listBulan.length; i++)
                                      "${(e.detailBulan?.row ?? "").split("/").last.split(" ").last}" ==
                                              listBulan[i]
                                          ? Text(
                                              i > 5
                                                  ? "${(e.detailBulan?.row ?? "").split("/").last.split(" ").last} ${(e.detailBulan?.row ?? "").split("/").last.split(" ").first}"
                                                  : "${(e.detailBulan?.row ?? "").split("/").last.split(" ").last} ${(e.detailBulan?.row ?? "").split("/").first.split(" ").last}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: MyColors.primary),
                                            )
                                          : Container(),
                                    Text(
                                      NumberUtils.toRupiah((int.tryParse(
                                                  e.detailBulan?.bulanBill ??
                                                      "0") ??
                                              0)
                                          .toDouble()),
                                      style: TextStyle(color: MyColors.grey_60),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0))),
                                      backgroundColor:
                                          e.detailBulan?.processPaid == false
                                              ? MaterialStateProperty.all(
                                                  MyColors.primary)
                                              : MaterialStateProperty.all(
                                                  Colors.red.withOpacity(0.8))),
                                  onPressed: () async {
                                    setState(() {
                                      e.detailBulan?.processPaid =
                                          !(e.detailBulan?.processPaid ?? true);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //nd
                                        Text(
                                          e.detailBulan?.processPaid == false
                                              ? "Bayar"
                                              : "Batalkan",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.apply(
                                                  color: e.detailBulan
                                                              ?.processPaid ==
                                                          false
                                                      ? Colors.white
                                                      : Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                    Divider(),
                  ],
                ))
            .toList() ??
        [];
  }

  final listFilter = <ItemFilter>[
    ItemFilter(1, 'Semua Tahun', false),
    // ItemFilter(2, 'Lunas', false),
    // ItemFilter(3, 'Belum Lunas', false),
  ];

  List<Tahunajaran> selectedYear = [];

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return TahunAjaranWidget(
            onSelectTahunAjaran: (tahunAjaran) {
              if (selectedPeriods.length ==
                  _tahunAjaranResponse?.tahunajaran?.length) {
                selectedPeriods.clear();
              }
              _tahunAjaranResponse?.tahunajaran?.forEach((element) {
                if (tahunAjaran.id == element.id) {
                  element.isSelected = !element.isSelected;

                  if (element.isSelected) {
                    selectedYear.add(tahunAjaran);
                    selectedPeriods.add(int.tryParse(element.id ?? "0") ?? 0);
                  } else {
                    selectedYear.remove(tahunAjaran);
                    selectedPeriods.removeWhere((inte) =>
                        inte == (int.tryParse(element.id ?? "0") ?? 0));
                  }
                  setState(() {});
                  getData();
                }
              });
            },
            onSelectAll: () {
              selectedYear.clear();
              setAllPeriods();
              getData();
            },
            tahunAjaranResponse: _tahunAjaranResponse,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
            "Bayar Tagihan",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: _isLoading
            ? ProgressLoading()
            : RefreshIndicator(
                onRefresh: () async {
                  getData();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: TreeView(startExpanded: false, children: [
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 32,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listFilter.length,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          var item = listFilter[index];
                          if (index == 0) {
                            return InkWell(
                              onTap: () {
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
                                          children: const [
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
                                        selectedYear.isEmpty
                                            ? "Semua Tahun"
                                            : selectedYear
                                                .map((e) => e.getTitle())
                                                .toString(),
                                        style:
                                            TextStyle(color: MyColors.primary),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: Text(
                                  item.name,
                                  style: TextStyle(color: MyColors.primary),
                                ),
                                selected: item.isFilterActive,
                                backgroundColor: Color(0xffEBF6F3),
                                shape: const StadiumBorder(
                                    side: BorderSide(color: MyColors.grey_20)),
                                selectedColor:
                                    MyColors.primary.withOpacity(0.3),
                                checkmarkColor: MyColors.primary,
                                onSelected: (val) {
                                  setState(() => item.isFilterActive =
                                      !item.isFilterActive);
                                  listFilter;

                                  print(
                                      "list filter : ${listFilter.map((e) => e.isFilterActive)}");
                                  setState(() {});
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Column(
                      children: widget.isBebas
                          ? buildBebasWidget()
                          : buildBulananWidget(),
                    )
                  ]),
                ),
              ),
        bottomSheet: Container(
          color: getTotalItem() == 0
              ? Colors.white
              : MyColors.primary.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Total (${getTotalItem()} item)"),
                  Spacer(),
                  Text(NumberUtils.toRupiah(getTotalItemPrice())),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              _isBayarLoading
                  ? ProgressLoading()
                  : ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                      onPressed: () async {
                        if (_bebasResponse != null) {
                          var selectedList = _bebasResponse?.detail
                                  ?.where((element) =>
                                      element.detailBulan?.processPaid == true)
                                  .toList() ??
                              [];
                          var bayarIds = selectedList
                              .map((e) =>
                                  int.tryParse(e.detailBulan?.bebasId ?? "") ??
                                  0)
                              .toList();
                          bayarIds.removeWhere((element) => element == 0);

                          var nominalIds = selectedList
                              .map((e) =>
                                  e.detailBulan?.nominalBayar?.toInt() ?? 0)
                              .toList();
                          nominalIds.removeWhere((element) => element == 0);

                          var periodIds = selectedList
                              .map((e) =>
                                  int.tryParse(e.detailBulan?.period ?? "0") ??
                                  0)
                              .toList();
                          periodIds.removeWhere((element) => element == 0);

                          var param = BayarParam(
                              bebas_id: bayarIds,
                              bebas_nominal: nominalIds,
                              period_ids: periodIds);

                          if (bayarIds.isEmpty) {
                            MySnackbar(context)
                                .errorSnackbar("Pilih yang ingin di bayar");
                            return;
                          }
                          bloc.add(BayarTagihan(param));
                        } else if (_bulananResponse != null) {
                          var selectedList = _bulananResponse?.detail
                                  ?.where((element) =>
                                      element.detailBulan?.processPaid == true)
                                  .toList() ??
                              [];
                          var bayarIds = selectedList
                              .map((e) =>
                                  int.tryParse(e.detailBulan?.bulanId ?? "") ??
                                  0)
                              .toList();
                          bayarIds.removeWhere((element) => element == 0);

                          var periodIds = selectedList
                              .map((e) =>
                                  int.tryParse(e.detailBulan?.period ?? "0") ??
                                  0)
                              .toList();
                          periodIds.removeWhere((element) => element == 0);

                          var param = BayarParam(
                              bulan_id: bayarIds, period_ids: periodIds);

                          if (bayarIds.isEmpty) {
                            MySnackbar(context)
                                .errorSnackbar("Pilih yang ingin di bayar");
                            return;
                          }

                          bloc.add(BayarTagihan(param));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lanjutkan",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  int getTotalItem() {
    if (widget.isBebas) {
      var items = _bebasResponse?.detail
              ?.where((element) => element.detailBulan?.processPaid == true)
              .toList() ??
          [];
      return items.length;
    } else {
      var items = _bulananResponse?.detail
              ?.where((element) => element.detailBulan?.processPaid == true)
              .toList() ??
          [];
      return items.length;
    }
  }

  double getTotalItemPrice() {
    if (widget.isBebas) {
      var items = _bebasResponse?.detail
              ?.where((element) => element.detailBulan?.processPaid == true)
              .toList() ??
          [];
      var ints =
          items.map((e) => (e.detailBulan?.nominalBayar ?? 0).toDouble());
      if (ints.isNotEmpty) {
        return ints.reduce((a, b) => a + b);
      } else {
        return 0.0;
      }
    } else {
      var items = _bulananResponse?.detail
              ?.where((element) => element.detailBulan?.processPaid == true)
              .toList() ??
          [];
      var ints = items.map(
          (e) => double.tryParse(e.detailBulan?.bulanBill ?? "0.0") ?? 0.0);
      if (ints.isNotEmpty) {
        return ints.reduce((a, b) => a + b);
      } else {
        return 0.0;
      }
    }
  }
}
