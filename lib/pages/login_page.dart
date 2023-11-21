import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mllm_demo/pages/chatbot_page.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 200),
          const Text(
            '로그인',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 30),
          const SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '아이디',
              ),
            ),
          ),
          const SizedBox(height: 30),
          const SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Get.to(const ChatBotPage());
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(110, 150, 200, 1),
            ),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }
}
