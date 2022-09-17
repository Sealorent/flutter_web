import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/payment/payment_detail_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_process_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../network/response/bayar_bebas_response.dart';
import '../../network/response/bayar_bulanan_response.dart';
import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class PayBillsScreen extends StatefulWidget {

  bool isBebas;

  PayBillsScreen(this.isBebas);

  @override
  State<PayBillsScreen> createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends State<PayBillsScreen> {

  int? selectedButton;
  bool sppExpanded = true;
  bool kostExpanded = true;
  bool otherExpanded = true;

  late PaymentBloc bloc;
  bool _isLoading = true;
  BayarBebasResponse? _bebasResponse;
  BayarBulananResponse? _bulananResponse;

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    getData();
    super.initState();
  }

  void listener(BuildContext context, PaymentState state) async {
    if (state is GetDetailBayarLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetDetailBayarSuccess) {
      setState(() {
        _isLoading = false;
        if(state.response is BayarBebasResponse){
          _bebasResponse = state.response as BayarBebasResponse?;
        }else{
          _bulananResponse = state.response as BayarBulananResponse?;
        }
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

  void getData(){
    if(widget.isBebas){
      bloc.add(GetDetailPaymentBebas());
    }else{
      bloc.add(GetDetailPaymentBulanan());
    }
  }

  List<Widget> buildBebasWidget(){
    return _bebasResponse?.detail?.map((e) => Column(
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
                      child: Text(e.detailBulan?.bebas ?? "", style: TextStyle(fontSize: 18,color: MyColors.primary),)),
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
                        Text(NumberUtils.toRupiah((e.detailBulan?.sisa ?? 0).toDouble()),style: TextStyle(color: MyColors.grey_60),),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)
                              )
                          ),
                          backgroundColor: e.detailBulan?.processPaid == false ? MaterialStateProperty.all(MyColors.primary) : MaterialStateProperty.all(Colors.white)
                      ),
                      onPressed: () async{
                        setState(() {
                          e.detailBulan?.processPaid = !(e.detailBulan?.processPaid ?? true);
                        });
                      },
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.detailBulan?.processPaid == false ? "Bayar" : "Batalkan",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.apply(color: e.detailBulan?.processPaid == false ? Colors.white : Colors.red),
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
    )).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<PaymentBloc, PaymentState>(
      listener: listener,
      child: Scaffold(
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
        body: _isLoading ? ProgressLoading() : RefreshIndicator(
          onRefresh: () async {
            getData();
          },
          child: TreeView(
            startExpanded: false,
            children: widget.isBebas ? buildBebasWidget() : buildBebasWidget()
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
                  Text("Total (${getTotalItem()} item)"),
                  Spacer(),
                  Text(NumberUtils.toRupiah(getTotalItemPrice())),
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
      ),
    );
  }

  int getTotalItem(){
    if(widget.isBebas){
      var items = _bebasResponse?.detail?.where((element) => element.detailBulan?.processPaid == true).toList() ?? [];
      return items.length;
    }else{
      var items = _bulananResponse?.detail?.where((element) => element.detailBulan?.processPaid == true).toList() ?? [];
      return items.length;
    }
  }

  double getTotalItemPrice() {
    if (widget.isBebas) {
      var items = _bebasResponse?.detail?.where((element) =>
      element.detailBulan?.processPaid == true).toList() ?? [];
      var ints = items.map((e) => (e.detailBulan?.sisa ?? 0).toDouble());
      if(ints.isNotEmpty) {
        return ints.reduce((a, b) => a + b);
      } else {
        return 0.0;
      }
    } else {
      var items = _bulananResponse?.detail?.where((element) =>
      element.detailBulan?.processPaid == true).toList() ?? [];
      var ints = items.map((e) =>
      double.tryParse(e.detailBulan?.bulanBill ?? "0.0") ?? 0.0);
      if(ints.isNotEmpty){
        return ints.reduce((a, b) => a + b);
      }else{
        return 0.0;
      }

    }
  }
}
