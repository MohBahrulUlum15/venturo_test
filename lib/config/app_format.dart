import 'package:intl/intl.dart';

class AppFormat {
  static String formatRupiah(String price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(double.parse(price));
  }
}
