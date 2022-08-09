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

class PaymentProcessScreen extends StatefulWidget {
  const PaymentProcessScreen({Key? key}) : super(key: key);

  @override
  State<PaymentProcessScreen> createState() => _PaymentProcessScreenState();
}

class _PaymentProcessScreenState extends State<PaymentProcessScreen> {

  @override
  Widget build(BuildContext context) {
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
        title: Text("Pembayaran SPP", style: TextStyle(color: MyColors.grey_50, fontSize: 14),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("April 2022",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Total Tagihan",style: TextStyle(fontSize: 14),),
                      Spacer(),
                      Text("Rp140.000",style: TextStyle(fontSize: 14),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Kekurangan",style: TextStyle(fontSize: 14),),
                      Spacer(),
                      Text("Rp140.000",style: TextStyle(fontSize: 14),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 5,),
                  Text("Masukkan nominal yang ingin dibayar", style: TextStyle(color: MyColors.grey_60),),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)
                  )
              )
          ),
          onPressed: () async{
            // ScreenUtils(context).navigateTo(DashboardScreen());
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
        ),
      ),
    );
  }
}
