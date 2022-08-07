import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  int? sexValue;

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
            color: MyColors.grey_5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: Text("Edit Profil", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://preview.keenthemes.com/metronic-v4/theme_rtl/assets/pages/media/profile/profile_user.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 4.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){

              },
              child: Center(
                child: Text(
                  "Ganti foto profil",
                  style: TextStyle(
                      color: MyColors.primary
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Pribadi"),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tempat Lahir',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      Icons.calendar_today,
                      color: MyColors.primary,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Jenis Kelamin"
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _myRadioButton(
                    title: "Laki-laki",
                    value: 0,
                    onChanged: (newValue) => setState(() => sexValue = newValue),
                  ),
                ),
                Expanded(
                  child: _myRadioButton(
                    title: "Perempuan",
                    value: 1,
                    onChanged: (newValue) => setState(() => sexValue = newValue),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Keluarga"),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Ayah',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Ibu',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'No. WhatsApp Orang Tua',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 150,)
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

          },
          child:  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Simpan",
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

  Widget _myRadioButton({required String title, required int value, Function(int?)? onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: sexValue,
      onChanged: onChanged,
      activeColor: MyColors.primary,
      title: Text(title),
    );
  }
}
