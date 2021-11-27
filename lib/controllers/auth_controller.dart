import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthController extends GetxController {
  final RoundedLoadingButtonController loginBtnController =
      RoundedLoadingButtonController();
  TextEditingController passwordTextController = TextEditingController();
  String? loginError;

  final box = GetStorage();

  @override
  void onClose() {
    passwordTextController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final storedPassword = box.read('password');

    try {
      if (passwordTextController.text == storedPassword) {
        loginBtnController.success();
        Get.offNamed('/map');
      } else {
        loginBtnController.stop();
        return Get.rawSnackbar(
          message: ' ',
          messageText: const Text('Wrong Password, Try Again',
              style: TextStyle(fontSize: 16)),
          overlayColor: const Color(0XFFFFFFFF),
          icon: const Icon(Icons.error, color: Colors.redAccent),
          shouldIconPulse: true,
          backgroundColor: const Color(0xFFFFFFFF),
          isDismissible: true,
          duration: const Duration(seconds: 5),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          borderRadius: 12,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (err) {
      print(err);
      loginBtnController.stop();
      return Get.rawSnackbar(
        message: ' ',
        messageText:
            const Text('An error occurred', style: TextStyle(fontSize: 16)),
        overlayColor: const Color(0XFFFFFFFF),
        icon: const Icon(Icons.error, color: Colors.redAccent),
        shouldIconPulse: true,
        backgroundColor: const Color(0xFFFFFFFF),
        isDismissible: true,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
