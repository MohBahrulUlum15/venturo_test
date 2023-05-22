import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_test/pages/pesanan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        428,
        926,
      ),
      builder: (_, child) {
        return GetMaterialApp(
          title: "Venturo Test",
          debugShowCheckedModeBanner: false,
          home: child,
          theme: ThemeData.light(),
        );
      },
      child: const Pesanan(),
    );
  }
}
