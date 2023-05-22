import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venturo_test/controller/c_pesanan.dart';
import 'package:venturo_test/model/pesanan_model.dart';

import '../config/app_format.dart';
import '../config/theme.dart';

class RiwayatPesananCard extends StatefulWidget {
  final PesananModel pesanan;
  const RiwayatPesananCard({super.key, required this.pesanan});

  @override
  State<RiwayatPesananCard> createState() => _RiwayatPesananState();
}

class _RiwayatPesananState extends State<RiwayatPesananCard> {
  final cPesanan = Get.put(CPesanan());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Container(
        width: 380.w,
        height: 125.h,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      widget.pesanan.item.gambar,
                      width: 75.w,
                      height: 80.h,
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 3.w,
                    ),
                    Text(
                      widget.pesanan.item.nama,
                      style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    Text(
                      AppFormat.formatRupiah(
                          widget.pesanan.item.harga.toString()),
                      style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          color: accentColor,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.pesanan.catatan.toString(),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  widget.pesanan.qty.toString(),
                  style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      color: accentColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 24.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
