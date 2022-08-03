import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/my_colors.dart';

class ProgressLoading extends StatelessWidget {
  double size;
  double stroke;
  Color color;
  bool isDark;

  ProgressLoading(
      {this.size = 20,
      this.stroke = 2,
      this.color = MyColors.accentDark,
      this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: size,
          height: size,
          child: CircularProgressIndicator(strokeWidth: stroke)),
    );
  }
}
