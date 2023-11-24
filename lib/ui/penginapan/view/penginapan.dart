import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/response/list_homestay_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/penginapan/bloc/penginapan_bloc.dart';
import 'package:pesantren_flutter/utils/fonts_utils.dart';
import 'package:pesantren_flutter/utils/my_snackbar.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';


class Penginapan extends StatefulWidget {
  const Penginapan({super.key});

  @override
  State<Penginapan> createState() => _PenginapanState();
}

class _PenginapanState extends State<Penginapan> {


  bool _isLoading = true;

  late PenginapanBloc bloc;

  List<HomeStay>? _penginapanResponse;

  final List<HomeStay> _penginapanResponseDummy = [
    HomeStay(homestayId: '1', homestayName: 'Ovo 9075 Zevaanna Guest House Syariah', homestayPrice: '100000', homestayDesc: 'Kamar Tidur terdapat tempat tidur, lemari, cermin, peralatan sholat, 1 kamar mandi dalam. Dapur terdapat kulkas, dispenser, alat masak, penanak nasi. Ruang tamu terdapat sofa, dispenser, televisi, rooftop lt 2. Kamar mandi terdapat water heater, wc duduk, wastafel, bathtub, shower. Tersedia Carport(Garasi)', homestayLongitude: 
    '112.0599685', homestayLatitude: '-7.8841076'),
    HomeStay(homestayId: '1', homestayName: 'Barokah Homestay', homestayPrice: '100000', homestayDesc: 'Kamar Tidur terdapat tempat tidur, lemari, cermin, peralatan sholat, 1 kamar mandi dalam. Dapur terdapat kulkas, dispenser, alat masak, penanak nasi. Ruang tamu terdapat sofa, dispenser, televisi, rooftop lt 2. Kamar mandi terdapat water heater, wc duduk, wastafel, bathtub, shower. Tersedia Carport(Garasi)', homestayLongitude: 
    '112.0599685', homestayLatitude: '-7.8841076')
  ];

 @override
  void initState() {
    bloc = BlocProvider.of<PenginapanBloc>(context);
    getData();
    super.initState();
  }


  void getData(){
    bloc.add(GetPenginapan());
  }

  void listener(BuildContext context, PenginapanState state){
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

    }else if (state is PenginapanSuccess){
      setState(() {
        _isLoading = false;
        _penginapanResponse = state.response?.homestay; 
        print("res : $_penginapanResponse");
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<PenginapanBloc, PenginapanState>(
      listener: listener,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          title:  Text(
            "Penginapan",
            style: titleAppBar,
          ),
          backgroundColor: MyColors.primary,
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            // selectedYear = null;
          },
          child: _isLoading
              ? ProgressLoading()
              : ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Column(
                        children: [
                          Container(
                            width: size.width,
                            height: size.height,
                            // color: Colors.red,
                            child: _penginapanResponse!.isEmpty ? Center(child: Text("Data Kosong"),) :
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _penginapanResponse!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), 
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: () {
                                      debugPrint('Card tapped.');
                                    },
                                    child: SizedBox(
                                      // width: size.width * 0.4,
                                      // height: size.height * 0.2,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            'https://fastly.picsum.photos/id/1/300/300.jpg?hmac=w1b4AOJM9vszS0a867iY2NXBzwc4LCeA0U6sEjdlSDk',
                                            width: size.width,
                                            height: size.height * 0.2,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            // color: Colors.yellow,
                                            width: size.width,
                                            // height: size.height * 0.1,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                         Expanded(
                                                              child: Text(
                                                                _penginapanResponse![index].homestayName ?? "",
                                                                style: titleFontBold,
                                                                softWrap: true,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                            Icon(
                                                              Icons.favorite_outline,
                                                              color: Colors.green,
                                                            ),
                                                            Icon(
                                                              Icons.share,
                                                              color: Colors.green,
                                                            ),
                                                            ]
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(
                                                        _penginapanResponse![index].homestayDesc ?? "",
                                                        style: descFont,
                                                        softWrap: true,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 5,
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Rp. ${_penginapanResponse![index].homestayPrice ?? ""}",
                                                            style: regularFont,
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                          
                                                        ]
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                );
                              },
                            )
                          ),

                        ],
                      ),
                      )
                  
                ]
              )
        ),
      ),
    );
  }
}