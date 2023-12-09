
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';



class GptApi{


  static const String token = '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';

  static final Map<String, String> headers = {
    // 'Content-Type': 'application/json',
    // 'x-api-key': X_API_Key,
    // 'customer-id': Customer_ID

    'Authorization': 'Bearer $token',
    "Content-Type": "application/json"
  };


  static Future<String> chatINV(String systemRole, String userRole, String userText) async {
    print("yes bef sec");

    final List<Map<String, dynamic>> messages = [
      {
        'role': "system",
        'content': systemRole
      },
      {
        'role': "user",
        'content': (userRole +"\n"+ userText),
      }
    ];

    final Map<String, dynamic> endpoints = {
      'model': "gpt-3.5-turbo",
      'messages': messages
    };

    var res = await fetchUserData(endpoints);
    return res;
  }
  static Future<String> fetchUserData(endpoint) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: headers,
      body: jsonEncode(endpoint),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> choices = jsonMap['choices'];
      print(response.body);
      for (int i = 0; i < choices.length; i++) {
        print('${i + 1}: ${choices[i]?['message']?['content']}');
        return ' ${choices[i]?['message']?['content']}';
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return "null";
  }

  static Future<String?> whisperAPI(String path) async {
    Logger().w("message in api");
      String apiKey = "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"; // Replace with your OpenAI API key
      String audioFilePath = path;
      String transcript = "";
      Logger().w(audioFilePath);
      try {
        final url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

        final req = http.MultipartRequest('POST', url)
          ..files.add(await http.MultipartFile.fromPath('file', audioFilePath))
          ..fields['model'] = 'whisper-1';

        req.headers['Authorization'] = 'Bearer $apiKey';
        req.headers['Content-Type'] = 'multipart/form-data';

        final stream = await req.send();
        final res = await http.Response.fromStream(stream);
        final status = res.statusCode;
        if (status != 200){
          Logger().w(res.body);
          return null;
        }
        Logger().w(jsonDecode(utf8.decode(res.bodyBytes)));
        return jsonDecode(utf8.decode(res.bodyBytes))['text'];
      } catch (error) {
        print("Error: $error");
      }
      return null;
  }

}