import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mllm_demo/pages/chatbot_page.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 60,
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email address',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                _goToChatBotPage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Get Started', style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // void _onEditingComplete() {
  //   _goToChatBotPage();
  // }

  void _goToChatBotPage() async {
    String email = emailController.text;
    Get.to(ChatBotPage(email: email), transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
  }
}
