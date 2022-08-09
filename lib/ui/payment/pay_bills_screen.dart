import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_detail_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_process_screen.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../transaction/model/item_filter_model.dart';

class PayBillsScreen extends StatefulWidget {
  const PayBillsScreen({Key? key}) : super(key: key);

  @override
  State<PayBillsScreen> createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends State<PayBillsScreen> {

  int? selectedButton;
  bool sppExpanded = true;
  bool kostExpanded = true;
  bool otherExpanded = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
        title: Text("Bayar Tagihan", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: TreeView(
          startExpanded: false,
          children: [
            SizedBox(height: 15,),
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
                          child: Text("SPP", style: TextStyle(fontSize: 18,color: MyColors.primary),)),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Juli 2021", style: TextStyle(fontSize: 16),),
                            Text("Rp.125.000",style: TextStyle(color: MyColors.grey_60),),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0)
                                  )
                              )
                          ),
                          onPressed: () async{
                            ScreenUtils(context).navigateTo(PaymentProcessScreen());
                          },
                          child:  Padding(
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
                        )
                      ],
                    ),
                  ),
                ]
            ),
            Divider(),
            TreeViewChild(
                startExpanded : true,
                parent: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: (){
                            kostExpanded = !kostExpanded;
                            setState(() {});
                          },
                          child: Text("Kos Ponpes", style: TextStyle(fontSize: 18,color: MyColors.primary),)),
                      Spacer(),
                      InkWell(
                          onTap: (){
                            kostExpanded = !kostExpanded;
                            setState(() {});
                          },
                          child: kostExpanded ? Icon(Icons.keyboard_arrow_down_sharp)
                              : Icon(Icons.keyboard_arrow_right_sharp)
                      )
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Juli 2021", style: TextStyle(fontSize: 16),),
                            Text("Rp.125.000",style: TextStyle(color: MyColors.grey_60),),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0)
                                  )
                              )
                          ),
                          onPressed: () async{

                          },
                          child:  Padding(
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
                        )
                      ],
                    ),
                  ),
                ]
            ),
            Divider(),
            TreeViewChild(
                startExpanded : true,
                parent: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: (){
                            otherExpanded = !otherExpanded;
                            setState(() {});
                          },
                          child: Text("Lainnya", style: TextStyle(fontSize: 18,color: MyColors.primary),)),
                      Spacer(),
                      InkWell(
                          onTap: (){
                            otherExpanded = !otherExpanded;
                            setState(() {});
                          },
                          child: otherExpanded ? Icon(Icons.keyboard_arrow_down_sharp)
                              : Icon(Icons.keyboard_arrow_right_sharp)
                      )
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Juli 2021", style: TextStyle(fontSize: 16),),
                            Text("Rp.125.000",style: TextStyle(color: MyColors.grey_60),),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0)
                                  )
                              )
                          ),
                          onPressed: () async{

                          },
                          child:  Padding(
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
                        )
                      ],
                    ),
                  ),
                ]
            ),
            Divider(),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Total (3 item)"),
                Spacer(),
                Text("Rp450.000"),
              ],
            ),
            SizedBox(height: 5,),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      )
                  )
              ),
              onPressed: () async{
                ScreenUtils(context).navigateTo(PaymentDetailScreen());
              },
              child:  Padding(
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
    );
  }
}
