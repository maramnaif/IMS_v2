import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/screens/login/login_view_model.dart';
import 'package:meet/services/database.dart';
import 'package:meet/services/gpt_api.dart';
import 'package:meet/utils/general_utils.dart';

class MeetingViewModel {
  static Future<void> speechToText(WidgetRef ref, String meetingId, String path) async {
    final userProvider = ref.read(userDataProvider);
    String email = userProvider!.email;
    String? resultText = await GptApi.whisperAPI(path);

    if (resultText == null) {
      Fluttertoast.showToast(msg: "يوجد خطا من المصدر");
      return;
    }
    await Database.updateTranscriptText(meetingId, email, resultText);
    Logger().w(resultText);
  }

  static Future<void> updateMeetingStatus(String meetingId, String newStatus) async {
    try {

      // Reference to the specific meeting document in Firestore
      var meetingRef = FirebaseFirestore.instance.collection('meetings').doc(meetingId);

      // Update the status field with the new status
      await meetingRef.update({'status': newStatus});
    } catch (e) {
      print('Error updating meeting status: $e');
      // Handle the error as needed
    }
  }

  static bool isAdminMeeting(WidgetRef ref, String adminEmail) {
    final userProvider = ref.read(userDataProvider);
    return userProvider?.email == adminEmail ? true : false;
  }
}
