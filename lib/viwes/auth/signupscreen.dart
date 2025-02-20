import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:wadiny/consts/colors.dart';
import 'package:wadiny/viwes/auth/signinscreen.dart';

import '../../consts/images.dart';
import '../../controllers/signup.dart';
import '../../utils/appconstant.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form.dart';
// تعريف واجهة تسجيل المستخدم كـ StatefulWidget للحفاظ على حالتها أثناء التفاعل
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// إنشاء الحالة (State) لواجهة تسجيل المستخدم
class _SignUpScreenState extends State<SignUpScreen> {
  // تعريف وحدة التحكم الخاصة بالتسجيل
  final SignUpController _signUpController = Get.put(SignUpController());
  // إنشاء حقول النص لإدخال البيانات مثل اسم المستخدم، البريد الإلكتروني، إلخ
  final TextEditingController username = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController userPhone = TextEditingController();
  final TextEditingController userCity = TextEditingController();

  // تدمير حقول النص عند الخروج من الشاشة لتحرير الذاكرة
  @override
  void dispose() {
    username.dispose();
    userEmail.dispose();
    userPassword.dispose();
    userPhone.dispose();
    userCity.dispose();
    super.dispose();
  }

  // بناء واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    // مراقبة ظهور لوحة المفاتيح باستخدام KeyboardVisibilityBuilder
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        // استخدام Scaffold لإنشاء واجهة الشاشة الكاملة
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            title: const Text(
              "إنشاء حساب",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
            ),
            centerTitle: true,
          ),
          // وضع محتوى الشاشة داخل ScrollView لتمكين التمرير عند ظهور لوحة المفاتيح
          body:SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(height: Get.height / 50),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "مرحبا بك!",
                      style: TextStyle(fontSize: 22, color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: Get.height / 50),

                  Image.asset(icSignUp,height: 200,fit: BoxFit.fill,color: AppConstant.appMainColor,),

                  SizedBox(height: Get.height / 50),
                  CustomTextFormField(controller:userEmail,type: TextInputType.emailAddress,title: 'البريد الإلكتروني', icon:Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل بريدك الإلكتروني';
                      }
                      if (!GetUtils.isEmail(value.trim())) {
                        return 'يجب أن يكون بريد إلكتروني';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: Get.height / 50),
                  CustomTextFormField(controller:username,type: TextInputType.name,title: 'الإسم', icon:Icons.person_3_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل اسم المستخدم';
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: Get.height / 50),
                  CustomTextFormField(controller:userPhone, title: 'الهاتف',type:TextInputType.number,icon:Icons.settings_cell_outlined ,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل رقم هاتفك';
                      }
                      if (!GetUtils.isPhoneNumber(value.trim())) {
                        return 'يجب أن يكون رقماً';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height / 50),
                  CustomTextFormField(controller: userCity, title: 'المدينة',type:TextInputType.emailAddress,icon:Icons.location_on_outlined ,
                    validator:(value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل اسم مدينتك';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height / 50),
                  Obx(() => CustomTextFormField(
                    controller: userPassword,
                    title: "كلمة السر",
                    type: TextInputType.visiblePassword,
                    icon: Icons.password_outlined,
                    obSecure: !_signUpController.isPasswordVisible.value, // تصحيح هنا
                    suffix: _signUpController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    press: () {
                      _signUpController.isPasswordVisible.toggle();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل كلمة السر';
                      }
                      if (value.trim().length < 6) {
                        return 'كلمة السر يجب أن تكون على الأقل 6 أحرف';
                      }
                      return null;
                    },
                  )),

                  SizedBox(height: Get.height / 25),
                  CustomButton(
                    text: "إنشاء حساب",
                    color: AppConstant.appMainColor,
                    textColor: AppConstant.appTextColor,
                    width: Get.width / 2,
                    height: Get.height / 18,
                    onPressed: () async {
                      String name = username.text.trim();
                      String email = userEmail.text.trim();
                      String phone = userPhone.text.trim();
                      String city = userCity.text.trim();
                      String password = userPassword.text.trim();

                      if (name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || password.isEmpty) {
                        Get.snackbar(
                          "خطأ",
                          "ادخل جميع الحقول",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appMainColor,
                          colorText: AppConstant.appTextColor,
                        );
                      } else {
                        UserCredential? userCredential = await _signUpController.signUp(
                          name,
                          email,
                          phone,
                          city,
                          password,
                        );

                        if (userCredential != null) {
                          Get.snackbar(
                            "التحقق",
                            "تحقق من بريد الإلكتروني",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appMainColor,
                            colorText: AppConstant.appTextColor,
                          );
                          FirebaseAuth.instance.signOut();
                          Get.offAll(() => const SignInScreen());
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => const SignInScreen());
                        },
                        child: const Text(
                          " سجل دخول",
                          style: TextStyle(fontSize: 16, color:AppConstant.appMainColor),
                        ),
                      ),

                      const Text(
                        " هل تملك حساب؟",
                        style: TextStyle(color:AppConstant.appTextColor, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height / 20),
                ],
              ),
            ),
          ),


        );
      },
    );
  }
}




