import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../transaction/model/item_filter_model.dart';
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';

class PaymentMethodScreen extends StatefulWidget {
  List<Bayar> bayar;
  Function(Bayar) onSelectPayment;

  PaymentMethodScreen(this.bayar,this.onSelectPayment);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  bool bankTransferExpanded = false;

  @override
  Widget build(BuildContext context) {
    var metodes = widget.bayar.map((e) => e.metodeBayar ?? "").toList().toSet().toList();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
              Navigator.pop(context);
          }, icon: Icon(Icons.close,color: MyColors.grey_60,))
        ],
        title: Text("Pilih metode pembayaran", style: TextStyle(color: MyColors.grey_50, fontSize: 14),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: TreeView(
          startExpanded: false,
          children: metodes.map((e) => Column(
            children: [
              TreeViewChild(
                  startExpanded : true,
                  parent: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              bankTransferExpanded = !bankTransferExpanded;
                              setState(() {});
                            },
                            child: Text(e ?? "", style: TextStyle(fontSize: 18),)),
                        Spacer(),
                        InkWell(
                            onTap: (){
                              bankTransferExpanded = !bankTransferExpanded;
                              setState(() {});
                            },
                            child: bankTransferExpanded ? Icon(Icons.keyboard_arrow_down_sharp)
                                : Icon(Icons.keyboard_arrow_right_sharp)
                        )
                      ],
                    ),
                  ),
                  children: widget.bayar.where((element) => element.metodeBayar == e).map((ev) =>  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: InkWell(
                      onTap: (){
                        widget.onSelectPayment(ev);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ev.detail?.kode ?? "", style: TextStyle(fontSize: 16),),
                              // Text("Rp.125.000",style: TextStyle(color: MyColors.grey_60),),
                            ],
                          ),
                          Spacer(),
                          Image.asset(ev.detail?.metodeBankLogo ?? "", width: 50,),
                        ],
                      ),
                    ),
                  ),).toList()
              ),
              Divider(),
            ],
          )).toList() ?? [],
        ),
      ),
    );
  }
}
