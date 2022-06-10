import 'dart:math';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/ui/hits/hits_page.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/dialog.dart';

class LoginController extends GetxController {
  var _passwordVisible = false.obs;
  void changeVisibility() {
    _passwordVisible.value = !_passwordVisible.value;
    update();
  }

  void loginIntoSystem(String mail, String pass) async {
    var generatedPass = generateMd5(pass);
    debugPrint(mail);
    debugPrint(generatedPass);
    try {
      var sources = await HttpServices.getLoginStatusBase(mail, generatedPass);
      if (sources != null) {
        debugPrint("kerimDebug2 ${sources.username}");
        Get.to(HitsPage());
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }
}

class LoginPage extends StatelessWidget {
  final Controller controller = Get.find();
  final LoginController passController = Get.put(LoginController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.login_page)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.dynamicWidth(0.6),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: AppLocalizations.of(context)!.mail,
                    ),
                  ),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                Container(
                  width: context.dynamicWidth(0.6),
                  child: Obx(
                    () => TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: !passController._passwordVisible.value,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
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
                SizedBox(height: context.dynamicHeight(0.02)),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.login_page_btn,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  onPressed: () => {
                    passController.loginIntoSystem(
                        emailController.text.toString(),
                        passwordController.text.toString())
                  },
                )
              ],
            ),
          ),
        ));
  }
}
