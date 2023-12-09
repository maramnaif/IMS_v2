import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meet/models/user_model.dart';
import 'package:meet/res/style/text_style.dart';
import 'package:meet/screens/home/home_view.dart';
import 'package:meet/services/auth.dart';
import 'package:meet/utils/general_utils.dart';
import 'package:meet/utils/sizes_helpers.dart';
import 'package:meet/widget/MainButtonWidget.dart';
import 'package:meet/widget/custom_text_input_field.dart';
import 'package:riverpod/riverpod.dart';

import '../../widget/resend_pass.dart';

final userDataProvider = StateProvider<UserModel?>((ref) => null);

class LoginViewModel {
  static Future<void> signIn({required WidgetRef ref, required BuildContext context, required String email, required String password}) async {
    try {
      final newUser = await Auth.signIn(ref, email, password);
      if (newUser == null) {
        // Utils.toastMessage("cannot sign up", AppColors.redColor);
        Utils.showAchBanner(context: context, isError: true, message: "البريد الالكتروني او كلمة المرور غير صحيحة");
      } else {
        // Utils.toastMessage("sign up successfully", AppColors.greenColor);
        Utils.showAchBanner(context: context, isError: false, message: "تم تسجيل الدخول بنجاح");

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomeView();
        }));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> forgetPassword(String email, BuildContext context, WidgetRef ref) async {
    try {
      final res = await Auth.resetPassword(email, ref);
      if (res) {
        Utils.showAchBanner(context: context, message: "تم ارسال اعادة كلمة المرور عبر البريد الالكتروني", isError: false);
      } else {
        Utils.showAchBanner(context: context, message: "حصل خطا ", isError: true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  static void showResendPassBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ResendPasswordBottomSheet();
      },
    );
  }


}
