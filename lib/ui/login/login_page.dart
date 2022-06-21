import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/ui/login/register_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  var _passwordVisible = false.obs;
  void changeVisibility() {
    _passwordVisible.value = !_passwordVisible.value;
    update();
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController passController = Get.put(LoginController());
  final LandingController landingController = Get.put(LandingController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.login_page)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: context.dynamicHeight(0.08)),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.app_name,
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 30.0),
                    ),
                    Text(
                      AppLocalizations.of(context)!.login_page,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 36.0),
                    ),
                    SizedBox(height: context.dynamicHeight(0.04)),
                    SizedBox(
                      width: context.dynamicWidth(0.6),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.mail,
                        ),
                      ),
                    ),
                    SizedBox(height: context.dynamicHeight(0.04)),
                    SizedBox(
                      width: context.dynamicWidth(0.6),
                      child: Obx(
                        () => TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: !passController._passwordVisible.value,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !passController._passwordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  debugPrint(
                                      "changevisib ${passController._passwordVisible}");
                                  passController.changeVisibility();
                                },
                              )),
                        ),
                      ),
                    ),
                    SizedBox(height: context.dynamicHeight(0.07)),
                    Align(
                      alignment: FractionalOffset.center,
                      child: PhysicalModel(
                        color: Colors.black12,
                        elevation: 8,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.login_page_btn,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          onPressed: () => {
                            landingController.loginIntoSystem(
                                emailController.text.toString(),
                                passwordController.text.toString())
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: context.dynamicHeight(0.15)),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => {Get.to(RegisterPage())},
                          child: Text(
                            AppLocalizations.of(context)!.click_to_sign,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0),
                          ),
                        ),
                        SizedBox(height: context.dynamicHeight(0.015)),
                        Text(
                          AppLocalizations.of(context)!.click_forgot_pass,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
