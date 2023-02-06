// ignore_for_file: unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/verify_password/verify_password_controller.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class GetOtp extends StatefulWidget {
  String kodeSekolah;
  String nis;
  GetOtp(this.kodeSekolah, this.nis, {Key? key}) : super(key: key);

  @override
  State<GetOtp> createState() => _GetOtpState();
}

class _GetOtpState extends State<GetOtp> {
  bool isLoading = false;
  @override
  void initState() {
    Get.put(VerifyOtpController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyOtpController>(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                "Verifikasi Kode OTP",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 70,
              ),
              const Center(
                child: Text(
                    "Kami Sudah Mengirimkan Kode OTP Ke dalam Whatsapp Anda"),
              ),
              const SizedBox(
                height: 30,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                pinTheme: PinTheme(
                    selectedColor: Colors.green,
                    fieldWidth: 40,
                    fieldHeight: 40),
                onChanged: (value) => _.inputCode,
                controller: _.inputCode,
              ),
              const SizedBox(
                height: 70,
              ),
              Center(
                child: Column(
                  children: [
                    _.isLoading
                        ? ProgressLoading()
                        : ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        MyColors.primary),
                                shape: MaterialStateProperty.resolveWith<
                                    OutlinedBorder>((_) {
                                  return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20));
                                })),
                            onPressed: () {
                              _.GetOtp(
                                  '${widget.kodeSekolah}', '${widget.nis}');
                            },
                            child: const Text("Verifikasi")),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
