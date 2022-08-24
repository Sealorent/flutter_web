import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/edit_profile/edit_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/response/pesantren_login_response.dart';
import '../../../network/response/student_login_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/screen_utils.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

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
        title: Text("Kebijakan Privasi", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec feugiat pellentesque urna quis et. Aliquam semper facilisis potenti erat netus. Sed sem ac mauris ut semper volutpat amet curabitur.Nunc consequat, congue adipiscing sed pellentesque. Leo, id pulvinar egestas mauris cum ornare risus ullamcorper. Sed nunc egestas aliquet cursus sodales. Morbi aenean commodo facilisis pretium velit et et lectus varius.Porttitor mauris semper nibh morbi mattis molestie habitant elementum. Sit sollicitudin gravida dignissim mauris in non. Suspendisse nisi, elit mattis sed urna, aliquet neque, amet, tempor.Dictum odio vitae sed in id. Vulputate amet ante morbi hac gravida lobortis. Senectus aenean est a et. Suscipit a, neque nunc varius dolor turpis mattis porttitor. Tristique rhoncus nisl viverra tellus porta netus facilisis imperdiet leo. Morbi lectus nisl a congue aliquam praesent pellentesque commodo ipsum.Ipsum pulvinar nulla faucibus a pellentesque. Ultrices dignissim vel id nulla tortor ut tristique sollicitudin."
                ),
            ),

          ]
        ),
      ),
    );
  }
}
