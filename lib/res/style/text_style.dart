import 'package:flutter/cupertino.dart';
import 'package:meet/res/color.dart';

class AppStyle {
  static AppStyle instance = AppStyle._init();

  AppStyle._init();

  final TextStyle h2Bold = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  final TextStyle h4Bold = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  final TextStyle h5Bold = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  final TextStyle h6Bold = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,

  );

  final TextStyle bodyXLarge = const TextStyle(
    color: AppColors.darkGreyColor,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  final TextStyle bodyMedium = const TextStyle(
    color: AppColors.darkGreyColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  final TextStyle smallWhiteText = const TextStyle(
    color: AppColors.whiteColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  final TextStyle errorMsg = const TextStyle(
    color: AppColors.redColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  final TextStyle textBold = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  final TextStyle grayTextBold = const TextStyle(
    color: AppColors.darkGreyColor,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  final TextStyle buttonStyle = const TextStyle(
    color: AppColors.whiteColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}