// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venturo_test/config/app_format.dart';
import 'package:venturo_test/config/theme.dart';
import 'package:venturo_test/controller/c_pesanan.dart';
import 'package:venturo_test/model/item_model.dart';
import 'package:venturo_test/model/send_data.dart';
import 'package:venturo_test/pages/riwayat_pesanan_page.dart';
import 'package:venturo_test/widget/item_card.dart';

class Pesanan extends StatefulWidget {
  const Pesanan({super.key});

  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  final cPesanan = Get.put(CPesanan());

  TextEditingController voucherController = TextEditingController();

  refresh() {
    cPesanan.resetAll();
    cPesanan.getListItem();
  }

  getVoucher() async {
    await cPesanan.getVoucher(voucherController.text);
    if (cPesanan.voucherSuccess) {
      cPesanan.updateVoucher(cPesanan.voucher.nominal!);
    } else {
      DInfo.dialogError(context, "Tidak memenuhi syarat");
      DInfo.closeDialog(context);
    }
  }

  postDataPesanan() async {
    List<Item> itemList = [];
    for (var i = 0; i < cPesanan.pesanan.length; i++) {
      var pesanan = cPesanan.pesanan[i];

      itemList.add(Item(
          id: pesanan.item.id,
          harga: pesanan.item.harga,
          catatan: pesanan.catatan ?? "Tanpa catatan"));
    }

    var data = DataModel(
            nominalDiskon: cPesanan.voucher.nominal.toString(),
            nominalPesanan: cPesanan.payTotal.toString(),
            items: itemList)
        .toJson();
    print(jsonEncode(data));

    await cPesanan.postPesanan(jsonEncode(data));
    if (cPesanan.isPesananPostSuccess) {
      DInfo.dialogSuccess(context, 'Berhasil upload');
      DInfo.closeDialog(context, actionAfterClose: () {
        Get.to(() => const RiwayatPesananPage());
      });
    } else {
      Get.snackbar(
        'Gagal',
        'Upload gagal',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void initState() {
    refresh();
    cPesanan.getListItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          bottom: false,
          child: GetBuilder<CPesanan>(builder: (_) {
            if (_.loading) return DView.loadingCircle();
            if (_.listItem.isEmpty) return DView.empty('Item Kosong');
            return Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async => refresh(),
                      child: ListView.builder(
                        itemCount: _.listItem.length,
                        itemBuilder: (context, index) {
                          ItemModel item = _.listItem[index];
                          return ItemCard(
                            item: item,
                          );
                        },
                      ),
                    )),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Pesanan',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '(${_.totalPesanan} Menu) :',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            Text(
                              AppFormat.formatRupiah(_.priceTotal.toString()),
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          showVoucher();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 18.w,
                          ),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 36.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.asset("assets/voucher.png"),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Text("Voucher",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _.voucherSuccess
                                        ? Column(
                                            children: [
                                              Text("${_.voucher.kode}",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              Text(
                                                  AppFormat.formatRupiah(_
                                                      .voucher.nominal
                                                      .toString()),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12.sp,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ],
                                          )
                                        : Text("Input Voucher",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            )),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        width: 428.w,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.w),
                                topRight: Radius.circular(30.w)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 12.0)
                            ]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Row(children: [
                            Image.asset("assets/keranjang.png"),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  Text(
                                    "Total Pembayaran",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    AppFormat.formatRupiah(
                                        _.payTotal.toString()),
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20.sp,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                postDataPesanan();
                              },
                              child: Container(
                                width: 200.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    'Pesan Sekarang',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          })),
    );
  }

  @override
  void dispose() {
    cPesanan.resetPesanan();
    voucherController.dispose();
    super.dispose();
  }

  void showVoucher() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: GetBuilder<CPesanan>(builder: (_) {
              return Container(
                height: 260.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.w),
                        topRight: Radius.circular(40.w))),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Image.asset("assets/voucher.png"),
                          SizedBox(
                            width: 11.w,
                          ),
                          Text(
                            "Punya kode Voucher?",
                            style: GoogleFonts.montserrat(
                                fontSize: 23.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      Text(
                        "Masukkan kode voucher disini",
                        style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: voucherController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          getVoucher();
                          navigator?.pop(context);
                          if (_.voucher.id != null) {
                            _.resetPayTotal(_.voucher.nominal!);
                          }
                          _.resetVoucher();
                        },
                        child: Container(
                          width: 375.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              'Validasi Voucher',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
