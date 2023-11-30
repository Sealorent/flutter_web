
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pesantren_flutter/network/response/donasi_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/donasi/bloc/donasi_bloc.dart';
import 'package:pesantren_flutter/utils/fonts_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';


class Donasi extends StatefulWidget {
  const Donasi({super.key});

  @override
  State<Donasi> createState() => _DonasiState();
}

class _DonasiState extends State<Donasi> {

  DonasiBloc get bloc => BlocProvider.of<DonasiBloc>(context);
  

  var _filterList;

  final List<DataDonasiCategory> _categoryList = [
    DataDonasiCategory(categoryId: 1, categoryName: 'Masjid', categoryDesc: 'Masjid Baiturohman Malang'),
    DataDonasiCategory(categoryId: 2, categoryName: 'Pendidikan', categoryDesc: 'Pendidikan Anak Yatim'),
    DataDonasiCategory(categoryId: 3, categoryName: 'Kesehatan', categoryDesc: 'Kesehatan Anak Yatim'),
    DataDonasiCategory(categoryId: 4, categoryName: 'Sosial', categoryDesc: 'Sosial Anak Yatim'),
    DataDonasiCategory(categoryId: 5, categoryName: 'Lainnya', categoryDesc: 'Lainnya Anak Yatim'),
    DataDonasiCategory(categoryId: 5, categoryName: 'Lai', categoryDesc: 'Lainnya Anak Yatim'),
    DataDonasiCategory(categoryId: 5, categoryName: 'lo', categoryDesc: 'Lainnya Anak Yatim'),
  ];

  final List<DataDonasi> _donasiData = [
    DataDonasi(
      donasiId: 1, 
      donasiTitle: 'Bangun Pojok Baca Untuk Anak-Anak Pulau Messah', 
      donasiDesc: 'Ratusan anak Messah tidak punya perpustakaan dan kekurangan buku bacaan. Ayo, bantu mereka dengan hadirkan pojok baca di Pulau Messah', 
      donasiImage: 'https://digital-api.dompetdhuafa.org/storage/56428/conversions/0943a2aac55c222a4cf91ade0f73de8d-large.jpg', donasiStartDate: '2024-11-23', donasiEndDate: '2024-12-02', donasiTarget: 10000000, donasiCategoryId: 1),
    DataDonasi(
      donasiId: 1, 
      donasiTitle: 'Bantuan Modal Usaha Kuatkan Pejuang Keluarga Mencari Nafkah', 
      donasiDesc: 'Berjuang hingga usia senja demi keluarga. Bantu kuatkan pejuang keluarga mencari nafkah!', 
      donasiImage: 'https://digital-api.dompetdhuafa.org/storage/57711/conversions/8f0486dc424156483009de29b0ca4724-small.jpg', donasiStartDate: '2024-11-23', donasiEndDate: '2024-12-02', donasiTarget: 10000000, donasiCategoryId: 1),
  ];

  @override
  void initState() {
    bloc.add(GetDonasi());
    _filter(_categoryList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<DonasiBloc, DonasiState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: _appBar(context, size),
            body: _body(state, size),
          );
        },
      ),
    );
  }

  _appBar(context, size){
    return AppBar(
      leading: Container(
        margin: EdgeInsets.only(left: 10),
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(null),
              ),
            );
          },
        ),
      ),
      centerTitle: true,
      elevation: 5,
      flexibleSpace: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_donasi.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.grey.withOpacity(0.8), // 50% gray color at the bottom
                    Colors.transparent, // Transparent at the top
                  ],
                  stops: [0.1, 1.0], // 50% height
                ),
              ),
            ),
          ],
        ),
      bottom:  PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Column(
          children: [
            SizedBox(
              child: Center(
                child: Text(
                  'Mari Sisihkan Sedekit Rejeki kita untuk mereka yang membutuhkan',
                  style: titleAppBarDonasi,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
            height: size.height * 5 / 100,
            ),
          ],
        ),
      ),
      backgroundColor: MyColors.primary,
    );
  }

  Widget _body(state, size){
    if (state is Loading) {
      return const  Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is DonasiSuccess) {
        return _main(state, size);
    } else {
      return const Center(
        child: Text('Error'),
      );
    }
  }

  Widget _main(state, size){
  return ListView(
    scrollDirection: Axis.vertical,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: size.width / 7, // Set the height of your slider
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:_filterList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ChoiceChip(
                  label: Text('${_filterList[index][1]}') ,
                  selected: _filterList[index][3],
                  selectedColor: MyColors.primary.withOpacity(0.3),
                  onSelected: (bool selected) {
                    setState(() {
                      _filterList[index][3] =  !_filterList[index][3];
                    });
              
                    _filterList;
              
                    print("list filter : ${_filterList.map((e) => e[3])}");
              
                    // setState(() {});
              
                    print(_filterList);
                    
                  },
                ),
              );
            },
          ),
        ),
      ),
       Container(
          height: size.height * 0.7,
         child: ListView.builder(
          itemCount: _donasiData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: [
                  Image.network(
                    _donasiData[index].donasiImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: size.height * 0.2,
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: Text(
                        _donasiData[index].donasiTitle,
                        style: titleFontBold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical:5.0),
                      child: Text(
                        _donasiData[index].donasiDesc,
                        style: descFont,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Image.network(
                          'https://epesantren.co.id/wp-content/uploads/2021/09/epesantren_hitm.png',
                          fit: BoxFit.cover,
                          width: size.width * 0.1,

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'E-Pesantren',
                            style: titleFontBold.copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child:  LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 10,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2500,
                      percent: 0.8,
                      // center: Text("80.0%", style: descFont.copyWith(color: Colors.white),),
                      barRadius:Radius.circular(10),
                      progressColor: MyColors.primary,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.fromLTRB(10,10,10,20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terkumpul',
                              style: descFont,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              formatCurrency(_donasiData[index].donasiTarget.toDouble()),
                              style: titleFontBold.copyWith(
                                fontSize: 14,
                                color: MyColors.primary
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Sisa Hari',
                              style: descFont,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '2',
                              style: titleFontBold.copyWith(
                                fontSize: 14,
                                color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
             ),
       ),
    ],
  );
  }

  String formatCurrency(double amount) {
    // Create a NumberFormat instance for Indonesian Rupiah
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    // Format the amount as currency
    return formatCurrency.format(amount);
  }
  void _filter(List<DataDonasiCategory> categories) {
    _filterList = categories.map((e){
      return [
        e.categoryId,
        e.categoryName,
        e.categoryDesc,
        false
      ];
    }).toList();
    // print(_filterList);
  }
}


 