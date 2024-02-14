import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class MagoLLM{
  final String user;
  final String system;
  final String assistant;
  final dio = Dio();
  final url = 'http://gpu.mago52.com:9211/llama/chat';

  MagoLLM(this.user, this.system, this.assistant);

  Future<String?> getAnswer() async {
    await overview();
    return chat(user, system, assistant);
  }

  Future<String?> overview() async {
    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'accept' : 'application/json'}),
        data: '',
      );
    } catch (e) {
      print('Request failed with error: $e');
    }
  }

  Future<String?> chat(String user, String system, String assistant) async {

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = {
      "user": user,
      "system": system,
      "assistant": assistant,
    };

    try {
      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: jsonEncode(body),
      );

      Map<String, dynamic> jsonData = response.data;

      // contents 부분 가져오기
      dynamic contents = jsonData['contents'];

      if (contents is Map<String, dynamic>) {
        // answer 부분 가져오기
        String? answer = contents['answer'] as String?;

        if (answer != null) {
          print(answer);
          return answer;
        } else {
          print('Answer is null or not a String.');
        }
      } else {
        print('Contents is not a Map<String, dynamic>.');
      }
    } catch (e) {
      print('Request failed with error: $e');
    }
    return "질문을 이해하지 못했습니다. 다시 한번 말씀해주세요.";
  }
}
