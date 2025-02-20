

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../utils/appconstant.dart';
import '../viwes/auth/signinscreen.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> forgetPassword(String userEmail) async {
    try {
      EasyLoading.show(status: "انتظر قليلا");
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "إعادة تعيين كلمة سر",
        "تم إرسال رسالة الى $userEmail لإعادة تعيين كلمة سر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
      );
      Get.offAll(() => const SignInScreen());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "خطأ",
        "حدث خطأ,حاول مجددا",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
      );
    }
    return null;
  }
}
