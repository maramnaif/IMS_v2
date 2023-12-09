import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/models/meeting_model.dart';
import 'package:meet/res/enum/status_enum.dart';
import 'package:meet/screens/home/home_view_model.dart';
import 'package:meet/screens/login/login_view_model.dart';
import 'package:meet/utils/general_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import 'meeting_view_model.dart';

class MeetView extends ConsumerStatefulWidget {
  final String conferenceID;
  final String firebaseID;
  final Meeting meeting;

  const MeetView({
    Key? key,
    required this.conferenceID,
    required this.firebaseID,
    required this.meeting,
  }) : super(key: key);

  @override
  ConsumerState<MeetView> createState() => _MeetViewState();
}

class _MeetViewState extends ConsumerState<MeetView> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = "";
  late Stream<DocumentSnapshot> _meetingStream;
  bool isAdmin = false;
  bool isClosed = false;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    isAdmin = MeetingViewModel.isAdminMeeting(ref, widget.meeting.adminEmail);
    startRecording();
    // Listen for changes in the meeting document
    var meetingRef = FirebaseFirestore.instance.collection('meetings').doc(widget.firebaseID);
    _meetingStream = meetingRef.snapshots();
  }


  Future<bool> _onWillPop() async {
    await leaveTheMeeting();
    if(isAdmin){
      await closeTheMeeting();
    }
    return true; // Allow the navigation to occur.
  }

  Future<void> closeTheMeeting() async {
    Logger().i("Leaving admin conference");
    await MeetingViewModel.updateMeetingStatus(widget.firebaseID, Status.closed.name);
  }

  Future<void> leaveTheMeeting() async {
    Logger().i("Leaving  conference");
    Utils.buildLoading(context);
    await stopRecording();
    await MeetingViewModel.speechToText(ref,widget.firebaseID,audioPath);
    ref.refresh(activeMeetingsProvider);
    ref.refresh(pastMeetingsProvider);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    audioRecord.dispose();
  }

  Future<void> startRecording() async {
    try{
    bool result = await audioRecord.hasPermission();
    if (result) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String audioFilePath = '${appDocDir.path}/meetingims.mp4';
      await audioRecord.start(path: audioFilePath);
      setState(() {
        isRecording = true;
      });
    }
    }catch(e){
      Logger().w(e.toString());
    }
  }
    Future<void> stopRecording() async {
    String? path = await audioRecord.stop();
    setState(() {
      isRecording = false;
      audioPath = path!;
    });
  }

  Future<void> _handleMeetingClosed() async {
    await leaveTheMeeting(); // Wait for leaveTheMeeting() to complete
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _meetingStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var meetingData = snapshot.data?.data() as Map<String, dynamic>?;

          if (meetingData != null) {
            var meetingStatus = meetingData['status'];
            if (meetingStatus == 'closed' && !isAdmin && !isClosed) {
              isClosed = true;
              // Close the meeting for all users
              Logger().w("leav");
              WidgetsBinding.instance
                  .addPostFrameCallback((_) {
                Logger().w("leav 2");

                _handleMeetingClosed();
                Utils.showAchBanner(context: context, message: "تم اغلاق الاجتماع من المسؤول", isError: false);
              });

              return const Center(
                child: Text('تم اغلاق الاجتماع من المسؤول'),
              );
            }

            return WillPopScope(
              onWillPop: _onWillPop,
              child: SafeArea(
                // child: AudioRecorder(),

                child: Consumer(builder: (context, ref, child) {
                  final user = ref.read(userDataProvider);
                  return ZegoUIKitPrebuiltVideoConference(
                    appID: 2037793360,
                    // Fill in the appID that you get from ZEGOCLOUD Admin Console.
                    appSign: "fc0a8ffea0029b3eeb5d237502780c970d8d2f46ab34a9d078c9448690ffe297",
                    // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
                    userID: user!.email,
                    userName: user.username,
                    conferenceID: widget.conferenceID,
                    config: ZegoUIKitPrebuiltVideoConferenceConfig(
                      topMenuBarConfig: ZegoTopMenuBarConfig(
                        title: widget.meeting.meetingTitle
                      ),
                      onLeave: () async {
                        await leaveTheMeeting();
                        if(isAdmin){
                          await closeTheMeeting();
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
              ),
            );
          }

          return const Center(
            child: Text('لايوجد بيانات للاجتماع'),
          );
        },
      ),
    );
  }
}
//
// class AudioRecorder extends StatefulWidget {
//   const AudioRecorder({Key? key}) : super(key: key);
//
//   @override
//   State<AudioRecorder> createState() => _AudioRecorderState();
// }
//
// class _AudioRecorderState extends State<AudioRecorder> {
//   late Record audioRecord;
//   late AudioPlayer audioPlayer;
//   bool isRecording = false;
//   String audioPath = "";
//
//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     audioRecord = Record();
//   }
//
//   @override
//   void dispose() {
//     super.initState();
//     audioPlayer.dispose();
//     audioRecord.dispose();
//   }
//
//   Future<void> startRecording() async {
//     bool result = await audioRecord.hasPermission();
//     if (result) {
//       await audioRecord.start();
//       setState(() {
//         isRecording = true;
//       });
//     }
//   }
//
//   Future<void> stopRecording() async {
//     String? path = await audioRecord.stop();
//     setState(() {
//       isRecording = false;
//       audioPath = path!;
//     });
//     Logger().w(path);
//   }
//
//   Future<void> startPlayer() async {
//     String? res = await transcribeAudio(audioPath);
//     Source source = UrlSource(audioPath);
//     await audioPlayer.play(source);
//   }
//
//   Future<String?> transcribeAudio(String path) async {
//     String apiUrl = "https://api.openai.com/v1/audio/transcriptions";
//     String apiKey = "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"; // Replace with your OpenAI API key
//     String audioFilePath = path;
//     String transcript = "";
//
//     try {
//       final url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');
//
//       final req = http.MultipartRequest('POST', url)
//         ..files.add(await http.MultipartFile.fromPath('file', audioFilePath))
//         ..fields['model'] = 'whisper-1';
//
//       req.headers['Authorization'] = 'Bearer $apiKey';
//       req.headers['Content-Type'] = 'multipart/form-data';
//
//       final stream = await req.send();
//       final res = await http.Response.fromStream(stream);
//       final status = res.statusCode;
//       if (status != 200) throw Exception('http.send error: statusCode= $status');
//
//       print(res.body);
//
//       Logger().w(res.statusCode);
//       //
//       // if (res.statusCode == 200) {
//       //   var data = json.decode(res.body);
//       //   setState(() {
//       //     transcript = data["choices"][0]["text"].toString();
//       //   });
//       // } else {
//       //   print("Failed to transcribe audio. Status code: ${res.statusCode}");
//       // }
//       print(transcript);
//       Logger().w(utf8.decode(res.bodyBytes));
//       return transcript;
//     } catch (error) {
//       print("Error: $error");
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio Record'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 //start recording
//                 if (isRecording) {
//                   stopRecording();
//                 } else {
//                   startRecording();
//                 }
//               },
//               child: !isRecording ? const Text('Start') : const Text('Stop')),
//           if (!isRecording && audioPath != null)
//             ElevatedButton(
//                 onPressed: () {
//                   startPlayer();
//                 },
//                 child: const Text('Play')),
//         ],
//       ),
//     );
//   }
// }
