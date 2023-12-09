

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet/screens/login/login_view.dart';
import 'package:meet/services/auth.dart';
import 'package:meet/utils/general_utils.dart';

class ProfileViewModel{

  static changePassword({required BuildContext context, required String newPass}) async {

    final user = await FirebaseAuth.instance.currentUser!;

    user.updatePassword(newPass).then((_){
      Utils.showAchBanner(context: context, isError: false, message: "تم تغيير كلمة المرور بنجاح");
    }).catchError((error){
      Utils.showAchBanner(context: context, isError: true, message: " لا يمكنك تغير كلمة المرور حصل خطا$error");
    });

  }

  static logout({required BuildContext context}) async {

    Utils.buildLoading(context);

    final bool isSignOut = await Auth.signOut();
    Navigator.pop(context);
    if(isSignOut){
      Utils.showAchBanner(context: context, message: "تمت عملية تسجيل الخروج بنجاح", isError: false);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    }else{
      Utils.showAchBanner(context: context, message: "لم تتم عملية تسجيل الخروج ", isError: true);

    }

  }


  static Future<void> updateUserInfo({
    required BuildContext context,
    required String newEmail,
    required String newPhone,
    required String newName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      // Update email in Firebase Authentication
      await user?.updateEmail(newEmail);

      // Update phone and username in Firestore
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);
      await userDocRef.update({
        'phoneNumber': newPhone,
        'username': newName,
        'email': newEmail
      });

      Utils.showAchBanner(context: context, isError: false, message: 'تم تحديث المعلومات بنجاح');


    } catch (error) {
      Utils.showAchBanner(context: context, isError: true, message: 'حدث خطأ أثناء تحديث المعلومات: $error');


    }
  }
}

