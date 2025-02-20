import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadiny/utils/appconstant.dart';
import 'package:wadiny/viwes/admin/main-screen.dart';
import 'package:wadiny/viwes/auth/signupscreen.dart';
import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../consts/strings.dart';
import '../../BottomNav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // انتظار 4 ثوانٍ ثم التحقق من حالة المستخدم
    Timer(const Duration(seconds: 2), () {
      checkUserStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(icSplash, width: 300,height: 300,fit: BoxFit.cover,),
                  const SizedBox(height: 20),
                  const Text(
                    appname,
                    style: TextStyle(color:AppConstant.appMainColor, fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Text(credits, style: TextStyle(color:Colors.black, fontSize: 16.0)),
                SizedBox(height: 10),
                Text(appversion, style: TextStyle(color:Colors.black, fontSize: 14.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // التحقق من حالة تسجيل الدخول للمستخدم
  Future<void> checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // جلب بيانات المستخدم من Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        bool role = userDoc['isAdmin'] ?? false; // التحقق من الدور، إذا لم يكن موجودًا افتراضيًا 'user'

        if (role == true) {
          Get.offAll(() =>  MainScreen()); // التوجيه لصفحة الأدمن
        } else {
          Get.offAll(() => CustomBottomNavigationBar()); // التوجيه للصفحة العادية
        }
      } else {
        Get.offAll(() => const SignUpScreen()); // إذا لم تكن بيانات المستخدم موجودة
      }
    } else {
      Get.offAll(() => const SignUpScreen()); // إذا لم يكن هناك مستخدم مسجل
    }
  }
}
