
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pesantren_flutter/network/response/payment_response.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../../model/year_model.dart';
import '../../../network/response/setting_response.dart';
import '../../../network/response/tahun_ajaran_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../res/my_colors.dart';
import '../../../utils/my_snackbar.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/year_util.dart';
import '../../transaction/model/item_filter_model.dart';
import '../pay_bills_screen.dart';

class BulananScreen extends StatefulWidget {
  const BulananScreen({Key? key}) : super(key: key);

  @override
  State<BulananScreen> createState() => _BulananScreenState();
}

class _BulananScreenState extends State<BulananScreen> {

  late PaymentBloc bloc;
  bool _isLoading = true;
  PaymentResponse? _response;
  bool _unduhIsLoading = false;
  String savePath = "";
  TahunAjaranResponse? _tahunAjaranResponse;

  Future<void> _getTahunAjaran() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.TAHUN_AJARAN);
    var objectStudent = TahunAjaranResponse.fromJson(json.decode(student ?? ""));

    setState(() {
      print(student);
      _tahunAjaranResponse = objectStudent;
      setAllPeriods();
    });
    getData();
  }

  void setAllPeriods(){
    setState(() {
      selectedPeriods = _tahunAjaranResponse?.tahunajaran?.map((e) => int.tryParse(e.id ?? "0") ?? 0).toList() ?? [];
    });
  }

  List<int> selectedPeriods = [];

  Future<void> openFile(String filename) async {
    print(filename);
    await OpenFile.open(filename);
  }

  Future downloadFile(String url, String fileName) async {
    try {
      setState(() {
        _unduhIsLoading = true;
      });

      Dio dio = Dio();

      savePath = await getFilePath(fileName);
      await dio.download(url,
          savePath,
          onReceiveProgress: (rec, total) {
            setState(() {
              _unduhIsLoading = false;
            });
            openFile(savePath);
          },
      );
      setState(() {
        _unduhIsLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _unduhIsLoading = false;
      });
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }
  
  double total = 0.0;

  final listFilter = <ItemFilter>[
    ItemFilter(1, 'Semua Tahun', false),
    ItemFilter(2, 'Lunas', false),
    ItemFilter(3, 'Belum Lunas', false),
  ];

  Tahunajaran? selectedYear;


  List<Widget> buildWidget(){
    return _response?.detail?.where((element) {
      var yearStart = int.tryParse(element.fromModel().startYear) ?? 0;
      var yearEnd = int.tryParse(element.fromModel().endYear) ?? 0;

      if(selectedYear != null && yearStart != 0 && yearEnd != 0){
        return yearStart >= (selectedYear?.getStart() ?? 0) && yearEnd <= (selectedYear?.getEnd() ?? 0);
      }else{
        return true;
      }
    }).map((e) {
      bool sppExpanded = true;

      var model = e.fromModel();
      return Column(
        children: [
          TreeViewChild(
              startExpanded : true,
              parent: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    InkWell(
                        onTap: (){
                          sppExpanded = !sppExpanded;
                          setState(() {});
                        },
                        child: Text(model.title, style: TextStyle(fontSize: 18,color: MyColors.grey_80),)),
                    Spacer(),
                    InkWell(
                        onTap: (){
                          sppExpanded = !sppExpanded;
                          setState(() {});
                        },
                        child: sppExpanded ? Icon(Icons.keyboard_arrow_down_sharp)
                            : Icon(Icons.keyboard_arrow_right_sharp)
                    )
                  ],
                ),
              ),
              children: model.items
                  .where((element) {
                    if(listFilter[2].isFilterActive && !listFilter[1].isFilterActive){
                      return element.status == "0";
                    }else if(listFilter[1].isFilterActive && !listFilter[2].isFilterActive){
                      return element.status == "1";
                    }else{
                      return true;
                    }
                  })
                  .map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${e.month} ${e.year}", style: TextStyle(fontSize: 16),),
                          Text(NumberUtils.toRupiah(double.tryParse(e.total) ?? 0.0),style: TextStyle(color: MyColors.grey_60),),
                        ],
                      ),
                      Spacer(),
                      Text(e.status == "1" ? "Lunas" : "Belum Lunas", style: TextStyle(color: e.status == "1" ? MyColors.primary : Colors.red),),
                    ],
                  ),
                );
              }).toList()
          ),
          Divider(),
        ],
      );
    }).toList() ?? [];
  }


  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Center(
                child: Container(
                  width: 50,
                  height: 8,
                  decoration: BoxDecoration(
                    color: MyColors.grey_20,
                    borderRadius:
                    BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Pilih tahun ajaran",style: TextStyle(color: Colors.black.withOpacity(0.4)),),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedYear = null;
                          setAllPeriods();
                          getData();
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text("Semua",style: TextStyle(fontSize: 18),),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 18,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: _tahunAjaranResponse?.tahunajaran?.map((e) => Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = e;
                                selectedPeriods = [int.tryParse(e.id ?? "0") ?? 0];
                              });
                              getData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Text("${e.getTitle()}",style: TextStyle(fontSize: 18),),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios, size: 18,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )).toList() ?? [],
                    )
                  ],
                ),
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    _getTahunAjaran();
    super.initState();
  }

  void getData(){
    bloc.add(GetPayment(selectedPeriods));
  }

  void listener(BuildContext context, PaymentState state) async {
    if (state is GetPaymentLoading) {
      setState(() {
        _isLoading = true;
      });
    }else if (state is UnduhTagihanLoading) {
      setState(() {
        _unduhIsLoading = true;
      });
    }else if (state is UnduhTagihanSuccess) {
      setState(() {
        downloadFile("${state.response.link}", DateTime
            .now()
            .timeZoneOffset
            .inMilliseconds
            .toString() + "-tagihan.pdf");
      });
    } else if (state is GetPaymentSuccess) {
      setState(() {
        _isLoading = false;
        _response = state.response;
      });


      var data = _response?.detail?.map((e) {
        var total = int.tryParse(e.fromModel().total) ?? 0;
        var dibayar = int.tryParse(e.fromModel().dibayar) ?? 0;
        return total - dibayar;
      }).toList() ?? [];

      setState(() {
        total = data.reduce((a, b) => a + b).toDouble();
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
    return BlocListener<PaymentBloc, PaymentState>(
      listener: listener,
      child: _isLoading ? ProgressLoading() : TreeView(
        startExpanded: false,
        children: [
          SizedBox(height: 15,),
          SizedBox(
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listFilter.length,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                var item = listFilter[index];
                if(index == 0){
                  return InkWell(
                    onTap: (){
                      // setState(() {
                      //   selectedYear = "2021/2022";
                      // });
                      _modalBottomSheetMenu();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: selectedYear != null ? MyColors.primary.withOpacity(0.3) :  Color(0xffEBF6F3),
                          borderRadius:
                          BorderRadius.all(Radius.circular(16.0)),
                          border: Border.all(
                            color: MyColors.grey_20,
                            width: 1.5,
                          ),
                        ),
                        child: Center(child: Row(
                          children: [
                            Visibility(
                              visible: selectedYear != null,
                              child: Row(
                                children: [
                                  Icon(Icons.check, color: MyColors.primary,size: 18,),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                            Text(selectedYear?.getTitle() ?? "Semua Tahun", style: TextStyle(color: MyColors.primary),),
                          ],
                        )),
                      ),
                    ),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(item.name, style: TextStyle(color: MyColors.primary),),
                      selected: item.isFilterActive,
                      backgroundColor: Color(0xffEBF6F3),
                      shape: StadiumBorder(side: BorderSide(
                          color: MyColors.grey_20
                      )),
                      selectedColor: MyColors.primary.withOpacity(0.3),
                      checkmarkColor: MyColors.primary,
                      onSelected: (val) {
                        setState(() => item.isFilterActive = !
                            item.isFilterActive);
                        listFilter;

                        print("list filter : ${listFilter.map((e) => e.isFilterActive)}");
                        setState(() {
                        });
                      },
                    ),
                  );
                }

              },
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TAGIHAN PER ${DateFormat("dd MMM yyyy").format(DateTime.now()).toUpperCase()}", style: TextStyle(color: MyColors.grey_60),),
                    SizedBox(height: 10,),
                    Text(NumberUtils.toRupiah(total), style: TextStyle(fontSize: 24),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0)
                                    )
                                )
                            ),
                            onPressed: () async{
                              if(total == 0){
                                MySnackbar(context).successSnackbar("Tidak ada tagihan");
                                return;
                              }
                              // ScreenUtils(context).navigateTo(PayBillsScreen(false));
                            },
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Bayar Tagihan",
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
                        Expanded(child: Center(
                          child: _unduhIsLoading ? ProgressLoading() : InkWell(
                            onTap: (){
                              bloc.add(UnduhTagihan());
                            },
                            child: Text(
                              "Unduh Tagihan",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.apply(color: MyColors.primary),
                            ),
                          ),
                        ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Divider(),
          Column(
            children: buildWidget(),
          )
        ],
      ),
    );
  }
}
