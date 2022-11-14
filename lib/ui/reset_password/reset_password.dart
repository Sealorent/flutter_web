// ignore_for_file: unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/reset_password/reset_password_controller.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  String nis;
  String kodeSekolah;
  ResetPassword(this.nis, this.kodeSekolah, {Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool isLoading = false;
  @override
  void initState() {
    Get.put(LupaPasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LupaPasswordController>(builder: (_) {
        return Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 0),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Center(
                        child: SvgPicture.asset("assets/My_password_amico.svg",
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.3),
                      ),
                    ),
                    const Text(
                      "Reset Password Anda",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _.inputPasswordBaru,
                              obscureText: !_passwordVisible1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(
                                      () {
                                        _passwordVisible1 = !_passwordVisible1;
                                      },
                                    );
                                  },
                                ),
                                hintText: 'Masukkan Password yang Baru',
                                labelText: 'Masukkan Password yang Baru',
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                ),
                                filled: true,
                                fillColor: const Color(0xffFFFFFF),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _.inputPassword,
                              obscureText: !_passwordVisible2,
                              decoration: InputDecoration(
                                labelText: 'Konfirmasi Password yang Baru',
                                hintText: "Konfirmasi Password yang Baru",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(
                                      () {
                                        _passwordVisible1 = !_passwordVisible1;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Center(
                        child: Column(
                          children: [
                            isLoading
                                ? ProgressLoading()
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                MyColors.primary),
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>((_) {
                                          return RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20));
                                        })),
                                    onPressed: () {
                                      _.ResetPass('${widget.nis}',
                                          '${widget.kodeSekolah}');
                                    },
                                    child: const Text("Verifikasi")),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
