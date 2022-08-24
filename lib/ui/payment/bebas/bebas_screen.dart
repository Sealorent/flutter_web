import 'package:flutter/material.dart';
import 'package:tree_view/tree_view.dart';

import '../../../model/year_model.dart';
import '../../../res/my_colors.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/year_util.dart';
import '../../transaction/model/item_filter_model.dart';
import '../pay_bills_screen.dart';

class BebasScreen extends StatefulWidget {
  const BebasScreen({Key? key}) : super(key: key);

  @override
  State<BebasScreen> createState() => _BebasScreenState();
}

class _BebasScreenState extends State<BebasScreen> {

  final listFilter = <ItemFilter>[
    ItemFilter(1, 'Semua Tahun', false),
    ItemFilter(2, 'Lunas', false),
    ItemFilter(3, 'Belum Lunas', false),
  ];

  YearModel? selectedYear;
  bool sppExpanded = true;
  bool kostExpanded = true;


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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {

      },
      child: TreeView(
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TAGIHAN BULANAN", style: TextStyle(color: MyColors.grey_60),),
                    SizedBox(height: 10,),
                    Text("Rp200.000", style: TextStyle(fontSize: 24),),
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
                              ScreenUtils(context).navigateTo(PayBillsScreen());
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
                          child: Text(
                            "Unduh Tagihan",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.apply(color: MyColors.primary),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Daftar Ulang", style: TextStyle(fontSize: 16),),
                    Text("Rp.125.000 dibayar Rp.50.000",style: TextStyle(color: MyColors.grey_60),),
                  ],
                ),
                Spacer(),
                Text("Belum Lunas", style: TextStyle(color: Colors.red),),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
