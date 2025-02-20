import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.blue, // افتراضيًا لون أزرق
          borderRadius: BorderRadius.circular(20.0),
        ),
        width: width ?? 150,  // افتراضيًا 150
        height: height ?? 50, // افتراضيًا 50
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white, // افتراضيًا أبيض
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }}
