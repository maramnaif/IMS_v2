import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/models/meeting_model.dart';
import 'package:meet/res/color.dart';
import 'package:meet/res/style/text_style.dart';
import 'package:meet/utils/sizes_helpers.dart';

import 'summary_view_model.dart';

class SummaryView extends HookConsumerWidget {
  const SummaryView({super.key, required this.meeting});

  final Meeting meeting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
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
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_forward_ios_outlined, size: 30, color: AppColors.whiteColor),
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
                  Container(
                    margin: EdgeInsets.only( left: 20, right: 20, bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      meeting.meetingTitle,
                      style: AppStyle.instance.h6Bold,
                    ),
                  ),
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
                          text: 'التقرير',
                        ),
                        Tab(
                          text: 'التلخيص',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        children: [
                          Expanded(
                            child: TabBarView(children: [
                              RefreshIndicator(
                                onRefresh: () async {},
                                child: ref.watch(reportsProvider).when(
                                      data: (data) {
                                        return SingleChildScrollView(child: Container(margin: EdgeInsets.only(bottom: 20),child: Text(data)));
                                      },
                                      error: (error, stackTrace) => Text(error.toString()),
                                      loading: () => const Center(child: CircularProgressIndicator()),
                                    ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async {},
                                child: ref.watch(summaryProvider).when(
                                      data: (data) {
                                        return SingleChildScrollView(child: Text(data));
                                      },
                                      error: (error, stackTrace) => Text(error.toString()),
                                      loading: () => const Center(child: CircularProgressIndicator()),
                                    ),
                              ),
                            ]),
                          ),
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
    );
  }
}
