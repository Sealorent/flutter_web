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
  AlertDialog alertDialog = AlertDialog( 
    
    title: Text('Filter'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownMenu<String>(
            label: Text('Pelajaran'),
            // initialSelection: _lessonResponse?[0].id,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _lessonValue = value!;
              });
            },
            dropdownMenuEntries: (_lessonResponse ?? []).map<DropdownMenuEntry<String>>((Lesson lesson) {
                return DropdownMenuEntry<String>(
                  value: lesson.id, 
                  label: lesson.lessonName
                );
              }).toList(),
        ),
        SizedBox(
          height: 10,
        ),
        DropdownMenu<String>(
            label: Text('Tahun Ajaran'),
            width: 250,
            // initialSelection: _tahunAjaranResponse?[0].id,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _tahunAjaranValue = value!;
              });
            },
            dropdownMenuEntries: (_tahunAjaranResponse ?? []).map<DropdownMenuEntry<String>>((Tahunajaran ta) {
                return DropdownMenuEntry<String>(
                  value: ta.id.toString(), 
                  // make string 
                  label: ta.periodStart.toString() + "/" + ta.periodEnd.toString()
                );
              }).toList(),
        ),
        SizedBox(
          height: 10,
        ),
        DropdownMenu<String>(
            label: Text('Semester'),
            width: 250,
            // initialSelection: _semesterResponse?[0].semester,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _semesterValue = value!;
              });
            },
            dropdownMenuEntries: (_semesterResponse ?? []).map<DropdownMenuEntry<String>>((Semester semester) {
                return DropdownMenuEntry<String>(
                  value: semester.id, 
                  label: semester.semester
                );
              }).toList(),
        ),
        SizedBox(
          height: 10,
        ),
        DropdownMenu<String>(
            label: Text('Bulan'),
            width: 250,
            // initialSelection: months[0].value,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _monthValue = value!;
              });
            },
            dropdownMenuEntries: months.map<DropdownMenuEntry<String>>((Month month) {
                return DropdownMenuEntry<String>(
                  value: month.value, 
                  label: month.label
                );
              }).toList(),
        ),
      ],
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
          
          if( _lessonValue != null && _semesterValue != null && _monthValue != null && _tahunAjaranValue != null){
            bloc.add(GetPresensiNew(_lessonValue, _semesterValue, _monthValue, _tahunAjaranValue));
          }else{
            // create snackbar
             MySnackbar(context)
          .errorSnackbar("lengkapi filter");

          }
          print('lesson $_lessonValue, semester $_semesterValue, month $_monthValue, TA $_tahunAjaranValue');
          Navigator.pop(context);

        },
        child: Text('Filter'),
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
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

  
}
