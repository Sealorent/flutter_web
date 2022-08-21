import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: (){

            },
            child: SvgPicture.asset("assets/ic_web.svg")),
        SizedBox(width: 10,),
        InkWell(
            onTap: (){

            },
            child: SvgPicture.asset("assets/ic_facebook.svg")),
        SizedBox(width: 10,),
        InkWell(
            onTap: (){

            },
            child: SvgPicture.asset("assets/ic_instagram.svg")),
        SizedBox(width: 10,),
        InkWell(
            onTap: (){

            },
            child: SvgPicture.asset("assets/ic_youtube.svg")),

      ],
    );
  }
}
