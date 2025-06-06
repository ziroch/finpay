// ignore_for_file: deprecated_member_use

import 'package:finpay/config/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardTextField extends StatelessWidget {
  final String? hintText;

  final double? radius;
  final Color? color;
  final TextEditingController? textEditingController;
  final bool isObsecure;
  final Widget? sufix;
  final TextInputType? inputType;
  const CardTextField({
    super.key,
    this.hintText,
    this.radius,
    this.color,
    this.textEditingController,
    this.isObsecure = false,
    this.sufix,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: Get.width,
      decoration: BoxDecoration(
          color: color!, borderRadius: BorderRadius.circular(radius!)),
      child: TextFormField(
        keyboardType: inputType,
        obscureText: isObsecure,
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 14, right: 14, top: 16),
          border: InputBorder.none,
          suffixIcon: sufix ?? const SizedBox(),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HexColor('#A2A0A8'),
              ),
        ),
      ),
    );
  }
}
