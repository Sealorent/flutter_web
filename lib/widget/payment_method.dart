import 'package:flutter/material.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/payment_method/payment_method_screen.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';

class PaymentMethod extends StatelessWidget {
  BuildContext context;


  PaymentMethod(this.context);

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
              ScreenUtils(context).navigateTo(PaymentMethodScreen());
            },
            child: Row(
              children: [
                Image.asset("assets/circle_logo.png", width: 50,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BAC", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                    Text("Virtual Account", style: TextStyle(color: MyColors.grey_60),),
                  ],
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_right_sharp)
              ],
            ),
          ),
          SizedBox(height: 10,),
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
