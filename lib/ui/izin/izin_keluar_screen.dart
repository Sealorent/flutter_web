import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/model/year_model.dart';
import 'package:pesantren_flutter/network/response/izin_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/izin/izin_bloc.dart';
import 'package:pesantren_flutter/ui/izin/izin_event.dart';
import 'package:pesantren_flutter/ui/izin/izin_state.dart';
import 'package:pesantren_flutter/ui/payment/pay_bills_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_bloc.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/utils/year_util.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class IzinKeluarScreen extends StatefulWidget {
  const IzinKeluarScreen({Key? key}) : super(key: key);

  @override
  State<IzinKeluarScreen> createState() => _IzinKeluarScreenState();
}

class _IzinKeluarScreenState extends State<IzinKeluarScreen> {

  late IzinBloc bloc;
  bool _isLoading = true;
  IzinResponse? _izinResponse;

  YearModel? selectedYear;
  int? selectedButton;
  bool sppExpanded = true;
  bool kostExpanded = true;
  bool otherExpanded = true;


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
                      children: YearUtils.getYearModel(2020).reversed.map((e) => Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = e;
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Text(e.title,style: TextStyle(fontSize: 18),),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios, size: 18,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )).toList(),
                    )
                  ],
                ),
              )
            ],
          );
        }
    );
  }

  void _detailBottomSheet(Laporan laporan){
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("TANGGAL", style: TextStyle(color: MyColors.grey_60),),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(DateFormat("dd MMM yyyy").format(laporan.tanggal ?? DateTime.now()), style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("JAM", style: TextStyle(color: MyColors.grey_60),),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(laporan.detail?.waktu ?? "", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("KEPERLUAN", style: TextStyle(color: MyColors.grey_60),),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(laporan.detail?.catatan ?? "", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("STATUS", style: TextStyle(color: MyColors.grey_60),),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(laporan.detail?.disetujui ?? "", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
              ),
              SizedBox(height: 15,),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    bloc = BlocProvider.of<IzinBloc>(context);
    getData();
    super.initState();
  }

  void getData(){
    bloc.add(GetIzinKeluar());
  }

  void listener(BuildContext context, IzinState state) async {
    if (state is GetIzinLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetIzinKeluarSuccess) {
      setState(() {
        _isLoading = false;
        _izinResponse = state.response;
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context)
            .errorSnackbar("Terjadi kesalahan");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<IzinBloc, IzinState>(
        listener: listener,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              selectedYear = null;
              setState(() {});
              getData();
            },
            child: _isLoading ? ProgressLoading() : ListView(
              children: [
                SizedBox(height: 15,),
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
                          onTap: (){
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
                                  Text(selectedYear?.title ?? "Semua Tahun", style: TextStyle(color: MyColors.primary),),
                                ],
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: generateList().isEmpty ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text("Tidak ada data"),
                    ),
                  ) : Column(
                    children: generateList()
                  ),
                )
              ],
            ),
          ),
          bottomSheet: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      )
                  ),
                backgroundColor: MaterialStateProperty.all(Color(0xffF9F9F9)),
              ),

              onPressed: () async{

              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,color: MyColors.primary,),
                    SizedBox(width: 10,),
                    Text(
                      "Izin Keluar",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.apply(color: MyColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  List<Widget> generateList(){
    return _izinResponse?.laporan?.where((element) {
      var date = element.tanggal;
      if(selectedYear != null && date != null){
          return date.isAfter(selectedYear!.startYear) && date.isBefore(selectedYear!.endYear);
      }else{
        return true; 
      }
    }).map((e) => InkWell(
      onTap: (){
        _detailBottomSheet(e);
      },
      child: Column(
        children: [
          Divider(),
          SizedBox(height: 10,),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${DateFormat("dd MMM yyyy").format(e.tanggal ?? DateTime.now())}, Jam ${e.detail?.waktu ?? "-"}", style: TextStyle(fontSize: 16),),
                  Text("${e.detail?.catatan}", style: TextStyle(fontSize: 16),),
                ],
              ),
              Spacer(),
              Text(e.detail?.disetujui ?? "", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),
            ],
          ),
          SizedBox(height: 10,),
        ],
      ),
    )).toList() ?? [];
  }
}
