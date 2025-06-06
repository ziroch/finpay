// ignore_for_file: avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/controller/signup_controller.dart';
import 'package:finpay/view/country/country_residence_screen.dart';
import 'package:finpay/view/login/login_screen.dart';
import 'package:finpay/widgets/custom_button.dart';
import 'package:finpay/widgets/custom_textformfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../config/textstyle.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpController = Get.put(SignUpController());
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    signUpController.isVisible.value = false;
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: AppTheme.isLightTheme == false
                ? const Color(0xff15141F)
                : const Color(0xffFFFFFF),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: AppBar().preferredSize.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Getting Started",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Create an account to continue!",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xffA2A0A8),
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            //   const SizedBox(height: 20),
                            CustomTextFormField(
                              focusNode: _focusNodes[0],
                              prefix: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: SvgPicture.asset(
                                  DefaultImages.userName,
                                  color: _focusNodes[0].hasFocus
                                      ? HexColor(AppTheme.primaryColorString!)
                                      : const Color(0xffA2A0A8),
                                  // color:  HexColor(AppTheme.secondaryColorString!)
                                ),
                              ),
                              hintText: "Full Name",
                              inputType: TextInputType.text,
                              textEditingController:
                                  signUpController.nameController.value,
                              capitalization: TextCapitalization.words,
                              limit: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z ]'))
                              ],
                            ),
                            const SizedBox(height: 24),
                            CustomTextFormField(
                              focusNode: _focusNodes[1],
                              prefix: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: SvgPicture.asset(
                                  DefaultImages.phone,
                                  color: _focusNodes[1].hasFocus
                                      ? HexColor(AppTheme.primaryColorString!)
                                      : const Color(0xffA2A0A8),
                                  // color:  HexColor(AppTheme.secondaryColorString!)
                                ),
                              ),
                              hintText: "Phone Number",
                              inputType: TextInputType.phone,
                              textEditingController:
                                  signUpController.mobileController.value,
                              capitalization: TextCapitalization.none,
                              limit: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            const SizedBox(height: 24),
                            Obx(() {
                              return CustomTextFormField(
                                focusNode: _focusNodes[2],
                                sufix: InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    signUpController.isVisible.value =
                                        !signUpController.isVisible.value;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: SvgPicture.asset(
                                      DefaultImages.eye,
                                      // color:  HexColor(AppTheme.secondaryColorString!)
                                    ),
                                  ),
                                ),
                                prefix: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SvgPicture.asset(
                                    DefaultImages.pswd,
                                    color: _focusNodes[2].hasFocus
                                        ? HexColor(AppTheme.primaryColorString!)
                                        : const Color(0xffA2A0A8),
                                    // color:  HexColor(AppTheme.secondaryColorString!)
                                  ),
                                ),
                                hintText: "Password",
                                obscure:
                                    signUpController.isVisible.value == true
                                        ? false
                                        : true,
                                textEditingController:
                                    signUpController.pswdController.value,
                                capitalization: TextCapitalization.none,
                                limit: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                ],
                                inputType: TextInputType.visiblePassword,
                              );
                            }),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      signUpController.isAgree.value =
                                          !signUpController.isAgree.value;
                                    });
                                  },
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffDCDBE0)),
                                        color: signUpController.isAgree.value
                                            ? HexColor(
                                                AppTheme.primaryColorString!)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(
                                      Icons.check,
                                      size: 15,
                                      color: signUpController.isAgree.value
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "By creating an account, you aggree to our ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color:
                                                AppTheme.isLightTheme == false
                                                    ? const Color(0xffA2A0A8)
                                                    : const Color(0xff211F32),
                                          ),
                                    ),
                                    TextSpan(
                                        text: "Terms",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: HexColor(AppTheme
                                                    .primaryColorString!))),
                                    TextSpan(
                                      text: " and ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color:
                                                AppTheme.isLightTheme == false
                                                    ? const Color(0xffA2A0A8)
                                                    : const Color(0xff211F32),
                                          ),
                                    ),
                                    TextSpan(
                                        text: "Conditions",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: HexColor(AppTheme
                                                    .primaryColorString!))),
                                  ]),
                                )
                                    // Text(
                                    //   "By creating an account, you aggree to our Terms and Conditions",
                                    //   maxLines: 3,
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .bodyMedium!
                                    //       .copyWith(
                                    //         fontWeight: FontWeight.w500,
                                    //         fontSize: 14,
                                    //         color: Color(0xff211F32),
                                    //       ),
                                    // ),
                                    )
                              ],
                            ),
                            const SizedBox(height: 32),
                            InkWell(
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Get.to(
                                  const CountryResidenceScreen(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              child: customButton(
                                  HexColor(AppTheme.primaryColorString!),
                                  "Sign Up",
                                  HexColor(AppTheme.secondaryColorString!),
                                  context),
                            ),
                            InkWell(
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Get.to(
                                  const LoginScreen(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already have an account? ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color:
                                                    const Color(0xff9CA3AF))),
                                    Text(" Login",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: HexColor(
                                                  AppTheme.primaryColorString!),
                                            ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xffE8E8E8),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16),
                              child: Text("Or Continue with"),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xffE8E8E8),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 56,
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.circular(16),
                            color: HexColor(AppTheme.secondaryColorString!),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 17.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                    DefaultImages.ggl,
                                    //color:  HexColor(AppTheme.secondaryColorString!)
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {},
                                  child: Text(
                                    "Continue with Google",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: const Color(0xff15141F),
                                        ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
