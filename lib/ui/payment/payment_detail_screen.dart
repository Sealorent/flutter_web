import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/widget/payment_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../transaction/model/item_filter_model.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {

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
        title: Text("Ringkasan Pembayaran", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No Ref"),
                  SizedBox(height: 5,),
                  Text("SP10621002512072201", style: TextStyle(fontSize: 18),),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("ITEM (3)", style: TextStyle(color: MyColors.grey_60, fontSize: 12)),
                      Spacer(),
                      Text("JUMLAH", style: TextStyle(color: MyColors.grey_60, fontSize: 12),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("SPP April 2022"),
                      Spacer(),
                      Text("Rp120.000"),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Kost Pon Pres"),
                      Spacer(),
                      Text("Rp120.000"),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("TOTAL"),
                      Spacer(),
                      Text("Rp120.000", style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: PaymentMethod(context),
    );
  }
}
