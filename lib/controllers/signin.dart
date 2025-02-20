import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../utils/appconstant.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signIn(String userEmail, String userPassword) async {
    try {
      EasyLoading.show(status: "انتظر قليلا...");

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // التحقق من تأكيد البريد الإلكتروني
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        EasyLoading.dismiss(); // ⬅️ تأكد من إيقاف التحميل هنا

        Get.snackbar(
          "خطأ",
          "تحقق من البريد الإلكتروني قبل تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor,
        );
        return null;
      }

      // ✅ إيقاف التحميل بعد نجاح تسجيل الدخول
      EasyLoading.dismiss();

      // هنا يمكنك توجيه المستخدم للصفحة التالية بعد تسجيل الدخول
      Get.offAll(() =>  Map());

      return userCredential;

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss(); // ⬅️ تأكد من إيقاف التحميل عند حدوث خطأ

      String errorMessage;
      if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This user has been disabled.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No user found for this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else {
        errorMessage = "An unexpected error occurred. Please try again.";
      }

      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
      );
    }
    return null;
  }
}
