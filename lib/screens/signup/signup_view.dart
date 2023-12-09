import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meet/models/user_model.dart';
import 'package:meet/screens/login/login_view.dart';
import 'package:meet/screens/signup/signup_view_model.dart';
import 'package:meet/utils/sizes_helpers.dart';
import 'package:meet/widget/MainButtonWidget.dart';



class SignupScreen extends HookConsumerWidget {
  SignupScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isPassHide = useState(true);
    final fullNameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phonenumberController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
        key: _formKey,
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
            Container(
              margin: EdgeInsets.only(top: displayHeight(context) * 0.25),
              child: Column(
                children: [
                  Container(
                    child: const Text(
                      'حساب جديد',
                      style: TextStyle(color: Color (0xFF2B2A27), fontSize: 38,  fontFamily: 'Careem'),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    child: SizedBox(
                      width: displayWidth(context) * 0.80,
                      height: 75,
                      child: TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))
                            ),
                            label: Text('الاسم الكامل',
                            style: TextStyle( fontFamily: 'Careem')
                            )
                        ),

                        validator: (value) { //to validate user input
                          if (value == null || value.trim().isEmpty) { //check if it's empty
                            return 'الرجاء ادخال الاسم الكامل';
                          }
                          if (value.trim().length < 5) { //if the full name less than 5 characters means it's not full name
                            return 'الرجاء ادخال الاسم بالكامل';
                          }
                          // Return null if the entered username is valid
                          return null;
                        },

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    child: SizedBox(
                      width: displayWidth(context) * 0.80,
                      height: 75,
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            label: Text('اسم المستخدم',
                                style: TextStyle( fontFamily: 'Careem')
                            )
                        ),

                        validator: (value) {  //to validate user input
                          if (value == null || value.trim().isEmpty) { //check if it's empty
                            return 'الرجاء ادخال اسم المستخدم';
                          }
                          if (value.trim().length < 4) { //if username less than 4 characters
                            return 'اسم المستخدم قصير جدا';
                          }
                          // Return null if the entered username is valid
                          return null;
                        },

                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    child: SizedBox(
                      width: displayWidth(context) * 0.80,
                      height: 75,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFD9D9D9),
                            hintText: 'example@gmail.com',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            label: Text('البريد الالكتروني',
                                style: TextStyle( fontFamily: 'Careem'))
                        ),

                        validator: (value) {  //to validate user input
                          if (value == null || value.trim().isEmpty) { //check if it's empty
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
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  SizedBox(
                    width: displayWidth(context) * 0.80,
                    height: 75,
                    child: TextFormField(
                      controller: phonenumberController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          label: Text('رقم الجوال',
                              style: TextStyle( fontFamily: 'Careem')
                          )
                      ),

                      validator: (value) { //to validate user input
                        if(value!.isEmpty){ //check if it's empty
                          return "الرجاء ادخال رقم الجوال";
                        }
                        //Check if the entered phone number is only numbers
                        else if(!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(value)){
                          return "الرجاء ادخال رقم الجوال بشكل صحيح";
                        }
                      },

                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    child: SizedBox(
                      width: displayWidth(context) * 0.80,
                      height: 75,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: isPassHide.value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30))),
                          label: Text('كلمة المرور',
                              style: TextStyle( fontFamily: 'Careem')),
                        ),

                        validator: (value) {//to validate user input
                          if (value == null || value.trim().isEmpty) { //check if it's empty
                            return 'الرجاء ادخال كلمة المرور';
                          }
                          if (value.trim().length < 8) { //if password less than 8 characters
                            return 'كلمة المرور قصيرة جدا';
                          }
                          // Return null if the entered password is valid
                          return null;
                        },

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MainButtonWidget(
                    text: 'التسجيل',
                    isLoading: isLoading,
                    onPressed: () {
                      final bool? isValid = _formKey.currentState?.validate();
                      if(!isValid!) return;

                      final user = UserModel(fullNameController.text, usernameController.text, emailController.text, phonenumberController.text);
                      isLoading.value = true;
                      SignUpViewModel.signup(ref: ref,context: context, user: user, password: passwordController.text).then((value) {
                        isLoading.value = false;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(' لديك حساب؟',
                          style: TextStyle( fontFamily: 'Careem')),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return LoginScreen();
                            }));
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                                fontFamily: 'Careem'
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
