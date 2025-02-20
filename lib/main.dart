import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:wadiny/viwes/admin/main-screen.dart';
import 'package:wadiny/viwes/auth/splashscreen.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // تأكد من تهيئة Flutter قبل استدعاء Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection:TextDirection.rtl,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(), // تأكد من إضافته هنا
      title: 'Firebase App',
      // theme: ThemeData.dark()
      //     .copyWith(
      //
      // ),
      home:const SplashScreen(),
    );
  }
}

