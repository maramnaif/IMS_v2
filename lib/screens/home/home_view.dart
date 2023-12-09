import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/models/email_input_model.dart';
import 'package:meet/res/color.dart';
import 'package:meet/res/style/text_style.dart';
import 'package:meet/screens/meet/MeetingCardWidget.dart';
import 'package:meet/screens/profile/profile_view.dart';
import 'package:meet/services/database.dart';
import 'package:meet/utils/general_utils.dart';
import 'package:meet/widget/custom_text_input_field.dart';
import '../../utils/sizes_helpers.dart';
import '../login/login_view_model.dart';
import 'home_view_model.dart';

class HomeView extends HookConsumerWidget {
  HomeView({Key? key}) : super(key: key);

  void _showBottomSheet(BuildContext context) {
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
                    const Expanded(child: SingleChildScrollView(child: BottomSheetContent())),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: displayHeight(context) * 0.50,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: const Image(
                      image: AssetImage('assets/images/design2.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),

                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView()));
                      },
                      child: Image.asset('assets/images/profile.png'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: displayHeight(context) * 0.25),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: AppColors.greyColor,
                    ),
                    child: TabBar(
                      labelColor: AppColors.darkGreyColor,
                      unselectedLabelColor: AppColors.darkGreyColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: AppColors.whiteColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.all(5),
                      tabs: const [
                        Tab(
                          text: 'اجتماعات نشطة',
                        ),
                        Tab(
                          text: 'اجتماعات سابقة',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(children: [
                            RefreshIndicator(
                                onRefresh: () async {
                                  ref.refresh(activeMeetingsProvider);
                                  ref.refresh(pastMeetingsProvider);
                                },
                                child: ref.watch(activeMeetingsProvider).when(
                                    skipLoadingOnRefresh: false,
                                    data: (data) {

                                      if(data.isEmpty){
                                        return ListView(
                                          children: [
                                            Center(child: Text("لا يوجد اجتماعات", style: AppStyle.instance.bodyXLarge,)),
                                          ],
                                        );
                                      }

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return ActiveMeetingCardWidget(
                                            title: data[index].meetingTitle,
                                            id: data[index].id,
                                            time: data[index].dateTime.toString(),
                                            personName: data[index].adminName,
                                            firebaseID: data[index].firebaseId!,
                                            meeting: data[index],
                                          );
                                        },
                                      );
                                    },
                                    error: (error, stack) {
                                      return Text(error.toString());
                                    },
                                    loading: () {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 100),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    })),
                            RefreshIndicator(
                                onRefresh: () async {
                                  ref.refresh(activeMeetingsProvider);
                                  ref.refresh(pastMeetingsProvider);
                                },
                                child: ref.watch(pastMeetingsProvider).when(
                                    skipLoadingOnRefresh: false,
                                    data: (data) {

                                      if(data.isEmpty){
                                        return ListView(
                                          children: [
                                            Center(child: Text("لا يوجد اجتماعات", style: AppStyle.instance.bodyXLarge,)),
                                          ],
                                        );
                                      }
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return PastMeetingCardWidget(
                                            title: data[index].meetingTitle,
                                            id: data[index].id,
                                            time: Utils.convertDateTimeDisplay(data[index].dateTime.toString()),
                                            personName: data[index].adminName,
                                            firebaseID: data[index].firebaseId!,
                                            meeting: data[index],
                                          );
                                        },
                                      );
                                    },
                                    error: (error, stack) {
                                      return Text(error.toString());
                                    },
                                    loading: () {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 100),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    })),
                          ]),
                        ),
                        Container(
                          width: 180,
                          margin: const EdgeInsets.only(bottom: 30, top: 5),
                          child: MaterialButton(
                            minWidth: 180,
                            height: 50,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                            color: AppColors.blueColor,
                            onPressed: () {
                              // Button onPressed logic
                              _showBottomSheet(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'انشئ الجلسة',
                                  style: AppStyle.instance.smallWhiteText,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<EmailInputModel> _emailInputs = [];

  void _addEmailInput() {
    final newController = TextEditingController();
    setState(() {
      _emailInputs.add(EmailInputModel(
          controller: newController,
          widget: EmailInputField(
            controller: newController,
          )));
    });
  }

  Future<void> _createMeeting(WidgetRef ref) async {
    List<String> sharedEmails = _emailInputs.map((model) => model.controller.text).toList();
    final user = ref.read(userDataProvider);
    await HomeViewModel.createMeeting(user!.username, _controller.text, sharedEmails, context);
    ref.refresh(activeMeetingsProvider);
    ref.refresh(pastMeetingsProvider);
  }

  @override
  void initState() {
    final newController = TextEditingController();
    setState(() {
      _emailInputs.add(EmailInputModel(
          controller: newController,
          widget: EmailInputField(
            controller: newController,
          )));
    });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Text(
              'معلومات الجلسة',
              style: AppStyle.instance.h4Bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الموضوع:', style: AppStyle.instance.h5Bold),
              const SizedBox(height: 6,),
              CustomTextInputField(
                controller: _controller,
                labelText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء كتابة موضوع الجلسة';
                  }
                  // You can add more validation logic here if needed
                  return null;
                },
                // You can pass prefixIcon, suffixIcon, or any other parameters if needed
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('المشاركة مع:', style: AppStyle.instance.h5Bold),
              const SizedBox(height: 6,),

              Column(
                children: _emailInputs.map((model) => model.widget).toList(),
              ),
            ],
          ),
          const SizedBox(height: 0),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: displayWidth(context) * 0.10),
            child: FloatingActionButton(
              onPressed: _addEmailInput,
              backgroundColor: AppColors.blackColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Consumer(builder: (context, WidgetRef ref, child) {
            return Container(
              width: 180,
              margin: const EdgeInsets.only(bottom: 30, top: 5),
              child: MaterialButton(
                minWidth: 180,
                height: 50,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                color: AppColors.blueColor,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createMeeting(ref);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'انشاء الجلسة',
                      style: AppStyle.instance.smallWhiteText,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.videocam,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;

  EmailInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextInputField(
      controller: controller,
      labelText: 'Email',
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
    );
  }
}
