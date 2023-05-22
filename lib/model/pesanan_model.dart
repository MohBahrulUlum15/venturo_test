import 'package:venturo_test/model/item_model.dart';

class PesananModel {
  int id;
  ItemModel item;
  String? catatan;
  int qty;

  PesananModel({required this.id, required this.item, this.catatan, required this.qty});
}