import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController extends GetxController {
  var _passwordVisible = false.obs;
  var _rePasswordVisible = false.obs;

  void changeVisibility() {
    _passwordVisible.value = !_passwordVisible.value;
    update();
  }

  void changeRePasswordVisibility() {
    _rePasswordVisible.value = !_rePasswordVisible.value;
    update();
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final RegisterController passController = Get.put(RegisterController());
  final LandingController landingController = Get.find();
  final TextEditingController emailController = TextEditingController(),passwordController = TextEditingController(),rePassController = TextEditingController();
  @override
  Widget build(context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context)!.register_page)),
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
                      AppLocalizations.of(context)!.register_page,
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
                    SizedBox(height: context.dynamicHeight(0.04)),
                    SizedBox(
                      width: context.dynamicWidth(0.6),
                      child: Obx(
                        () => TextFormField(
                          controller: rePassController,
                          keyboardType: TextInputType.text,
                          obscureText: !passController._rePasswordVisible.value,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.re_password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !passController._rePasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  debugPrint(
                                      "changevisib ${passController._rePasswordVisible}");
                                  passController.changeRePasswordVisibility();
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
                              AppLocalizations.of(context)!.register_page,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          onPressed: () => {
                            landingController.registerIntoSystem(
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
                          onTap: () => {Get.to(()=>RegisterPage())},
                          child: Text(
                            AppLocalizations.of(context)!.click_to_login,
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
