
import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/home/home_bloc.dart';
import 'package:pesantren_flutter/ui/izin/izin_bloc.dart';
import 'package:pesantren_flutter/ui/izin/izin_screen.dart';
import 'package:pesantren_flutter/ui/konfirmasi/konfirmasi.dart';
import 'package:pesantren_flutter/ui/konseling/konseling_bloc.dart';
import 'package:pesantren_flutter/ui/konseling/konseling_screen.dart';
import 'package:pesantren_flutter/ui/login/login_bloc.dart';
import 'package:pesantren_flutter/ui/mudif/mudif_bloc.dart';
import 'package:pesantren_flutter/ui/mudif/mudif_screen.dart';
import 'package:pesantren_flutter/ui/payment/main/payment_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_bloc.dart';
import 'package:pesantren_flutter/ui/penginapan/bloc/penginapan_bloc.dart';
import 'package:pesantren_flutter/ui/presensi/bloc/presensi_bloc.dart';
import 'package:pesantren_flutter/ui/presensi/presensi_screen.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_bloc.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_bloc.dart';
import 'package:pesantren_flutter/ui/saving/saving_screen.dart';
import 'package:pesantren_flutter/ui/splashscreen/splash_screen.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_bloc.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_screen.dart';
import 'package:shake/shake.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pesantren_flutter/ui/penginapan/view/penginapan.dart';

import 'network/dio_client.dart';
import 'network/firebase_api.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await FirebaseApi().initAwesomeNotification();
  Alice alice = Alice();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: MyColors.primary,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MultiBlocProvider(providers: [
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        AuthenticationRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<SavingBloc>(
      create: (context) => SavingBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<TahfidzBloc>(
      create: (context) => TahfidzBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<RekamMedisBloc>(
      create: (context) => RekamMedisBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<PresensiBloc>(
      create: (context) =>  PresensiBloc(
        MainRepositoryImpl(DioClient().init(alice, context))
      )
    ),
    BlocProvider<KonselingBloc>(
      create: (context) => KonselingBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<IzinBloc>(
      create: (context) => IzinBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<MudifBloc>(
      create: (context) => MudifBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<PaymentBloc>(
      create: (context) => PaymentBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    ),
    BlocProvider<PenginapanBloc>(
      create: (context) => PenginapanBloc(
        MainRepositoryImpl(DioClient().init(alice, context)),
      ),
    )
  ], child: MyApp(alice)));
}

class MyApp extends StatelessWidget {
  Alice? alice;

  MyApp(this.alice);
  //alice?.showInspector();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: alice?.getNavigatorKey(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(
            MyColors.materialPrimaryColorCode, MyColors.primaryColorCodes),
        primaryColor: Colors.white,
      ),
      home: SplashScreen(alice),
      routes: {
        '/Bayar': (context) => PaymentScreen(),
        '/Tabungan': (context) => SavingScreen(),
        '/Tahfidz': (context) => TahfidzScreen(),
        '/Konseling': (context) => KonselingScreen(),
        '/Konfirmasi': (context) => Konfirmasi(),
        '/Izin': (context) => IzinScreen(),
        '/Presensi': (context) => PresensiScreen(),
        '/Rekam Medis': (context) => RekamMedisScreen(),
        '/Kunjungan': (context) => MudifScreen(),
        '/Penginapan' : (context) => Penginapan(),
      },
    );
  }
}
