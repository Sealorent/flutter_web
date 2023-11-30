import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/network/response/list_homestay_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/penginapan/bloc/penginapan_bloc.dart';
import 'package:pesantren_flutter/ui/penginapan/view/penginapan.dart';
import 'package:pesantren_flutter/utils/fonts_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';


class DetailPenginapan extends StatefulWidget {
  String homeStayId;
  String name;

   DetailPenginapan({super.key, required this.homeStayId, required this.name});

  @override
  State<DetailPenginapan> createState() => _DetailPenginapanState();
}
class _DetailPenginapanState extends State<DetailPenginapan> {
  PenginapanBloc get bloc => BlocProvider.of<PenginapanBloc>(context);
  int _current = 0;

  @override
  void initState() {
    bloc.add(GetDetailPenginapan(widget.homeStayId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<PenginapanBloc, PenginapanState>(
        listener: (context, state) {
          if (state is Error) {
            Get.snackbar(
              "Error",
              state.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(state) {
    if (state is Loading) {
      return ProgressLoading();
    } else if (state is DetailSuccess) {
      return ListView(
        children: [
          Stack(
            children: [
              CarouselSlider.builder(
                itemCount: state.response?.detail?.length ?? 0,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://digital-api.dompetdhuafa.org/storage/58534/conversions/015afefbcdfaea28c4a610a48697829f-large.jpg',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: kToolbarHeight,
                  // color: Colors.green.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 10,
                        height: MediaQuery.of(context).size.width / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.5), // Your desired background color
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              size: 20,
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              ScreenUtils(context).navigateTo(Penginapan());
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){

                        }, 
                        icon: const Icon(
                          Icons.favorite_border, 
                          color: Colors.white
                          )
                        )
                      // Add other leading buttons as needed
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  // color: Colors.green.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      color: Colors.grey.withOpacity(0.5),
                      margin: EdgeInsets.all(3.0),
                      child: Text(
                        '${_current + 1}/${state.response?.detail?.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Alamat',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

