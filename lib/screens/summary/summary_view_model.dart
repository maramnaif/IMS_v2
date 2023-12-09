import 'package:logger/logger.dart';
import 'package:meet/models/meeting_model.dart';
import 'package:meet/services/database.dart';
import 'package:meet/services/gpt_api.dart';
import 'package:meet/utils/general_utils.dart';
import 'package:riverpod/riverpod.dart';

final meetingSelectedProvider = StateProvider<Meeting?>((ref) => null);

FutureProvider<String> summaryProvider = FutureProvider<String>(
  (ref) async {
    final meeting = ref.watch(meetingSelectedProvider);
    if (meeting!.summary!.isNotEmpty) {

      return meeting.summary!;
    }

    Meeting? meetingFirebase = await Database.getMeetingById(meeting.firebaseId!);
    if (meetingFirebase!.summary!.isNotEmpty) {
      return meetingFirebase.summary!;
    }

    bool isThereSpokenData = SummaryViewModel.checkSpokenMeeting(meetingFirebase);
    if(!isThereSpokenData){
        String summary = await SummaryViewModel.gptSummaryGen(meeting);
        return summary;
    }
    return "حصل خطا";

  },
);

FutureProvider<String> reportsProvider = FutureProvider<String>(
      (ref) async {
    final meeting = ref.watch(meetingSelectedProvider);
    if (meeting!.reports!.isNotEmpty) {

      return meeting.reports!;
    }

    Meeting? meetingFirebase = await Database.getMeetingById(meeting.firebaseId!);
    if (meetingFirebase!.reports!.isNotEmpty) {
      return meetingFirebase.reports!;
    }

    bool isThereSpokenData = SummaryViewModel.checkSpokenMeeting(meetingFirebase);
    if(!isThereSpokenData){
      String reports = await SummaryViewModel.gptReportsGen(meeting);
      return reports;
    }
    return "حصل خطا";

  },
);


class SummaryViewModel{

  static bool checkSpokenMeeting(Meeting meeting){

    final transcriptsList = meeting.transcripts;
    transcriptsList.map((e) {
      if(e.textSpoken.isNotEmpty){
        return true;
      }
    });

    return false;

  }

  static Future<String> gptSummaryGen(Meeting meeting) async {
    const sysRole = "انت ستقوم ب انشاء ملخص وجميع ماهو مهم في  الاجتماع، المحاور الريسية، 1- عنوان الاجتماع، 2- ملخص الاجتماع ك نقاط، 3- عدد الحضور مع ذكر اسم كل شخص, اذا لا يوجد محادثة، حدد انه لم يتم التحدث، اذا كان لا يوجد محادثة في جميع الاجتماع، ولا تحدد اذا شخص ما لم يتحدث " ;
    final userRole = " ${meeting.meetingTitle} هذا البيان بجميع ماتحدث به الحضور، وعنوان الاجتماع هو" ;
    final transcripts = meeting.transcripts.map((transcript) => transcript.toJson()).toList();
    Logger().w(transcripts);
    var newSummary = await GptApi.chatINV(sysRole, userRole, transcripts.toString());
    Logger().w(newSummary);
    await Database.updateSummary(meeting.firebaseId!, newSummary);
    return newSummary;
  } 

  static Future<String> gptReportsGen(Meeting meeting) async {
    const sysRole = "،انت ستقوم ب انشاء تقرير وجميع ماهو مهم في  الاجتماع، هذا ليس  ملخص بل تقرير لجميع ما تم بالاجتماع, التركيز على كل شخص ماذا تحدث  " ;
    final userRole = "  ${meeting.adminName} :المدير ${Utils.convertDateTimeDisplay(meeting.dateTime.toString())} :بتاريخ  ${meeting.meetingTitle} هذا البيان بجميع ماتحدث به الحضور، ويجب توضيح كل شخص عن ماذا تحدث ك نقاط، وعنوان الاجتماع هو" ;
    final transcripts = meeting.transcripts.map((transcript) => transcript.toJson()).toList();

    var newReports = await GptApi.chatINV(sysRole, userRole, transcripts.toString());
    Logger().w(newReports);
    await Database.updateReports(meeting.firebaseId!, newReports);
    return newReports;
  }

}