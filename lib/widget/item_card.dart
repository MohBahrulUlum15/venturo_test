import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venturo_test/config/app_format.dart';
import 'package:venturo_test/config/theme.dart';
import 'package:venturo_test/model/item_model.dart';

import '../controller/c_pesanan.dart';

class ItemCard extends StatefulWidget {
  final ItemModel item;
  const ItemCard({super.key, required this.item});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final cPesanan = Get.put(CPesanan());
  final TextEditingController controller = TextEditingController();

  int id = 0;
  int qty = 0;

  bool isCLicked = true;

  addTotalPrice(int price) async {
    await cPesanan.addTotalPrice(price);
  }

  lessTotalPrice(int price) async {
    await cPesanan.lessTotalPrice(price);
  }

  addTotalMenuItems(int item) async {
    await cPesanan.addTotalPesanan(item);
  }

  lessTotalMenuItems(int item) async {
    await cPesanan.lessTotalPesanan(item);
  }

  setPesanan(ItemModel item, String catatan, int qty) async{
    await cPesanan.setPesanan(catatan, item, qty);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Container(
        width:380.w,
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
                      widget.item.gambar,
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
                      widget.item.nama,
                      style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    Text(
                      AppFormat.formatRupiah(widget.item.harga.toString()),
                      style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          color: accentColor,
                          fontWeight: FontWeight.w700),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 12.sp),
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tambahkan catatan",
                        hintStyle: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      int voucher = 0;
                      if(cPesanan.voucher.nominal != null){
                        voucher = cPesanan.voucher.nominal!;
                      }
                      if (qty > 0 && cPesanan.payTotal > voucher) {
                        setState(() {
                          qty--;
                          lessTotalPrice(widget.item.harga);
                          lessTotalMenuItems(1);
                          setPesanan(widget.item, controller.text, qty);
                          print('$qty item');
                        });
                      }
                    },
                    child: Image.asset("assets/minus.png")),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  "$qty",
                  style: GoogleFonts.montserrat(
                      fontSize: 8.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 4.w,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        qty++;
                        id = cPesanan.id;
                        addTotalPrice(widget.item.harga);
                        addTotalMenuItems(1);
                        if(isCLicked){
                          isCLicked = false;
                          id++;
                        }
                        cPesanan.setId(id);
                        print(id);
                        setPesanan(widget.item, controller.text, qty);
                        print('$qty item');
                      });
                    },
                    child: Image.asset("assets/plus.png")),
              ],
            ),
            SizedBox(
              width: 8.w,
            )
          ],
        ),
      ),
    );
  }
}
