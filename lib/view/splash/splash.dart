// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:async';
import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/view/login/login_screen.dart';
import 'package:finpay/view/splash/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => const LoginScreen());
    });
    final db = LocalDBService();

    await db.getAll("clientes.json", forceUpdate: true);
    await db.getAll("autos.json", forceUpdate: true);
    await db.getAll("pisos.json", forceUpdate: true);
    await db.getAll("lugares.json", forceUpdate: true);
    await db.getAll("reservas.json", forceUpdate: true);
    await db.getAll("pagos.json", forceUpdate: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            color: AppTheme.isLightTheme == false
                ? HexColor('#15141F')
                : HexColor(AppTheme.primaryColorString!)),
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset(DefaultImages.logo,
                      color: HexColor(AppTheme.secondaryColorString!)),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  width: 130,
                  child: SvgPicture.asset(DefaultImages.text,
                      color: HexColor(AppTheme.secondaryColorString!)),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 48, right: 48, bottom: 20),
              child: Text(
                "FinPay is a financial platform to manage your business and money.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: const Color(0xffDCDBE0),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
