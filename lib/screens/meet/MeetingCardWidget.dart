import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/models/meeting_model.dart';
import 'package:meet/res/color.dart';
import 'package:meet/res/style/text_style.dart';
import 'package:meet/screens/meet/meet_view.dart';
import 'package:meet/screens/summary/summary_view.dart';
import 'package:meet/screens/summary/summary_view_model.dart';
import 'package:meet/utils/sizes_helpers.dart';

class ActiveMeetingCardWidget extends StatelessWidget {
  final String title;
  final String id;
  final String firebaseID;
  final String time;
  final String personName;
  final Meeting meeting;

  const ActiveMeetingCardWidget({
    required this.title,
    required this.id,
    required this.time,
    required this.personName,
    required this.firebaseID,
    required this.meeting,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.only(right: 25, top: 13, left: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A27),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: displayWidth(context) * 0.65,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF4DB6C9),
                      fontSize: 17,
                      fontFamily: 'Careem',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: displayWidth(context) * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  '$personName',
                                  style: const TextStyle(color: Color(0xFFffffff), fontSize: 15, fontFamily: 'Careem'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: displayWidth(context) * 0.30,
                  child: MaterialButton(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    color: AppColors.purpleColor,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return MeetView(conferenceID: id, firebaseID: firebaseID, meeting: meeting,);
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'انضم الان',
                          style: AppStyle.instance.smallWhiteText.copyWith(fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 17,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PastMeetingCardWidget extends ConsumerWidget {
  final String title;
  final String id;
  final String firebaseID;
  final String time;
  final String personName;
  final Meeting meeting;

  const PastMeetingCardWidget({
    required this.title,
    required this.id,
    required this.time,
    required this.personName,
    required this.firebaseID,
    required this.meeting,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {

        ref.read(meetingSelectedProvider.notifier).state = meeting;

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SummaryView(meeting: meeting,);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        width: double.infinity,
        height: 90,
        padding: const EdgeInsets.only(right: 25, top: 13, left: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A27),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Color(0xFF4DB6C9), fontSize: 17, fontFamily: 'Careem', overflow: TextOverflow.ellipsis),
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.purpleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      '$time / $personName',
                      style: const TextStyle(color: Color(0xFFffffff), fontSize: 15, fontFamily: 'Careem'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
