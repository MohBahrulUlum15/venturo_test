// ignore_for_file: use_build_context_synchronously

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venturo_test/config/theme.dart';
import 'package:venturo_test/model/pesanan_model.dart';
import 'package:venturo_test/widget/riwayat_pesanan_card.dart';

import '../config/app_format.dart';
import '../controller/c_pesanan.dart';

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  final cItemsPesanan = Get.put(CPesanan());

  TextEditingController voucherController = TextEditingController();

  getVoucher() async {
    await cItemsPesanan.getVoucher(voucherController.text);
    if (cItemsPesanan.voucherSuccess) {
      cItemsPesanan.updateVoucher(cItemsPesanan.voucher.nominal!);
    } else {
      DInfo.dialogError(context, "Tidak memenuhi syarat");
      DInfo.closeDialog(context);
    }
  }

  cancelPesanan() async {
    print(cItemsPesanan.idPesanan);
    await cItemsPesanan.cancelPesanan(cItemsPesanan.idPesanan);
    if (cItemsPesanan.isPesananCancelSuccess) {
      DInfo.dialogSuccess(context, 'Pesanan berhasil dibatalkan');
      DInfo.closeDialog(context, actionAfterClose: () {
        cItemsPesanan.resetAll();
        Get.back();
      });
    } else {
      Get.snackbar('Gagal', 'Pembatalan pesanan gagal!',
          backgroundColor: Colors.red, colorText: whiteColor);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          bottom: false,
          child: GetBuilder<CPesanan>(builder: (_) {
            if (_.loading) return DView.loadingCircle();
            if (_.pesanan.isEmpty) return DView.empty('Kosong');
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemCount: _.pesanan.length,
                      itemBuilder: (context, index) {
                        PesananModel pesanan = _.pesanan[index];
                        return RiwayatPesananCard(pesanan: pesanan);
                      },
                    )),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 36.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "Total Pesanan ",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text("4 (Menu)",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                              Text(
                                AppFormat.formatRupiah(_.priceTotal.toString()),
                                style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
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
                                cancelPesanan();
                              },
                              child: Container(
                                width: 200.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    'Batalkan',
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
    cItemsPesanan.resetPesanan();
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
                          width: 377.w,
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
