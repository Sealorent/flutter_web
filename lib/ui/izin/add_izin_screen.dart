import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/model/year_model.dart';
import 'package:pesantren_flutter/network/param/izin_keluar_param.dart';
import 'package:pesantren_flutter/network/param/izin_pulang_param.dart';
import 'package:pesantren_flutter/network/response/izin_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/izin/izin_bloc.dart';
import 'package:pesantren_flutter/ui/izin/izin_event.dart';
import 'package:pesantren_flutter/ui/izin/izin_state.dart';
import 'package:pesantren_flutter/ui/payment/pay_bills_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_bloc.dart';
import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/utils/year_util.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class AddIzinScreen extends StatefulWidget {
  bool isIzinKeluar;

  AddIzinScreen(this.isIzinKeluar);

  @override
  State<AddIzinScreen> createState() => _AddIzinScreenState();
}

class _AddIzinScreenState extends State<AddIzinScreen> {

  late IzinBloc bloc;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _selectedDateRange = null;
  TimeOfDay _selectedTimeStartTime = TimeOfDay.now();
  TimeOfDay _selectedTimeEndTime = TimeOfDay.now();
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  TextEditingController _keperluanController = TextEditingController();

  @override
  void initState() {
    bloc = BlocProvider.of<IzinBloc>(context);
    _dateController = TextEditingController(text: DateFormat("dd MMM yyyy").format(_selectedDate));
    _timeController = TextEditingController();
    super.initState();
  }

  void listener(BuildContext context, IzinState state) async {
    if (state is AddIzinLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is AddIzinSuccess) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, 200);
      });
    } else if (state is FailedState) {
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
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _dateController.text = DateFormat("dd MMM yyyy").format(_selectedDate);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        // initialDateRange: DateTimeRange(
        //   end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
        //   start: DateTime.now(),
        // ),
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              )
            ],
          );
        });
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDateRange = picked;
      });
      _dateController.text = "${DateFormat("dd MMM yyyy").format(_selectedDateRange?.start ?? DateTime.now())} - ${DateFormat("dd MMM yyyy").format(_selectedDateRange?.end ?? DateTime.now())}";
    }
  }

  void _selectTime() async {
    TimeRange result = await showTimeRangePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyColors.primary,
            accentColor: MyColors.primary,
            colorScheme: ColorScheme.light(primary: MyColors.primary),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    setState(() {
      _selectedTimeStartTime = result.startTime;
      _selectedTimeEndTime = result.endTime;
    });


    _timeController.text = getFormatRangeTime();
  }

  String getFormatRangeTime(){
    var str = "${_selectedTimeStartTime.hour.toString().padLeft(2, '0')}:${_selectedTimeStartTime.minute.toString().padLeft(2, '0')}";
    var end = "${_selectedTimeEndTime.hour.toString().padLeft(2, '0')}:${_selectedTimeEndTime.minute.toString().padLeft(2, '0')}";
    return "$str-$end";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IzinBloc, IzinState>(
        listener: listener,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            title: Text(widget.isIzinKeluar ? "Izin Keluar" : "Izin Pulang", style: TextStyle(color: Colors.white),),
          ),
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: (){
                        FocusScope.of(context).unfocus();
                        if(widget.isIzinKeluar){
                          _selectDate(context);
                        }else{
                          _selectDateRange(context);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Pilih Tanggal',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: MyColors.primary,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.isIzinKeluar,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _timeController,
                            readOnly: true,
                            onTap: (){
                              FocusScope.of(context).unfocus();
                              _selectTime();
                            },
                            decoration: InputDecoration(
                              labelText: 'Pilih Jam',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.access_time_rounded,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: _keperluanController,
                      decoration: InputDecoration(
                        labelText: 'Keperluan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10,),
                    _isLoading ? ProgressLoading() : ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)
                              )
                          )
                      ),
                      onPressed: () async{
                        if(widget.isIzinKeluar){
                          var izinParam = IzinKeluarParam(
                            tanggalIzin: DateFormat("yyyy-MM-dd").format(_selectedDate),
                            waktuIzin: getFormatRangeTime(),
                            keperluanIzin: _keperluanController.text.toString()
                          );
                          bloc.add(AddIzinKeluar(izinParam));
                        }else{
                          var izinPulang = IzinPulangParam(
                            tanggalPulang: DateFormat("yyyy-MM-dd").format(_selectedDateRange?.start ?? DateTime.now()),
                            hariPulang: _selectedDateRange?.start.difference(_selectedDateRange?.end ?? DateTime.now() ).inDays.toString().replaceAll("-", ""),
                            keperluanPulang: _keperluanController.text.toString()
                          );
                          bloc.add(AddIzinPulang(izinPulang));
                        }
                      },
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ajukan Izin",
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
              ),

            ],
          ),
        ),
    );
  }
}
