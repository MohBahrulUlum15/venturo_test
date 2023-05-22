import 'package:get/get.dart';
import 'package:venturo_test/controller/c_pesanan.dart';
import 'package:venturo_test/model/item_model.dart';
import 'package:venturo_test/model/voucher_model.dart';

import '../config/api.dart';
import '../config/app_request.dart';

class SourceItem {
  static Future<List<ItemModel>> getItem() async {
    String url = '${Api.baseUrl}/menus';
    Map? responseBody = await AppRequest.getMethod(url);

    if (responseBody == null) return [];
    if (responseBody.isNotEmpty) {
      List list = responseBody['datas'];
      return list.map((e) => ItemModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<VoucherModel> getVouchers(String kode) async {
    String url = '${Api.baseUrl}/vouchers?kode=$kode';
    Map? responseBody = await AppRequest.getMethod(url);
    if (responseBody == null) return VoucherModel();
    if (responseBody['status_code'] == 204) return VoucherModel();
    VoucherModel voucher = VoucherModel.fromJson(responseBody['datas']);
    return voucher;
  }

  static Future<bool> postDataPesanan(String body) async {
    String url = '${Api.baseUrl}/order';
    Map? responseBody = await AppRequest.postMethod(url, body);
    if (responseBody == null) return false;
    if (responseBody["status_code"] == 200) {
      print(responseBody['status_code']);
      print(responseBody['message']);
      print(responseBody['status_code'] == 200);
      final cPesanan = Get.put(CPesanan());
      cPesanan.setIdPesanan(responseBody['id']);
      return true;
    }
    print(responseBody['status_code']);
    print(responseBody['message']);
    print(responseBody['status_code'] == 200);
    return responseBody['status_code'] == 200;
  }

  static Future<bool> cancelPesanan(int id) async {
    String url = '${Api.baseUrl}/order/cancel/{$id}';
    Map? responseBody = await AppRequest.cancelMethod(url);
    if (responseBody == null) return false;
    if (responseBody['status_code'] == 200) {
      print(responseBody['status_code']);
      return true;
    }
    ;
    print(responseBody['status_code']);
    return responseBody['status_code'] == 200;
  }
}
