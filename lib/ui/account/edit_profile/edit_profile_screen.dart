import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/param/edit_profile_param.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/login/login_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/response/pesantren_login_response.dart';
import '../../../network/response/student_login_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/my_snackbar.dart';
import '../../login/login_bloc.dart';
import '../../login/login_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int? sexValue=0;

  late LoginBloc bloc;
  bool _isLoading = false;
  String? studentImagePath;

  void loginListener(BuildContext context, LoginState state) async {
    if (state is EditProfileLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is EditProfileSuccess) {
      setState(() {
        _saveUserInfo();
        _isLoading = false;
        Navigator.pop(context);
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context).errorSnackbar("Silahkan coba lagi");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _tempatLahirController = TextEditingController();
  DateTime? _selectedTanggalLahir;
  String? _selectedSex;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _ayahController = TextEditingController();
  TextEditingController _ibuController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  late StudentLoginResponse _user;
  late PesantrenLoginResponse _pesantren;

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.student);
    var objectStudent =
        StudentLoginResponse.fromJson(json.decode(student ?? ""));

    setState(() {
      _user = objectStudent;

      _nameController.text = _user.nama ?? "";
      _tempatLahirController.text = _user.tempatlahir ?? "";
      _selectedTanggalLahir = _user.tanggallahir;
      _selectedSex = _user.gender;
      _addressController.text = "";
      _ayahController.text = _user.ayah ?? "";
      _ibuController.text = _user.ibu ?? "";
      _phoneController.text = _user.phone ?? "";
      if (_selectedSex == "P") {
        sexValue = 1;
      } else {
        sexValue = 0;
      }
    });

    _dateController.text = DateFormat("dd MMM yyyy")
        .format(_selectedTanggalLahir ?? DateTime.now());
  }

  Future<void> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren = pesantrenLoginResponseFromJson(pesantren ?? "");
    setState(() {
      _pesantren = objectpesantren;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedTanggalLahir ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedTanggalLahir) {
      setState(() {
        _selectedTanggalLahir = picked;
      });
      _dateController.text = DateFormat("dd MMM yyyy")
          .format(_selectedTanggalLahir ?? DateTime.now());
    }
  }

  Future<void> _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefData.student, jsonEncode(_user.toJson()));

  }
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _getPesantren();
    _getUser();
    bloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listener: loginListener,
      child: Scaffold(
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
          title: Text(
            "Edit Profil",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: studentImagePath == null ? _user.photo?.contains("http") == true ? Image.network(_user.photo ?? "", width: 60, height: 60, fit: BoxFit.fill,) : Image.file(File(_user.photo ?? ""), width: 60, height: 60, fit: BoxFit.fill,) : Image.file(File(studentImagePath!), width: 60, height: 60, fit: BoxFit.fill,),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  studentImagePath = image?.path;
                });
              },
              child: Center(
                child: Text(
                  "Ganti foto profil",
                  style: TextStyle(color: MyColors.primary),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Pribadi"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _tempatLahirController,
                decoration: InputDecoration(
                  labelText: 'Tempat Lahir',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _dateController,
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
                      _selectDate(context);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Jenis Kelamin"),
            ),
            Row(
              children: [
                Expanded(
                  child: _myRadioButton(
                    title: "Laki-laki",
                    value: 0,
                    onChanged: (newValue) =>
                        setState(() => sexValue = newValue),
                  ),
                ),
                Expanded(
                  child: _myRadioButton(
                    title: "Perempuan",
                    value: 1,
                    onChanged: (newValue) =>
                        setState(() => sexValue = newValue),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Keluarga"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _ayahController,
                decoration: InputDecoration(
                  labelText: 'Nama Ayah',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _ibuController,
                decoration: InputDecoration(
                  labelText: 'Nama Ibu',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'No. WhatsApp Orang Tua',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)))),
            onPressed: () async {
              var param = EditProfileParam(
                nama_santri: _nameController.text.trim(),
                alamat: _addressController.text.trim(),
                tempatlahir: _tempatLahirController.text.trim(),
                tanggallahir: DateFormat("yyyy-MM-dd").format(_selectedTanggalLahir ?? DateTime.now()),
                nomorwa: _phoneController.text.trim(),
                gender: sexValue == 0 ? "L" : "P",
                ayah: _ayahController.text.toString(),
                ibu: _ibuController.text.toString(),
                student_img: studentImagePath
              );

              _user.nama = _nameController.text.trim();
              _user.tempatlahir = _tempatLahirController.text.trim();
              _user.tanggallahir = _selectedTanggalLahir;
              _user.phone = _phoneController.text.trim();
              _user.gender = sexValue == 0 ? "L" : "P";
              _user.ayah = _ayahController.text.toString();
              _user.ibu = _ibuController.text.toString();
              _user.photo = studentImagePath;

              bloc.add(EditProfile(param));
            },
            child: Padding(
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
      ),
    );
  }

  Widget _myRadioButton(
      {required String title, required int value, Function(int?)? onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: sexValue,
      onChanged: onChanged,
      activeColor: MyColors.primary,
      title: Text(title),
    );
  }
}
