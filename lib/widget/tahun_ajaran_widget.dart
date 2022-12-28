import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/response/tahun_ajaran_response.dart';
import '../preferences/pref_data.dart';
import '../res/my_colors.dart';

class TahunAjaranWidget extends StatefulWidget {

  TahunAjaranResponse? tahunAjaranResponse;
  Function(Tahunajaran) onSelectTahunAjaran;
  Function onSelectAll;

  TahunAjaranWidget({required this.onSelectTahunAjaran,required this.onSelectAll, this.tahunAjaranResponse});

  @override
  State<TahunAjaranWidget> createState() => _TahunAjaranWidgetState();
}

class _TahunAjaranWidgetState extends State<TahunAjaranWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Center(
          child: Container(
            width: 50,
            height: 8,
            decoration: BoxDecoration(
              color: MyColors.grey_20,
              borderRadius:
              BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Pilih tahun ajaran",style: TextStyle(color: Colors.black.withOpacity(0.4)),),
        ),
        SizedBox(height: 20,),
        Expanded(
          child: ListView(
            children: [
              InkWell(
                onTap: (){
                  widget.onSelectAll();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text("Semua",style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 18,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Column(
                children: widget.tahunAjaranResponse?.tahunajaran?.map((e) => Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onSelectTahunAjaran(e);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text("${e.getTitle()}",style: TextStyle(fontSize: 18),),
                            Spacer(),
                            Visibility(
                                visible: e.isSelected,
                                child: Icon(Icons.check, size: 18,color: Colors.green,))
                          ],
                        ),
                      ),
                    ),
                  ],
                )).toList() ?? [],
              )
            ],
          ),
        )
      ],
    );
  }
}
