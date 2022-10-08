import 'package:flutter/material.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/payment_method/payment_method_screen.dart';
import 'package:pesantren_flutter/utils/my_snackbar.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';

class PaymentMethod extends StatelessWidget {
  BuildContext context;
  List<Bayar> bayar;
  Bayar? selectedPembayaran;
  Function(Bayar) onSelectPayment;
  Function continueClicked;
  bool isLoading;

  PaymentMethod(this.context, this.bayar, this.selectedPembayaran,this.onSelectPayment,this.continueClicked,this.isLoading );

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Divider(),
          Text("Pilih metode pembayaran"),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              ScreenUtils(context).navigateTo(PaymentMethodScreen(bayar, (payment){
                onSelectPayment(payment);
              }));
            },
            child: selectedPembayaran == null ? Row(
              children: [
                Text("Pilih"),
                Spacer(),
                Icon(Icons.keyboard_arrow_right_sharp)
              ],
            ) : Row(
              children: [
                Image.network(selectedPembayaran?.detail?.metodeBankLogo ?? "", width: 50, errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Center(
                    child: Container(
                      child: Text("No Image", style: TextStyle(fontSize: 7),),
                    ),
                  );
                }),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selectedPembayaran?.detail?.kode ?? "", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                    Text(selectedPembayaran?.metodeBayar ?? "", style: TextStyle(color: MyColors.grey_60),),
                  ],
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_right_sharp)
              ],
            ),
          ),
          SizedBox(height: 10,),
          isLoading ? ProgressLoading() : ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                    )
                )
            ),
            onPressed: () async{
              continueClicked();
            },
            child:  Row(
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
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
