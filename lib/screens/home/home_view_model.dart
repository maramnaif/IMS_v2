import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet/general_provider/firebase_providers.dart';
import 'package:meet/models/meeting_model.dart';
import 'package:meet/screens/home/home_view.dart';
import 'package:meet/services/database.dart';
import 'package:riverpod/riverpod.dart';

import '../../res/enum/status_enum.dart';

FutureProvider<List<Meeting>> activeMeetingsProvider = FutureProvider<List<Meeting>>(
  (ref) async {
    final firebaseAuth = ref.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    if (user != null) {
      String userEmail = user.email ?? ''; // Get the user's email or use an empty string if email is null
      return await Database.getAllMeetings(userEmail, true);
    } else {
      // User is not logged in, handle this scenario accordingly
      return [];
    }
  },
);
FutureProvider<List<Meeting>> pastMeetingsProvider = FutureProvider<List<Meeting>>(
  (ref) async {
    final firebaseAuth = ref.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    if (user != null) {
      String userEmail = user.email ?? ''; // Get the user's email or use an empty string if email is null
      return await Database.getAllMeetings(userEmail, false);
    } else {
      // User is not logged in, handle this scenario accordingly
      return [];
    }
  },
);

class HomeViewModel {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> createMeeting(String adminName, String meetingTitle, List<String> sharedEmails, BuildContext context) async {
    // Get the current authenticated user
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      // User is not authenticated, handle accordingly
      print("User not authenticated!");
      return;
    }

    // Get current user's email
    String adminEmail = user.email!;

    // Generate a random 9-digit ID
    int meetingId = Random().nextInt(900000000) + 100000000;
    String meetingIdString = meetingId.toString();

// Get the current date and time
    DateTime currentDateTime = DateTime.now();
    DateTime currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);

    // Create empty transcripts for shared emails
    List<Transcript> transcripts = sharedEmails.map((email) {
      return Transcript(
        participantEmail: email,
        textSpoken: '', // Empty initial text spoken
      );
    }).toList();
    Transcript transcriptAdmin = Transcript(participantEmail: adminEmail, textSpoken: "");
    transcripts.add(transcriptAdmin);
// Create a Meeting object with the generated ID, admin email, and current date/time
    Meeting meeting = Meeting(
      adminName: adminName,
      id: meetingIdString,
      adminEmail: adminEmail,
      meetingTitle: meetingTitle,
      sharedEmails: sharedEmails,
      dateTime: currentDate,
      status: Status.active,
      transcripts: transcripts// Add the dateTime property here
    );

    // Call the DatabaseService to create the meeting
    await Database.saveMeeting(meeting, context);
  }
}
