import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/views/components/components.dart';
import 'package:test_app/helpers/helpers.dart';
import 'package:test_app/controllers/controllers.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validator = Validator();
  final authController = Get.put<AuthController>(AuthController());

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0XFFFFFFFF),
      ),
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 50.0),
                          Container(
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FormInputField(
                                controller:
                                    authController.passwordTextController,
                                hintText: 'password',
                                onChanged: (value) => null,
                                textInputAction: TextInputAction.done,
                                validator: validator.password,
                                onSaved: (value) {
                                  authController.passwordTextController.text =
                                      value ?? "";
                                },
                                // errorText: authController.loginError,
                                maxLines: 1,
                                fontSize: 18.0,
                                maxLength: 50,
                                borderRadius: 8,
                                fillColor: Colors.grey.withOpacity(0.1),
                                focusColor: const Color(0XFFFFFFFF),
                                keyboardType: TextInputType.name,
                                obscureText: true),
                          ),
                          const SizedBox(height: 130),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: RoundedLoadingButton(
                        child: const Center(
                            child: Text('LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18))),
                        controller: authController.loginBtnController,
                        borderRadius: 8,
                        successColor: Theme.of(context).colorScheme.primary,
                        loaderSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await authController.login();
                          } else {
                            authController.loginBtnController.stop();
                          }
                        },
                        width: Get.width,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
