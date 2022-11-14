import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/forgot_password/forgot_password_controller.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoadingPassword = false;
  // ignore: prefer_final_fields
  @override
  void initState() {
    Get.put(GetOtpController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<GetOtpController>(builder: (_) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Color.fromARGB(255, 42, 141, 187),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Center(
                        child: SvgPicture.asset(
                            "assets/Two_factor_authentication_bro.svg",
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.3),
                      ),
                    ),
                    const Text(
                      "Anda Lupa Password??",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Masukkan Data Berikut",
                      style: TextStyle(fontSize: 15),
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
                              controller: _.inputKodeSekolah,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Kode Sekolah",
                                labelText: 'Kode Sekolah',
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                ),
                                filled: true,
                                fillColor: Color(0xffFFFFFF),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _.inputNis,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "NIS Siswa",
                                labelText: 'NIS Siswa',
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                ),
                                filled: true,
                                fillColor: Color(0xffFFFFFF),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _.inputWa,
                              keyboardType: TextInputType.number,
                              // ignore: prefer_const_constructors
                              decoration: InputDecoration(
                                labelText: 'Nomor Whatsapp',
                                hintText: "Nomor Whatsapp",
                                border: const OutlineInputBorder(),
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
                    Center(
                      child: Column(
                        children: [
                          isLoadingPassword
                              ? ProgressLoading()
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              MyColors.primary),
                                      shape: MaterialStateProperty.resolveWith<
                                          OutlinedBorder>((_) {
                                        return RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20));
                                      })),
                                  onPressed: () {
                                    isLoadingPassword = true;
                                    _.GetOtpMethod();
                                  },
                                  child: const Text("Verifikasi")),
                          const SizedBox(height: 5),
                        ],
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
