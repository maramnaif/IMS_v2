import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meet/res/app_theme.dart';
import 'package:meet/screens/login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
  // runApp(
  //     DevicePreview(
  //     enabled: true,
  //     builder: (context) => const ProviderScope(child: MyApp()), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key ? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme().appTheme(),

          builder: (BuildContext context, Widget? child) {
            // Set RTL text direction
            return Directionality(
              textDirection: TextDirection.rtl, //To change the rendering direction from right to left
              child: child!,
            );
          },
          home: LoginScreen()
        );
      },
    );
  }
}
