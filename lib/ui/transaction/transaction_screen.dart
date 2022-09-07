import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/transaction/transaction_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';
import '../../widget/option_radio.dart';
import 'model/item_filter_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  final listFilter = <ItemFilter>[
    ItemFilter(1, 'Semua Tahun', false),
    ItemFilter(2, 'Selesai', false),
    ItemFilter(3, 'Menunggu Pembayaran', false),
  ];

  String? selectedYear;
  int? selectedButton;

  final listTransactions = <String>[
    "T1",
    "T2",
  ];

  final listTransactionFilter = <String>[];

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
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedYear = "2021/2022";
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text("2021/2022",style: TextStyle(fontSize: 18),),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 18,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedYear = "2020/2021";
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text("2020/2021",style: TextStyle(fontSize: 18),),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 18,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    var isFilterActive = listFilter
        .where((element) => element.isFilterActive)
        .isNotEmpty;
    listTransactionFilter.clear();
    if (!isFilterActive) {
      listTransactionFilter.addAll(listTransactions);
    } else {
      listTransactions.forEach((element) {
        var isPassed = false;
        var itemProductFilter = element;
        // for (var index = 0; index < itemProductFilter.length; index++) {
        //   var productFilter = itemProductFilter[index];
        //   var itemFilter = listFilter[index];
        //   if (productFilter.isFilterActive && itemFilter.isFilterActive) {
        //     isPassed = true;
        //     break;
        //   }
        // }
        if (isPassed) {
          listTransactionFilter.add(element);
        }
      });
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0,
        title: Text("Transaksi", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
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
                              Text(selectedYear ?? "Semua Tahun", style: TextStyle(color: MyColors.primary),),
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
                  children: [
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.moneyBill, color: MyColors.grey_50,),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bayar tagihan", style: TextStyle(fontSize: 16),),
                            Text("Menunggu pembayaran", style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("22 Apr 2021", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),
                            Text("15:31", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),

                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.wallet, color: MyColors.grey_50,),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Menabung", style: TextStyle(fontSize: 16),),
                            Text("Selesai"),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("22 Apr 2021", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),
                            Text("15:31", style: TextStyle(fontSize: 12,color: MyColors.grey_50),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
