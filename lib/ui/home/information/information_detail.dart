import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/response/information_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/utils/show_image.dart';

import '../../../utils/screen_utils.dart';

class InformationDetailScreen extends StatefulWidget {
  Informasi? informationResponse;

  InformationDetailScreen(this.informationResponse, {Key? key})
      : super(key: key);

  @override
  State<InformationDetailScreen> createState() =>
      _InformationDetailScreenState();
}

class _InformationDetailScreenState extends State<InformationDetailScreen> {
  Future<void> share() async {
    await FlutterShare.share(
        title: widget.informationResponse?.judulInfo ?? "",
        text: widget.informationResponse?.judulInfo ?? "",
        linkUrl: widget.informationResponse?.foto ?? "",
        chooserTitle: widget.informationResponse?.judulInfo ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                share();
              },
              icon: const Icon(
                Icons.share,
                color: Colors.black54,
              ))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                ScreenUtils(context).navigateTo(ShowImage(
                    widget.informationResponse?.foto ?? "",
                    widget.informationResponse?.judulInfo ?? ""));
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: DecorationImage(
                    image: NetworkImage(widget.informationResponse?.foto ?? ""),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.informationResponse?.judulInfo ?? "",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat("EEEE, dd MMM yyyy").format(
                          widget.informationResponse?.tanggal ??
                              DateTime.now()) ??
                      "",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Html(
              data: "",
              // data: widget.informationResponse?. ?? "",
            ),
          ),
        ],
      ),
    );
  }
}
