import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_bloc.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_event.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_state.dart';
import 'package:pesantren_flutter/network/response/presensi_pelajaran_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:tree_view/tree_view.dart';
import 'package:pesantren_flutter/res/my_colors.dart';

import '../../widget/tahun_ajaran_widget.dart';
import '../../preferences/pref_data.dart';
import '../../network/response/tahun_ajaran_response.dart';
import '../../utils/my_snackbar.dart';

class PresensiPelajaranView extends StatefulWidget {
  const PresensiPelajaranView({super.key});

  @override
  State<PresensiPelajaranView> createState() => _PresensiPelajaranViewState();
}

class _PresensiPelajaranViewState extends State<PresensiPelajaranView> {
  TahunAjaranResponse? _tahunAjaranResponse;
  bool _isLoading = true;
  PresensiPelajaranResponse? _presensiPelajaranResponse;
  late RekamMedisBloc bloc;
  List<Tahunajaran> selectedYear = [];

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

  void getData() {
    bloc.add(GetPresensiPelajaran(selectedPeriods));
  }

  @override
  void initState() {
    bloc = BlocProvider.of<RekamMedisBloc>(context);
    _getTahunAjaran();
    super.initState();
  }

  void listener(BuildContext context, RekamMedisState state) async {
    if (state is GetPresensiPelajaranLoading) {
      print('load');

      setState(() {
        _isLoading = true;
      });
    } else if (state is GetPresensiPelajaranSuccess) {
      setState(() {
        _isLoading = false;
        print('success');
        _presensiPelajaranResponse = state.response;
      });
    } else if (state is FailedState) {
      _presensiPelajaranResponse = null;

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
                    print("add : ${element.id}");
                    selectedYear.add(tahunAjaran);
                    selectedPeriods.add(int.tryParse(element.id ?? "0") ?? 0);
                  } else {
                    selectedYear.remove(tahunAjaran);
                    selectedPeriods.removeWhere((inte) =>
                        inte == (int.tryParse(element.id ?? "0") ?? 0));
                  }
                  setState(() {});
                  print("selectedPeriods : $selectedPeriods");
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
    final size = MediaQuery.of(context).size;
    return BlocListener<RekamMedisBloc, RekamMedisState>(
      listener: listener,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            // selectedYear = null;
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
                            )
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
    print("generateList : ${_presensiPelajaranResponse?.laporan?.length}");
    print(
        'generateList : ${_presensiPelajaranResponse?.laporan?.map((e) => e.detail?.pelajaran).toList()}');
    return _presensiPelajaranResponse?.laporan
            ?.map((e) => InkWell(
                  onTap: () {},
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
                              Text(
                                e.detail?.pelajaran ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                DateFormat("dd MMM yyyy").format(
                                    e.detail?.tanggal ?? DateTime.now()),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
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
