
// Helper function to build text fields with validation
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget _buildTextFormField({required TextEditingController controller, required String hintText, String? Function(String?)? validator}) {
  return Container(
    height: 65,
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    child: TextFormField(
      controller: controller,
      validator: validator,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        hintText: hintText,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    ),
  );
}
