import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/profile/profile_edit.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:qrmeet/utils/helper.dart';
import '../landing/landing_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends StatelessWidget {
  final LandingController landingController = Get.find();
  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(),
          title: Text(AppLocalizations.of(context)!.profile)),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: context.dynamicWidth(0.11),
                        width: context.dynamicWidth(0.11),
                        child: Stack(
                          children: [
                            CircleAvatar(
                                backgroundImage: NetworkImage(
                                    landingController.mainUser.userPic!),
                                backgroundColor:
                                    const Color.fromRGBO(0, 0, 0, 0)),
                            const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(Icons.edit)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              landingController.mainUser.username!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: context.dynamicWidth(0.05),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              landingController.mainUser.mail!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: context.dynamicWidth(0.03),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          customListButton(data: AppLocalizations.of(context)!.update_info,fSize: context.dynamicWidth(0.05),onClickAction: GetProfileEdit),
          customListButton(data: AppLocalizations.of(context)!.share_profile,fSize: context.dynamicWidth(0.05),onClickAction: ShareProfile),
        ],
      ),
    );
  }
}
void GetProfileEdit(){
  debugPrint("Getprofileedit girdi");
  Get.to(()=> ProfileEdit());
}
void ShareProfile(){
  // share code
}