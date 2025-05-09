import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> pswdController = TextEditingController().obs;
  RxBool isVisible = false.obs;
  RxBool isAgree = false.obs;
}
