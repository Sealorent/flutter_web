import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/konfirmasi/controller_konfirmasi.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';

class UploadBuktiPage extends StatefulWidget {
  const UploadBuktiPage({super.key});

  @override
  State<UploadBuktiPage> createState() => _UploadBuktiPageState();
}

class _UploadBuktiPageState extends State<UploadBuktiPage> {
  XFile? image;
  TextEditingController keterangan = TextEditingController();
  bool isLoadingUpload = false;

  @override
  void initState() {
    Get.put(KonfirmasiController());
    super.initState();
  }

  void _detailBottomImage() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return SizedBox(
              height: Get.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: 50,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  // ignore: prefer_const_constructors
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: () async {
                                var imagePicker = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  image = imagePicker;
                                  // ignore: unnecessary_null_comparison
                                  if (image == null) {
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.red,
                                        msg: "Belum Memilih Gambar");
                                  }
                                  Get.back();
                                });
                              },
                              child: Center(
                                // ignore: prefer_const_literals_to_create_immutables
                                child: Column(children: [
                                  const Icon(Icons.image,
                                      size: 40, color: MyColors.primary),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Galery",
                                    style: TextStyle(fontSize: 20),
                                  )
                                ]),
                              )),
                          InkWell(
                              onTap: () async {
                                var imagePicker = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);

                                setState(() {
                                  image = imagePicker;
                                  // ignore: unnecessary_null_comparison
                                  if (image == null) {
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.red,
                                        msg: "Belum Memilih Gambar");
                                  }
                                  Get.back();
                                });
                              },
                              child: Center(
                                // ignore: prefer_const_literals_to_create_immutables
                                child: Column(children: [
                                  const Icon(Icons.camera_alt,
                                      size: 40, color: MyColors.primary),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Camera",
                                    style: TextStyle(fontSize: 20),
                                  )
                                ]),
                              )),
                        ],
                      )),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Upload Bukti Bayar",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: keterangan,
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  image == null
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(-2, 2),
                                  color: Colors.grey.shade400,
                                )
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 180,
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 60,
                            ),
                          ),
                        )
                      : Container(
                          width: Get.width * 0.5,
                          height: 220,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(File(image!.path))),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0))),
                      backgroundColor:
                          MaterialStateProperty.all(MyColors.primary),
                    ),
                    onPressed: () {
                      _detailBottomImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Upload",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.apply(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              GetBuilder<KonfirmasiController>(builder: (_) {
                return isLoadingUpload
                    ? ProgressLoading()
                    : ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))),
                          backgroundColor:
                              MaterialStateProperty.all(MyColors.primary),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoadingUpload = _.isUpload;
                          });
                          _.uploadBukti(keterangan.text, File(image!.path));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Kirim Bukti",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
