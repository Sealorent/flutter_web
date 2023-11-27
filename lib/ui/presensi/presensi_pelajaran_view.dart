import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/lesson_response.dart';
import 'package:pesantren_flutter/network/response/presensi_response_new.dart';
import 'package:pesantren_flutter/network/response/semester_response.dart';
import 'package:pesantren_flutter/ui/presensi/bloc/presensi_bloc.dart';
import 'dart:convert';

import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_bloc.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_event.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_state.dart';
import 'package:pesantren_flutter/network/response/presensi_pelajaran_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:tree_view/tree_view.dart';
import 'package:pesantren_flutter/res/my_colors.dart';


import '../../widget/tahun_ajaran_widget.dart';
import '../../preferences/pref_data.dart';
import '../../network/response/tahun_ajaran_response.dart';
import '../../utils/my_snackbar.dart';
import '../../model/month.dart';

class PresensiPelajaranView extends StatefulWidget {
  const PresensiPelajaranView({super.key});

  @override
  State<PresensiPelajaranView> createState() => _PresensiPelajaranViewState();
}



class _PresensiPelajaranViewState extends State<PresensiPelajaranView> {
  
  bool _isLoading = true;

  late PresensiBloc bloc;

  List<Lesson>? _lessonResponse;

  List<Semester>? _semesterResponse;

  List<Tahunajaran>? _tahunAjaranResponse;

  List<LaporanNew>? _laporanResponse;

  List<Month> months = [
    Month(value: "JUNI", label: "Juni"),
    Month(value: "JULI", label: "Juli"),
    Month(value: "AGUSTUS", label: "Agustus"),
    Month(value: "SEPTEMBER", label: "September"),
    Month(value: "OKTOBER", label: "Oktober"),
    Month(value: "NOVEMBER", label: "November"),
    Month(value: "DESEMBER", label: "Desember"),
    Month(value: "JANUARI", label: "Januari"),
    Month(value: "FEBRUARI", label: "Februari"),
    Month(value: "MARET", label: "Maret"),
  ];


  // make list month from juni to juli


  String? _lessonValue;
  String? _semesterValue;
  String? _tahunAjaranValue;
  String? _monthValue;



  @override
  void initState() {
    bloc = BlocProvider.of<PresensiBloc>(context);
    getData();
    super.initState();
  }

  void getData(){
    bloc.add(GetLesson());
    bloc.add(GetSemester());
    bloc.add(GetTahunAjaran());
  }

