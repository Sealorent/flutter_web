import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/network/response/history_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
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
  bool _isLoading = true;
  HistoryResponse? _response;

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    getData();
    super.initState();
  }

  void getData(){
    bloc.add(GetHistory());
  }

  final listFilter = <ItemFilter>[
    ItemFilter(1, 'Semua Tahun', false),
    ItemFilter(2, 'Selesai', false),
    ItemFilter(3, 'Menunggu Pembayaran', false),
  ];

  YearModel? selectedYear;

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

  void listener(BuildContext context, PaymentState state) async {
    if (state is GetHistoryLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetHistorySuccess) {
      setState(() {
        _isLoading = false;
        _response = state.response;
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
    return BlocListener<PaymentBloc, PaymentState>(
      listener: listener,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          elevation: 0,
          title: Text("Transaksi", style: TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            getData();
          },
          child: _isLoading ? ProgressLoading() : ListView(
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
                          onSelected: (_) => setState(() => item.isFilterActive = !item.isFilterActive),
                        ),
                      );
                    }

                  },
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: InkWell(
                  onTap: (){
                    ScreenUtils(context).navigateTo(TranscationDetailScreen());
                  },
                  child: Column(
                    children: _response?.laporan?.where((element) {
                      // var date = element.tanggal;
                      // if(selectedYear != null && date != null){
                      //   return date.isAfter(selectedYear!.startYear) && date.isBefore(selectedYear!.endYear);
                      // }else{
                      //   return true;
                      // }
                      return true;
                    }).map((e) => Column(
                      children: [
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.moneyBill, color: MyColors.grey_50,),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.detail?.bayarVia ?? "", style: TextStyle(fontSize: 16),),
                                Text(e.detail?.nominal ?? "", style: TextStyle(color: Colors.red),),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(e.detail?.tanggal ?? "", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),
                                // Text("15:31", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),

                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 10,),
                      ],
                    )).toList() ?? [],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
