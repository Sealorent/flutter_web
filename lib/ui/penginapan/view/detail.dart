import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/network/response/list_homestay_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/penginapan/bloc/penginapan_bloc.dart';
import 'package:pesantren_flutter/utils/fonts_utils.dart';
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
              body: _body(state)
            );
        },
      )
   );
      
  }
}


Widget _body(state) {
  if(state is Loading) {
    return  ProgressLoading();
  } else if (state is DetailSuccess) {
    return ListView(
      children: [
        CarouselSlider.builder(
          itemCount: state.response?.detail?.length ?? 0, 
          itemBuilder: (context, index, realIndex) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: 
                      NetworkImage('https://s3.ap-southeast-1.wasabisys.com/file-members.kampunginggris.id/learningvideo/tUvyce6JlCpY6LoVGLSXfIGyEMO9rjClLxPEDcTU.png'),
                      // NetworkImage(state.response?.detail?[index].gallery ?? ""),
                      fit: BoxFit.fill
                    )
                  ),
                ),
                Positioned(
                  bottom: 2,
                  left: 3,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 12,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5)
                    ),

                    child: Text(
                          '${index + 1}/ ${state.response?.detail?.length }',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                  ),
                    ),
              ],
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, top: 10),
          child: Text(
           'alamat',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  } else {
    return const SizedBox();
  }
}