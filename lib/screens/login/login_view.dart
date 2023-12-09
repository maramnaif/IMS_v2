import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meet/screens/home/home_view.dart';
import 'package:meet/screens/login/login_view_model.dart';
import 'package:meet/screens/signup/signup_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet/utils/sizes_helpers.dart';
import 'package:meet/widget/MainButtonWidget.dart';

class LoginScreen extends HookConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isPassHide = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stack(
            children: [
              Container(
                height: displayHeight(context) * 0.40,
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/images/design.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: displayHeight(context) * 0.25),
                  child: Container(
                    child: Column(
                      children: [
                   const Text(
                     'تسجيل الدخول',
                     style: TextStyle(color: Color(0xFF2B2A27), fontSize: 40, fontFamily: 'Careem'),
                   ),
                         const SizedBox(
                          height: 70,
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.80,
                          child: TextFormField(
                            controller: emailController,
                            decoration:  const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFD9D9D9),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                              label: Text('البريد الالكتروني', style: TextStyle(fontFamily: 'Careem')),
                            ),
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
                        ),
                         const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.80,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: isPassHide.value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFD9D9D9),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: InkWell(
                                onTap: (){
                                  isPassHide.value = !isPassHide.value;
                                },
                                child: Visibility(
                                  visible: isPassHide.value,
                                  replacement: const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black,
                                  ),
                                  child: const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                              label: const Text('كلمة المرور', style: TextStyle(fontFamily: 'Careem')),
                            ),
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
                        ),
                        Container(
                          margin: EdgeInsets.only(right: displayWidth(context) * 0.10),
                           alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {


                              LoginViewModel.showResendPassBottomSheet(context, ref);
                            },
                            child:  const Text(
                              'نسيت كلمة المرور',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  fontSize: 15,
                                  fontFamily: 'Careem'),
                            ),
                          ),
                        ),
                        MainButtonWidget(
                          text: 'تسجيل الدخول',
                          isLoading: isLoading,
                          onPressed: () {
                            final bool? isValid = _formKey.currentState?.validate();
                            if (!isValid!) return;
                            isLoading.value = true;
                            LoginViewModel.signIn(ref: ref, context: context, email: emailController.text, password: passwordController.text)
                                .then((value) {
                              isLoading.value = false;
                            });
                          },
                        ),
                         const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             const Text('ليس لديك حساب؟', style: TextStyle(fontFamily: 'Careem')),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return SignupScreen();
                                }));
                              },
                              child:  const Text(
                                'انشاء حساب  جديد',
                                style: TextStyle(decoration: TextDecoration.underline, fontFamily: 'Careem'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
