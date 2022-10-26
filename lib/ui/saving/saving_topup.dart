import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/network/param/ipaymu_param.dart';
import 'package:pesantren_flutter/network/param/top_up_tabungan_param.dart';
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/cara_pembayaran_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/payment_method.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class SavingTopUpScreen extends StatefulWidget {

  SavingTopUpScreen();

  @override
  State<SavingTopUpScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<SavingTopUpScreen> {

  late PaymentBloc bloc;
  bool _isLoading = false;
  RingkasanResponse? _response;
  Bayar? _selectedPayment;
  bool _insertIsLoading = false;
  IpaymuParam? _ipaymuParam;

  @override
  void initState() {
    bloc = BlocProvider.of<PaymentBloc>(context);
    super.initState();
  }

  void listener(BuildContext context, PaymentState state) async {
    if (state is TopUpTabunganLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is TopUpTabunganSuccess) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context,200);
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
        _insertIsLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context)
            .errorSnackbar("Terjadi kesalahan, respon API tidak dapat terbaca.");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  double getTotal(){
    var totalBebas = (_response?.bebas?.map((e) => int.tryParse(e.nominal ?? "") ?? 0).toList() ?? []).reduce((a, b) => a + b);
    var totalBulan = (_response?.bulan?.map((e) => int.tryParse(e.nominal ?? "") ?? 0).toList() ?? []).reduce((a, b) => a + b);

    return totalBebas.toDouble() + totalBulan.toDouble();
  }

  TextEditingController _nominalController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

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
          title: Text("Top-Up Tabungan", style: TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _nominalController,
                      decoration: InputDecoration(
                        labelText: 'Nominal',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Catatan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomSheet: PaymentMethod(context,_response?.bayar ?? [],_selectedPayment, (selected){
          setState(() {
            _selectedPayment = selected;
          });
        }, (){
          var param = TopUpTabunganParam(
            nominal: _nominalController.text,
            catatan: _nominalController.text,
          );

          if(param.isValid()){
            bloc.add(TopUpTabungan(param));
          }else{
            MySnackbar(context).errorSnackbar("Nominal tidak boleh kosong");
          }
        },
            _isLoading
         ),
      ),
    );
  }
}
