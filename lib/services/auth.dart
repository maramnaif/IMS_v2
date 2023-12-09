

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/general_provider/firebase_providers.dart';
import 'package:meet/models/user_model.dart';
import 'package:meet/screens/login/login_view_model.dart';
import 'package:meet/services/database.dart';

class Auth {

  static Future signUp(WidgetRef ref,UserModel user, String password) async {
    final auth = ref.read(firebaseAuthProvider);
    try{
      final newUser = await auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      print("after create");
      await Database.insertUserRow(user, newUser.user!.uid);
      return newUser;
    }catch(e){
      print("catch create");
      return null;
    }
  }

  static Future<UserCredential?> signIn(WidgetRef ref, String email, String password) async {
    final auth = ref.read(firebaseAuthProvider);
    try {
      Logger().w(email + " " + password);
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firebase and convert it to your UserModel
      final user = await Database.fetchCurrentUser(ref, userCredential.user!.uid); // Implement this method to fetch user data

      // Store user data in the userDataProvider
      ref.read(userDataProvider.notifier).state = user;

      print("Sign-in successful");
      return userCredential;
    } catch (e) {
      print("Sign-in error: $e");
      return null;
    }
  }

  static Future<bool> resetPassword(String email, WidgetRef ref) async {
    final auth = ref.read(firebaseAuthProvider);

    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> signOut() async {

    try{
      await FirebaseAuth.instance.signOut();
      return true;
    }catch(e){
      Logger().w(e.toString());
      return false;
    }
  }
}