  void listener(BuildContext context, PresensiState state){
    if(state is Loading){
      

      setState(() {
        _isLoading = true;
      });

    }else if (state is Error){

      setState(() {
        _isLoading = false;
      });

      if (state.code == 401 || state.code == 0) {
        // MySnackbar(context)
        //     .errorSnackbar("Terjadi kesalahan");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());

    }else if (state is LessonSuccess){
      setState(() {
        _isLoading = false;
        _lessonResponse = state.response?.lessons; 
      });

    }else if (state is SemesterSuccess){
      setState(() {
        _isLoading = false;
        _semesterResponse = state.response?.semester; 
      });

    }else if(state is TahunAjaranSuccess){
      setState(() {
        _isLoading = false;
        _tahunAjaranResponse = state.response?.tahunajaran;
      });
    }else if(state is PresensiNewSuccess){
      setState(() {
        _isLoading = false;
        _laporanResponse = state.response?.laporan;
      });
    }
  }

  void _showAlertDialog() {
  // final size = MediaQuery.of(context).size;
    // AlertDialog alertDialog = 
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
      builder: (BuildContext context, setStateSB) {
          return AlertDialog( 
              title: Text('Filter'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  
                  children: [
                    DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Add more decoration..
                        ),
                        isDense: true, 
                        isExpanded: true,
                        hint: Text(
                          'Pilih Pelajaran',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: (_lessonResponse ?? [])
                            .map((Lesson item) => DropdownMenuItem<String>(
                                  value: item.id,
                                  child: Text(
                                    item.lessonName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: _lessonValue,
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih Pelajaran terlebih dahulu.';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          setStateSB(() {
                            _lessonValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Add more decoration..
                        ),
                        isDense: true, 
                        isExpanded: true,
                        hint: Text(
                          'Pilih Tahun Ajaran',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: _tahunAjaranResponse
                            !.map((Tahunajaran item) => DropdownMenuItem<String>(
                                  value: item.id,
                                  child: Text(
                                    item.periodStart.toString() + "/" + item.periodEnd.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: _tahunAjaranValue,
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih Tahun Ajaran terlebih dahulu.';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          setStateSB(() {
                            _tahunAjaranValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Add more decoration..
                        ),
                        isDense: true, 
                        isExpanded: true,
                        hint: Text(
                          'Pilih Semester',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: (_semesterResponse ?? [])
                            .map((Semester item) => DropdownMenuItem<String>(
                                  value: item.id,
                                  child: Text(
                                    item.semester,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: _semesterValue,
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih Semester terlebih dahulu.';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          print('Select Item: $value');
                          setStateSB(() {
                            _semesterValue = value;
                            print('Select Sem: $_semesterValue');
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Add more decoration..
                        ),
                        isDense: true, 
                        isExpanded: true,
                        hint: Text(
                          'Pilih Bulan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: months.map((Month item) => DropdownMenuItem<String>(
                                  value: item.value,
                                  child: Text(
                                    item.label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: _monthValue,
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih Bulan terlebih dahulu.';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          setStateSB(() {
                            _monthValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // _formKey.currentState!.save();
                      bloc.add(GetPresensiNew(_lessonValue, _semesterValue, _monthValue, _tahunAjaranValue));
                    }


                    
                    // if( _lessonValue != null && _semesterValue != null && _monthValue != null && _tahunAjaranValue != null){

                    //   bloc.add(GetPresensiNew(_lessonValue, _semesterValue, _monthValue, _tahunAjaranValue));
                    // }else{

                    //   // create snackbar
                    //   // MySnackbar(context).errorSnackbar("Filter Kurang Lengkap");
                    // }

                    // print('lesson $_lessonValue, semester $_semesterValue, month $_monthValue, TA $_tahunAjaranValue');

                    // // Navigator.pop(context);

                  },
                  child: Text('Filter'),
                ),
              ],
            );
        },
      ),
    );
  }

  List<Widget> generateList() {
    return _laporanResponse?.map((e) => InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                               e.detail.pelajaran,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                 DateFormat("dd MMM yyyy").format(
                                    DateTime.parse(e.detail.tanggal as String? ?? DateTime.now().toString()),
                                  ),
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                         
                          Spacer(),
                          Text(
                            e.detail.kehadiran == "H" ? "Hadir" : "Absen",
                            style: TextStyle(
                                fontSize: 12,
                                color: e.detail.kehadiran == "H"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
            .toList() ??
        [];
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<PresensiBloc, PresensiState>(
      listener: listener,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            // selectedYear = null;
          },
          child: _isLoading
              ? ProgressLoading()
              : ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // Header
                  SizedBox(
                      height: 32,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Filter"),
                            ),
                            IconButton(
                              onPressed: (){
                                _showAlertDialog();
                              }, 
                              iconSize: 20,
                              icon: const Icon(Icons.filter_list)
                            )
                          ],
                        ),
                      ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: generateList().isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Text("Tidak ada data"),
                              ),
                            )
                          : Column(children: generateList()),
                    )
                ],
              )
        ),
      ),
    );
  }


// Widget CustomDropdown<T>(
//   List<T> itemList,
//   T? selectedValue,
//   void Function(void Function()) updateState,
//   String Function(T) itemLabel,
//   T Function(T) itemValue,
// ) {
//   return DropdownButtonHideUnderline(
//     child: DropdownButton2<T>(
//       isDense: true,
//       isExpanded: true,
//       hint: Text(
//         'Select Item',
//         style: TextStyle(
//           fontSize: 14,
//           color: Theme.of(context).hintColor,
//         ),
//       ),
//       items: itemList
//           .map((T item) => DropdownMenuItem<T>(
//                 value: itemValue(item),
//                 child: Text(
//                   itemLabel(item),
//                   style: const TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ))
//           .toList(),
//       value: selectedValue,
//       onChanged: (T? value) {
//         print('Select Item: $value');
//         updateState(() {
//           selectedValue = value;
//           print('Select Sem: $selectedValue');
//         });
//       },
//       buttonStyleData: const ButtonStyleData(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         height: 40,
//         width: 140,
//       ),
//       menuItemStyleData: const MenuItemStyleData(
//         height: 40,
//       ),
//     ),
//   );
// }
  
}
