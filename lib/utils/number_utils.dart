import 'package:intl/intl.dart';

class NumberUtils {
  static String toRupiah(double value) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    String formatted = formatCurrency.format(value);
    return formatted.substring(0, formatted.length - 3);
  }
}
