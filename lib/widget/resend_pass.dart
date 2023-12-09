import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../res/style/text_style.dart';
import '../screens/login/login_view_model.dart';
import '../utils/sizes_helpers.dart';
import 'MainButtonWidget.dart';
import 'custom_text_input_field.dart';

class ResendPasswordBottomSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final isLoadingButton = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: displayHeight(context) * 0.40,
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
                              'نسيت كلمة المرور',
                              style: AppStyle.instance.h4Bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomTextInputField(
                            controller: textController,
                            labelText: 'البريد الالكتروني',
                            suffixIcon: Icons.email,
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
                          const SizedBox(height: 10),
                          MainButtonWidget(
                            text: 'تحقق',
                            isLoading: isLoadingButton,
                            onPressed: () async {
                              final bool? isValid = formKey.currentState?.validate();
                              if (!isValid!) return;
                              isLoadingButton.value = true;
                              await LoginViewModel.forgetPassword(textController.text, context, ref);
                              isLoadingButton.value = false;
                              Navigator.pop(context);

                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
