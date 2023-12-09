import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meet/models/meeting_model.dart';
import 'package:meet/models/user_model.dart';
import 'package:meet/utils/general_utils.dart';

import '../general_provider/firebase_providers.dart';
import '../res/enum/status_enum.dart';

class Database {
  // Users Table
  static late BuildContext context;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> fetchCurrentUser(WidgetRef ref, String idUser) async {
    final auth = ref.read(firebaseAuthProvider);
    final user = auth.currentUser;
    if (user == null) {
      return null; // User not authenticated
    }

    final userData = await FirebaseFirestore.instance.collection('users').doc(idUser).get();
    if (userData.exists) {
      return UserModel.fromJson(userData.data() as Map<String, dynamic>);
    } else {
      throw Exception('User data not found');
    }
  }

  static Future<void> insertUserRow(UserModel userModel, String idUser) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _users = _firestore.collection('users');
    try {
// Assuming the email is unique and you want to use it as a document ID
      await _users.doc(idUser).set(userModel.toJson());
    } catch (e) {
      print("Error adding user: $e");
      throw e; // re-throwing the exception so you can handle it outside if needed
    }
  }

  static Future fetchUser(String uuid) async {}

  static dynamic fetchUsersTable() async {}

  static Future updateUserData({
    String? fname,
    String? pid,
    String? phone,
  }) async {}

// Transactions Table
  static dynamic fetchMeetingsTable() async {}

  static fetchMeeting(String id) async {}

  static Future<void> saveMeeting(Meeting meeting, BuildContext context) async {
    final CollectionReference _meetingsCollection = FirebaseFirestore.instance.collection('meetings');
    try {
      // Convert Meeting object to JSON
      Map<String, dynamic> meetingData = meeting.toJson();

      // Add the meeting data to Firestore
      await _meetingsCollection.add(meetingData);

      // Meeting successfully added to Firestore
      Utils.showAchBanner(context: context, message: "تم انشاء الاجتماع", isError: false);
      Navigator.pop(context);
    } catch (e) {
      // Handle errors, if any
      Utils.showAchBanner(context: context, message: "حدث خطأ", isError: true);
      print('Error creating meeting: $e');
    }
  }

  static Future<List<Meeting>?> getMeetingsByAdminEmail(String adminEmail, bool isActiveFetch) async {
    final CollectionReference _meetingsCollection = FirebaseFirestore.instance.collection('meetings');
    DateTime currentDateTime = DateTime.now();
    DateTime currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
    List<Meeting>? activeMeetingsList = [];
    List<Meeting>? pastMeetingsList = [];



    try {
      var querySnapshot = await _meetingsCollection.where('adminEmail', isEqualTo: adminEmail).get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {

        Map<String, dynamic> data = queryDocumentSnapshot.data() as Map<String, dynamic>;
        String documentId = queryDocumentSnapshot.id;

        Meeting meeting = Meeting.fromJson(data)..firebaseId = documentId;

        if(!meeting.dateTime.isBefore(currentDate) && meeting.status == Status.active) {

          activeMeetingsList.add(meeting);
        }else{
          pastMeetingsList.add(meeting);
        }
      }
    } catch (e) {
      // Handle errors, if any
      print('Error getting meetings by shared email: $e');
    }
    return isActiveFetch ? activeMeetingsList : pastMeetingsList;
  }

  static Future<List<Meeting>?> getMeetingsBySharedEmail(String userEmail,bool isActiveFetch) async {
    final CollectionReference _meetingsCollection = FirebaseFirestore.instance.collection('meetings');
    DateTime currentDateTime = DateTime.now();
    DateTime currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
    List<Meeting>? activeMeetingsList = [];
    List<Meeting>? pastMeetingsList = [];

    try {
      // Query meetings where the user's email is in sharedEmails list
      QuerySnapshot<Object?> querySnapshot = await _meetingsCollection.where('sharedEmails', arrayContains: userEmail).get();

      for (var queryDocumentSnapshot in querySnapshot.docs) {

        Map<String, dynamic> data = queryDocumentSnapshot.data() as Map<String, dynamic>;
        String documentId = queryDocumentSnapshot.id;
        Meeting meeting = Meeting.fromJson(data)..firebaseId = documentId;
        if(!meeting.dateTime.isBefore(currentDate) && meeting.status == Status.active) {
          activeMeetingsList.add(meeting);
        }else{
          pastMeetingsList.add(meeting);
        }
      }
    } catch (e) {
      // Handle errors, if any
      print('Error getting meetings by shared email: $e');
    }
    return isActiveFetch ? activeMeetingsList : pastMeetingsList;
  }

  static Future<List<Meeting>> getAllMeetings(String userEmail, bool isActiveFetch) async {
    List<Meeting> adminMeetings = await getMeetingsByAdminEmail(userEmail, isActiveFetch) ?? [];
    List<Meeting> sharedMeetings = await getMeetingsBySharedEmail(userEmail, isActiveFetch) ?? [];
    return [...adminMeetings, ...sharedMeetings];
  }


  static Future<void> updateTranscriptText(String meetingId, String participantEmail, String newText) async {
    try {
      // Reference to the specific meeting document in Firestore
      var meetingRef = _firestore.collection('meetings').doc(meetingId);

      // Get the transcripts array from the meeting document
      List<dynamic> transcripts = (await meetingRef.get()).data()?['transcripts'] ?? [];

      // Find the transcript with the given participantEmail
      for (int i = 0; i < transcripts.length; i++) {
        if (transcripts[i]['participantEmail'] == participantEmail) {
          // Update the textSpoken property
          transcripts[i]['textSpoken'] += newText;

          // Update the transcripts array in the meeting document
          await meetingRef.update({'transcripts': transcripts});
          break;
        }
      }
    } catch (e) {
      print('Error updating transcript text: $e');
      // Handle the error as needed
    }
  }

  static Future<Meeting?> getMeetingById(String meetingId) async {
    final DocumentReference _meetingDocument = FirebaseFirestore.instance.collection('meetings').doc(meetingId);

    try {
      // Get the meeting document by ID from Firestore
      DocumentSnapshot documentSnapshot = await _meetingDocument.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Convert document data to a Meeting object
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        return Meeting.fromJson(data);
      } else {
        // Document with the specified ID does not exist
        return null;
      }
    } catch (e) {
      // Handle errors, if any
      print('Error retrieving meeting: $e');
      return null;
    }
  }
  // Method to update summary attribute in Firestore
  static Future<void> updateSummary(String meetingId, String newSummary) async {
    final DocumentReference meetingDocument = FirebaseFirestore.instance.collection('meetings').doc(meetingId);
    try {
      // Update the 'summary' field in the Firestore document
      await meetingDocument.update({'summary': newSummary});
    } catch (e) {
      // Handle errors, if any
      print('Error updating summary: $e');
    }
  }

  // Method to update reports attribute in Firestore
  static Future<void> updateReports(String meetingId, String newReports) async {
    final DocumentReference meetingDocument = FirebaseFirestore.instance.collection('meetings').doc(meetingId);
    try {
      // Update the 'summary' field in the Firestore document
      await meetingDocument.update({'reports': newReports});
    } catch (e) {
      // Handle errors, if any
      print('Error updating report: $e');
    }
  }
}
