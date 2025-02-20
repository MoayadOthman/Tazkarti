// استيراد FirebaseAuth للتحقق من المستخدم وتسجيل الدخول
import 'package:firebase_auth/firebase_auth.dart';
// استيراد مكتبة Flutter الأساسية
import 'package:flutter/material.dart';
// استيراد مكتبة KeyboardVisibility لتحديد ما إذا كان لوحة المفاتيح مرئية
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// استيراد مكتبة GetX للتحكم في الحالة والتوجيهات
import 'package:get/get.dart';
// استيراد شاشة إعادة تعيين كلمة المرور
import 'package:wadiny/viwes/auth/signupscreen.dart';
import 'package:wadiny/viwes/map_page.dart';

// استيراد وحدات التحكم اللازمة
import '../../consts/images.dart';
import '../../controllers/getuserdata.dart';
import '../../controllers/signin.dart';
// استيراد الثوابت المستخدمة في التطبيق
import '../../BottomNav.dart';
import '../../utils/appconstant.dart';
// استيراد الشاشة الرئيسية للمدير
import '../../widgets/custom_text_form.dart';
import 'forgerpasswordscreen.dart';

// تعريف واجهة شاشة تسجيل الدخول كـ StatefulWidget للحفاظ على حالتها أثناء الاستخدام
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

// إنشاء الحالة (State) لشاشة تسجيل الدخول
class _SignInScreenState extends State<SignInScreen> {
  // إنشاء كائنات وحدات التحكم وتخزين بياناتها باستخدام Get.put
  final SignInController _signInController = Get.put(SignInController());
  final GetUserDataController _getUserDataController = Get.put(GetUserDataController());

  // متغيرات لتخزين البريد الإلكتروني وكلمة المرور
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();

  // مفتاح للتحقق من صحة نموذج الإدخال
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // تنظيف حقول الإدخال عند إلغاء شاشة تسجيل الدخول
  @override
  void dispose() {
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            iconTheme: const IconThemeData(color: Colors.white),// لون الخلفية من الثوابت
            title: const Text(
              "تسجيل دخول",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body:
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // عرض الرسالة العلوية عند إخفاء لوحة المفاتيح
                  isKeyboardVisible
                      ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "مرحبا بك!",
                      style: TextStyle(
                        fontSize: 22,
                        color: AppConstant.appTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      :
                  Image.asset(map,height: 200,fit: BoxFit.fill,color:AppConstant.appMainColor,),
                  SizedBox(height: Get.height / 50),
                  // حقل إدخال البريد الإلكتروني
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
                  // حقل إدخال كلمة المرور مع خيار إظهار/إخفاء

                  Obx(() => CustomTextFormField(
                    controller: userPassword,
                    title: "كلمة السر",
                    type: TextInputType.visiblePassword,
                    icon: Icons.password_outlined,
                    obSecure: !_signInController.isPasswordVisible.value, // تصحيح هنا
                    suffix: _signInController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    press: () {
                      _signInController.isPasswordVisible.toggle();
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
                  // رابط لإعادة تعيين كلمة المرور
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const ForgetPasswordScreen());
                      },
                      child: const Text(
                        "هل نسيت كلمة السر؟",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppConstant.appMainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height / 25),
                  // زر تسجيل الدخول
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstant.appMainColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: Get.width / 2,
                      height: Get.height / 18,
                      child: TextButton(
                        onPressed: () async {
                          // استخلاص قيمة البريد الإلكتروني المدخلة في الحقل وتقطيع أي مسافات فارغة حولها
                          String email = userEmail.text.trim();
                          // استخلاص كلمة المرور المدخلة وتقطيع أي مسافات إضافية
                          String password = userPassword.text.trim();
                          if(email.isEmpty||password.isEmpty){
                            Get.snackbar(
                              "خطأ",
                              "ادخل جميع الحقول",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: AppConstant.appTextColor,
                            );
                          }else{

                            // محاولة تسجيل الدخول باستخدام البيانات المقدمة (البريد الإلكتروني وكلمة المرور)

                            UserCredential? userCredential = await _signInController.signIn(email, password);

                            //تمرير بعد تسجيل الدخول uid

                            var userData = await _getUserDataController.getUserData(userCredential!.user!.uid);

                            if (userCredential != null) {
                              // التحقق مما إذا كان البريد الإلكتروني للمستخدم قد تم التحقق منه
                              if (userCredential.user!.emailVerified) {

                                // التحقق مما إذا كان المستخدم مسجلاً كمسؤول (Admin)
                                if (userData[0]['isAdmin'] == true) {
                                  // عرض رسالة نجاح للمسؤول
                                  Get.snackbar(
                                    "تسجيل دخول المسؤول",
                                    "!تم تسجيل الدخول بنجاح",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppConstant.appMainColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                  // التوجيه إلى الشاشة الرئيسية للمسؤول (AdminMainScreen)
                                  Get.offAll(() =>  CustomBottomNavigationBar());
                                }
                                else {
                                  // عرض رسالة نجاح إذا كان المستخدم ليس مسؤولاً
                                  Get.snackbar(
                                    "تسجيل دخول المستخدم",
                                    "!تم تسجيل الدخول بنجاح",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppConstant.appMainColor,
                                    colorText: AppConstant.appTextColor,
                                  );

                                  // التوجيه إلى واجهة المستخدم العادية (BottomNav)
                                  // Get.offAll(() => MapScreen());
                                }
                              } else {
                                // إذا لم يتم التحقق من البريد الإلكتروني، يعرض رسالة خطأ
                                Get.snackbar(
                                  "خطأ",
                                  "تحقق من بريدك الإلكتروني قبل تسجيل الدخول",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appMainColor,
                                  colorText: AppConstant.appTextColor,
                                );
                              }
                            }

                          }
                        },
                        child: const Text(
                          "تسجيل دخول",
                          style: TextStyle(
                            color: AppConstant.appTextColor,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                  // رابط لإنشاء حساب جديد
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => const SignUpScreen());
                        },
                        child: const Text(
                          " إنشاء حساب",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppConstant.appMainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Text(
                        "  ليس لديك حساب؟",
                        style: TextStyle(color: AppConstant.appTextColor, fontSize: 16),
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

