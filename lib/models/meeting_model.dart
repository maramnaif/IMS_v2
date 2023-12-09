import 'package:meet/res/enum/status_enum.dart';

class Transcript {
  String participantEmail;
  String textSpoken;

  Transcript({
    required this.participantEmail,
    required this.textSpoken,
  });

  Map<String, dynamic> toJson() => {
    'participantEmail': participantEmail,
    'textSpoken': textSpoken,
  };

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
    participantEmail: json['participantEmail'],
    textSpoken: json['textSpoken'],
  );
}

class Meeting {
  String? firebaseId; // Firebase document ID
  String adminName;
  String id;
  String adminEmail;
  String meetingTitle;
  List<String> sharedEmails;
  DateTime dateTime;
  Status status;
  List<Transcript> transcripts;
  String? summary; // String field for summary (optional)
  String? reports; // String field for reports (optional)

  Meeting({
    this.firebaseId,
    required this.adminName,
    required this.id,
    required this.adminEmail,
    required this.meetingTitle,
    required this.sharedEmails,
    required this.dateTime,
    required this.status,
    required this.transcripts,
    this.summary, // Optional summary field
    this.reports, // Optional reports field
  });

  Map<String, dynamic> toJson() => {
    'firebaseId': firebaseId,
    'adminName': adminName,
    'id': id,
    'adminEmail': adminEmail,
    'meetingTitle': meetingTitle,
    'sharedEmails': sharedEmails,
    'dateTime': dateTime.toIso8601String(),
    'status': status == Status.active ? 'active' : 'closed',
    'transcripts': transcripts.map((transcript) => transcript.toJson()).toList(),
    'summary': summary ?? "", // Add summary to JSON if available
    'reports': reports ?? "", // Add reports to JSON if available
  };

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
    firebaseId: json['firebaseId'],
    adminName: json['adminName'],
    id: json['id'],
    adminEmail: json['adminEmail'],
    meetingTitle: json['meetingTitle'],
    sharedEmails: List<String>.from(json['sharedEmails']),
    dateTime: DateTime.parse(json['dateTime']),
    status: json['status'] == 'active' ? Status.active : Status.closed,
    transcripts: (json['transcripts'] as List<dynamic>)
        .map((transcriptJson) => Transcript.fromJson(transcriptJson))
        .toList(),
    summary: json['summary'], // Parse summary from JSON
    reports: json['reports'], // Parse reports from JSON
  );
}
