
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meet/models/user_model.dart';
import 'package:meet/screens/login/login_view.dart';
import 'package:meet/services/auth.dart';
import 'package:meet/utils/general_utils.dart';

class SignUpViewModel {

  //this method works only if the user click on signup button
  static Future<void> signup({required WidgetRef ref,required BuildContext context, required UserModel user, required String password}) async {
    try {

      final newUser = await Auth.signUp(ref, user, password);
      if(newUser == null){
        // Utils.toastMessage("cannot sign up", AppColors.redColor);
        Utils.showAchBanner(context: context, isError: true, message: "لديك حساب بالفعل");
      }else{
        // Utils.toastMessage("sign up successfully", AppColors.greenColor);
        Utils.showAchBanner(context: context, isError: false, message: "تم التسجبل بنجاح");

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return LoginScreen();
        }));
      }
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

}