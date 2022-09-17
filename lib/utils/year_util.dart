import 'package:intl/intl.dart';
import 'package:pesantren_flutter/model/year_model.dart';

class YearUtils {
  static List<YearModel> getYearModel(int startYear) {
    startYear = 2019;
    var curYear = DateTime.now().year;
    var yrs = <YearModel>[];
    for(int i = startYear; i < curYear; i++){
      var fYear = DateTime(i,6,1);
      var sYear = fYear.add(Duration(days: 365));

      yrs.add(YearModel("${fYear.year}/${sYear.year}", fYear, sYear));
    }
    return yrs;
  }
}
