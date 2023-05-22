// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:venturo_test/model/item_model.dart';
import 'package:venturo_test/model/pesanan_model.dart';
import 'package:venturo_test/model/voucher_model.dart';
import 'package:venturo_test/source/source_item.dart';

class CPesanan extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _listItem = <ItemModel>[].obs;
  List<ItemModel> get listItem => _listItem.value;

  final _itemTotals = 0.obs;
  int get itemTotals => _itemTotals.value;

  final _priceTotal = 0.obs;
  int get priceTotal => _priceTotal.value;

  final _payTotal = 0.obs;
  int get payTotal => _payTotal.value;

  final _loadingBottomSheet = false.obs;
  bool get loadingBottomSheet => _loadingBottomSheet.value;

  final _voucher = VoucherModel().obs;
  VoucherModel get voucher => _voucher.value;

  final _voucherSuccess = false.obs;
  bool get voucherSuccess => _voucherSuccess.value;

  final _pesanan = <PesananModel>[].obs;
  List<PesananModel> get pesanan => _pesanan.value;

  final _id = 0.obs;
  int get id => _id.value;

  final _idPesanan = 0.obs;
  int get idPesanan => _idPesanan.value;
  setIdPesanan(int i) => _idPesanan.value = i;

  final _isPesananPostSuccess = false.obs;
  bool get isPesananPostSuccess => _isPesananPostSuccess.value;

  final _isPesananCancelSuccess = false.obs;
  bool get isPesananCancelSuccess => _isPesananCancelSuccess.value;

  final _totalPesanan = 0.obs;
  int get totalPesanan => _totalPesanan.value;

  addTotalPesanan(int total) async {
    _totalPesanan.value = _totalPesanan.value + total;
    update();
  }

  lessTotalPesanan(int total) async {
    _totalPesanan.value = _totalPesanan.value - total;
    update();
  }

  getListItem() async {
    _loading.value = true;
    update();
    _listItem.value = await SourceItem.getItem();
    update();
    _loading.value = false;
    update();
  }

  addTotalPrice(int total) async {
    _priceTotal.value = _priceTotal.value + total;
    _payTotal.value = _payTotal.value + total;
    update();
  }

  lessTotalPrice(int total) async {
    _priceTotal.value = _priceTotal.value - total;
    _payTotal.value = _payTotal.value - total;
    update();
  }

  getTotalItems() {
    _itemTotals.value = listItem.length;
    update();
  }

  setId(int id) => _id.value = id;

  setPesanan(String catatan, ItemModel item, int qty) async {
    final index =
        _pesanan.value.indexWhere((element) => element.id == _id.value);
    if (index >= 0) {
      _pesanan.value[index] =
          PesananModel(id: _id.value, item: item, catatan: catatan, qty: qty);
    } else {
      _pesanan.value.add(
          PesananModel(id: _id.value, item: item, catatan: catatan, qty: qty));
    }
  }

  resetPesanan() {
    _pesanan.value.clear();
    _id.value = 1;
  }

  getVoucher(String kodeVoucher) async {
    _loadingBottomSheet.value = true;
    update();
    _voucher.value = await SourceItem.getVouchers(kodeVoucher);
    update();
    if (_voucher.value.nominal != null) {
      if (_voucher.value.nominal! < _priceTotal.value) {
        _voucherSuccess.value = true;
      }
    }
    update();
    _loadingBottomSheet.value = false;
    update();
  }

  resetVoucher() {
    _voucherSuccess.value = false;
  }

  resetPayTotal(int discount) {
    if (_voucher.value.nominal != null) {
      if (_voucher.value.nominal! < _priceTotal.value) {
        _payTotal.value = _payTotal.value + discount;
      }
    }
  }

  updateVoucher(int discount) async {
    _payTotal.value = _payTotal.value - discount;
  }

  postPesanan(String body) async {
    _loading.value = true;
    update();
    _isPesananPostSuccess.value = await SourceItem.postDataPesanan(body);
    update();
    _loading.value = false;
  }

  cancelPesanan(int idPesanan) async {
    _loading.value = true;
    update();
    _isPesananCancelSuccess.value = await SourceItem.cancelPesanan(idPesanan);
    update();
    _loading.value = false;
  }

  resetAll(){
    _payTotal.value = 0;
    _priceTotal.value = 0;
    _totalPesanan.value = 0;
    resetVoucher();
  }

}
