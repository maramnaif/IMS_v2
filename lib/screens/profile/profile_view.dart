import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meet/res/color.dart';
import 'package:meet/res/style/text_style.dart';
import 'package:meet/screens/login/login_view_model.dart';
import 'package:meet/screens/profile/profile_view_model.dart';
import 'package:meet/utils/general_utils.dart';
import 'package:meet/utils/sizes_helpers.dart';
import 'package:meet/widget/MainButtonWidget.dart';
import 'package:meet/widget/custom_text_input_field.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileData = ref.read(userDataProvider);
    final nameController = useTextEditingController(text: userProfileData!.username);
    final emailController = useTextEditingController(text: userProfileData.email);
    final phoneController = useTextEditingController(text: userProfileData.phoneNumber);
    final resetController = useTextEditingController();
    final confirmController = useTextEditingController();
    final isLoadingButton = useState(false);
    final isSaveTheChanges = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    void showBottomSheet(BuildContext context) {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: displayHeight(context) * 0.60,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 2.5,
                        width: 100,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'تغيير كلمة المرور',
                                style: AppStyle.instance.h4Bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            CustomTextInputField(
                              controller: resetController,
                              labelText: 'كلمة المرور الجديدة',
                              suffixIcon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                //to validate user input
                                if (value == null || value.trim().isEmpty) {
                                  //check if it's empty
                                  return 'الرجاء ادخال كلمة المرور';
                                }
                                if (value.trim().length < 8) {
                                  //if password less than 8 characters
                                  return 'كلمة المرور قصيرة جدا';
                                }
                                // Return null if the entered password is valid
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextInputField(
                              controller: confirmController,
                              labelText: 'كلمة المرور الجديدة',
                              suffixIcon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                //to validate user input
                                if (value == null || value.trim().isEmpty) {
                                  //check if it's empty
                                  return 'الرجاء ادخال كلمة المرور';
                                }
                                if (value.trim().length < 8) {
                                  //if password less than 8 characters
                                  return 'كلمة المرور قصيرة جدا';
                                }
                                // Return null if the entered password is valid
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            MainButtonWidget(
                              text: 'تغير كلمة المرور',
                              isLoading: isLoadingButton,
                              onPressed: () {
                                final bool? isValid = formKey.currentState?.validate();
                                if (!isValid!) return;
                                isLoadingButton.value = true;
                                ProfileViewModel.changePassword(context: context, newPass: resetController.text).then((value) {
                                  isLoadingButton.value = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ))),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
        floatingActionButton: !isSaveTheChanges.value
            ? null
            : FloatingActionButton.extended(
                onPressed: () async {
                  Utils.buildLoading(context);
                  await ProfileViewModel.updateUserInfo(context: context, newEmail: emailController.text, newName: nameController.text, newPhone: phoneController.text);
                  Navigator.pop(context);
                },
                label: const Text("حفظ التغيرات", style: TextStyle(fontSize: 16)),
                icon: const Icon(Icons.thumb_up),
                elevation: 5,
              ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: displayHeight(context) * 0.50,
                    width: double.infinity,
                    child: const Image(
                      image: AssetImage('assets/images/design2.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            ProfileViewModel.logout(context: context);
                          },
                          child: const Icon(Icons.logout, size: 35, color: AppColors.redColor),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_forward_ios_outlined, size: 30, color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              Container(
                margin: EdgeInsets.only(top: displayHeight(context) * 0.25),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Text(
                      'المعلومات الشخصية',
                      style: TextStyle(color: AppColors.darkGreyColor, fontSize: 32, fontFamily: 'Careem'),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomTextInputField(
                            controller: nameController,
                            labelText: 'الاسم',
                            suffixIcon: Icons.person,
                            onChangeFunctionl: (String value) {
                              isSaveTheChanges.value = true;
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء ادخال الاسم';
                              }
                              // Return null if the entered email is valid
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextInputField(
                            controller: emailController,
                            labelText: 'البريد الالكتروني',
                            suffixIcon: Icons.email,
                            onChangeFunctionl: (String value) {
                              isSaveTheChanges.value = true;
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء ادخال البريد الالكتروني';
                              }
                              // Check if the entered email has the right format
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'الرجاء ادخال البريد الالكتروني بشكل صحيح';
                              }
                              // Return null if the entered email is valid
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextInputField(
                            controller: phoneController,
                            labelText: 'رقم الجوال',
                            suffixIcon: Icons.phone,
                            onChangeFunctionl: (String value) {
                              isSaveTheChanges.value = true;
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء ادخ ال رقم الجوال';
                              }
                              //Check if the entered phone number is only numbers
                              else if (!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(value)) {
                                return "الرجاء ادخال رقم الجوال بشكل صحيح";
                              }
                              // Return null if the entered email is valid
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              showBottomSheet(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.centerRight,
                              child: const Text(
                                'تغير كلمة المرور',
                                style: TextStyle(decoration: TextDecoration.underline, fontFamily: 'Careem', fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
