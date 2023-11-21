import 'package:flutter/material.dart';
import 'package:mllm_demo/api/mago_llm.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _questionController = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('챗봇'),
        backgroundColor: Color.fromRGBO(110, 150, 200, 1),
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: Color.fromRGBO(245, 232, 170, 1),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(100, 0, 100, 50),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            color: _messages[index]['type'] == 'question' ? Colors.blue : Colors.yellow,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      _messages[index]['type'] == 'question'
                                          ? 'assets/images/dog_icon.png'
                                          : 'assets/images/cat_icon.png',
                                      height: _messages[index]['type'] == 'question' ? 45 : 50,
                                    ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      _messages[index]['message']!,
                                      style: TextStyle(
                                        color: _messages[index]['type'] == 'question'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 500,
                      child: TextField(
                        onEditingComplete: _onEditingComplete,
                        controller: _questionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '질문',
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 70,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          _sendMessage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(110, 150, 200, 1),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : const Text('전송'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onEditingComplete() {
    _sendMessage();
  }

  void _sendMessage() async {
    String question = _questionController.text;
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    String? answer = await _request(question);

    setState(() {
      _isLoading = false;
      _messages.insert(0, {'message': question, 'type': 'question'});
      _questionController.clear();
      if (answer != null) {
        _messages.insert(0, {'message': answer, 'type': 'answer'});
      }
    });
  }

  Future<String?> _request(String text) async {
    MagoLLM magoLLM = MagoLLM(text, '', '');
    String? answer = await magoLLM.getAnswer();
    if (answer != null) {
      return answer;
    } else {
      return '답변이 없습니다.';
    }
  }
}
