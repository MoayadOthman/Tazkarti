import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:wadiny/consts/consts.dart';
import 'package:wadiny/viwes/auth/signupscreen.dart';
import '../../controllers/forgetpassword.dart';
import '../../utils/appconstant.dart';
import '../../widgets/custom_text_form.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController _forgetPasswordController = Get.put(ForgetPasswordController());
  final TextEditingController userEmail = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userEmail.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppConstant.appMainColor,
            title: const Text(
              "نسيت كلمة السر؟",
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
                  Image.asset(map,height: 300,fit: BoxFit.fill,color:AppConstant.appMainColor,),
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
                  SizedBox(height: Get.height / 25),
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
                          String email=userEmail.text.trim();
                          if(email.isEmpty){
                            Get.snackbar(
                              "خطأ",
                              "ادخل بريدك الإلكتروني لإعادة تعيين كلمة سر",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: AppConstant.appTextColor,
                            );
                          }else{
                            await _forgetPasswordController.forgetPassword(email);
                          }
                        },
                        child: const Text(
                          "إرسال",
                          style: TextStyle(
                            color: AppConstant.appTextColor,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                ],
              ),
            ),
          ),

        );
      },
    );
  }
}
