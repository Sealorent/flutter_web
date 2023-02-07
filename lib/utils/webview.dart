import 'package:flutter/material.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widget/progress_loading.dart';

class CustomWebView extends StatefulWidget {
  String link;
  String title;

  CustomWebView(this.link, this.title, {Key? key}) : super(key: key);

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // ignore: unnecessary_brace_in_string_interps, prefer_const_constructors
          title: Text(widget.title),
          backgroundColor: MyColors.primary,
          centerTitle: true,
        ),
        body: WebView(
          initialUrl: widget.link,
          onProgress: (progress) {
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 30, right: 30, bottom: 30),
                    child: Text(
                      "Loading.... $progress",
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  ProgressLoading()
                ],
              ),
            );
          },
          initialCookies: [
            WebViewCookie(name: "", value: "selesai", domain: widget.link)
          ],
        ));
  }
}
