import 'package:flutter/material.dart';

import '../consts/colors.dart';
import '../utils/appconstant.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key, required this.controller, required this.title, required this.icon, this.type, this.validator, this.suffix, this.obSecure=false, this.press,
  });

  final TextEditingController controller;
  final String title;
  final IconData icon;
  final IconData? suffix;
  final bool obSecure;
  final VoidCallback? press;
  final TextInputType? type;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
          obscureText:obSecure,
          controller:controller,
          cursorColor: AppConstant.appMainColor,
          keyboardType:type,
          decoration: InputDecoration(
            suffixIcon:IconButton( onPressed:press , icon: Icon(suffix),),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.all(Radius.circular(30),

              ),
            ),
            focusedBorder:const OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.all(
                    Radius.circular(30)
                )
            ) ,
            errorBorder:const OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.all(
                    Radius.circular(30))
            ),

            hintText:title,
            prefixIcon:  Icon(icon),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
            ),
          ),
          // التحقق من صحة حقل المدينة
          validator:validator
      ),
    );
  }
}
