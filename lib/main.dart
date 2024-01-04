import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mllm_demo/pages/chatbot_page.dart';
import 'package:mllm_demo/pages/login_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const GetMaterialApp(
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MAGO Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: MyHomePage(title: 'mLLM Demo'),
        routes: {
          '/chat': (context) => ChatBotPage(email: ""),
        });
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  TextEditingController emailController = TextEditingController();
  TextEditingController textController = TextEditingController();

  void _goToChatBotPage() async {
    String email = emailController.text;
    Get.to(ChatBotPage(email: email),
        transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
          child: Image.asset(
            'assets/images/mago-word-dark.png',
          ),
        ),
        leadingWidth: 130,
        backgroundColor: Colors.white,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 180),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Say,',
                  style: TextStyle(
                    fontSize: 110,
                    fontFamily: 'Pretendard',
                    color: Color.fromRGBO(255, 108, 34, 1),
                    height: 1.2,
                  ),
                ),
                Text(
                  'Check,',
                  style: TextStyle(
                    fontSize: 110,
                    fontFamily: 'Pretendard',
                    color: Color.fromRGBO(255, 108, 34, 1),
                    height: 1.2,
                  ),
                ),
                Text(
                  'Get.',
                  style: TextStyle(
                    fontSize: 110,
                    fontFamily: 'Pretendard',
                    color: Color.fromRGBO(255, 108, 34, 1),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Do it all With MAGO and Be Healthy.',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 650,
                  height: 8,
                  color: Color.fromRGBO(43, 52, 153, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20), // 간격 조절
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                    controller: LogInPageState().emailController,
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
                      primary: const Color.fromRGBO(43, 52, 153, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Get Started',
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 180),
        ],
      ),
    );
  }
}
