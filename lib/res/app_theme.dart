import 'package:flutter/material.dart';
import 'package:meet/res/style/text_style.dart';

import 'color.dart';

class AppTheme {
  ThemeData appTheme() {
    return ThemeData(
      primaryColor: AppColors.blueColor,
      scaffoldBackgroundColor: AppColors.whiteColor,
      fontFamily: "Careem",
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: AppColors.blueColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: const Size(double.infinity, 55),
            textStyle: AppStyle.instance.buttonStyle),
      ),
      checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), fillColor: MaterialStateProperty.all(AppColors.redColor)),
      //inputDecoration Theme
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.whiteColor.withOpacity(0.1),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: AppColors.blueColor)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          hoverColor: AppColors.blueColor,
          contentPadding: const EdgeInsets.all(15),
          prefixIconColor: AppColors.blueColor.withOpacity(0.4),
          suffixIconColor: AppColors.blueColor.withOpacity(0.4),
          hintStyle: AppStyle.instance.bodyMedium.copyWith(color: AppColors.darkGreyColor.withOpacity(0.4))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.blueColor,
        unselectedItemColor: AppColors.greyColor,
        backgroundColor: Colors.white,
        elevation: 1,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
