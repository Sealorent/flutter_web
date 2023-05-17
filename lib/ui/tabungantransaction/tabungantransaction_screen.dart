import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/response/history_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/controller/list_transaksi_tabungan_controller.dart';
import 'package:pesantren_flutter/ui/transaction/transaction_detail_screen.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/year_model.dart';
import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/screen_utils.dart';
import '../../utils/year_util.dart';
import '../../widget/option_radio.dart';
import '../payment/payment_bloc.dart';
import '../payment/payment_state.dart';