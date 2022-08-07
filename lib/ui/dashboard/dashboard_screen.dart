import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/ui/home/home_screen.dart';
import 'package:pesantren_flutter/ui/transaction/transaction_screen.dart';

import '../../res/my_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: MyColors.primary,
        statusBarIconBrightness: Brightness.light
    ));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          HomeScreen(),
          TransactionScreen(),
          Container(),
          Container(),
        ],
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Beranda',
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Transaksi',
            icon: Icon(Icons.assignment),
          ),
          BottomNavigationBarItem(
            label: 'Bantuan',
            icon: Icon(Icons.live_help),
          ),
          BottomNavigationBarItem(
            label: 'Akun',
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
    );
  }
}
