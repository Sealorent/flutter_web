import 'package:intl/intl.dart';

class NumberUtils {
  static String toRupiah(double value) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID');
    String formatted = formatCurrency.format(value);
    return formatted.substring(0, formatted.length - 3);
  }
}
