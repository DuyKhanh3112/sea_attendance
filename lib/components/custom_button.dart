// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sea_attendance/utils/color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onClicked,
    this.bgColor,
    this.textColor,
    this.padding,
    this.margin,
  });

  final String title;
  final Future<void> Function()? onClicked;
  final Color? bgColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin ?? EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(),
      child: ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColor.blue,
          foregroundColor: textColor ?? Colors.white,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 16, horizontal: 24),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5, // Đổ bóng cho nút
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
