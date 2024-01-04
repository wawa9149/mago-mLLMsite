import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mllm_demo/api/mago_llm.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ChatBotPage extends StatefulWidget {
  String email = '';

  ChatBotPage({required this.email, Key? key}) : super(key: key);

  // shift + enter키는 아무 동작 x
  // enter키는 메세지 전송
  // answer가 다 출력되기 전에 질문이 또 들어가면 오류 발생
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _questionController = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isTyping = false;
  bool _isEmailSending = false;
  final FocusNode _textFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // appbar 그림자 제거
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
          child: Image.asset(
            'assets/images/mago-word-dark.png',
          ),
        ),
        leadingWidth: 130,
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            child: Column(
              children: [
                SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                    ),
                    onPressed: () {},
                    child: Text('+ New Chat',
                        style: TextStyle(color: Colors.black))),
                SizedBox(height: 20),
                Container(
                  width: 220,
                  height: 3,
                  color: Color.fromRGBO(43, 52, 153, 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), //모서리를 둥글게
                  color: Colors.grey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50), //모서리를 둥글게
                        ),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Container(
                                // color: _messages[index]['type'] == 'question'
                                //     ? Colors.blue
                                //     : Colors.yellow,
                                alignment:
                                    _messages[index]['type'] == 'question'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      _messages[index]['type'] == 'question'
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    if (_messages[index]['type'] == 'answer')
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/dog_icon.png',
                                          height: 45,
                                        ),
                                      ),
                                    Container(
                                      width: 500,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey[500],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                                        child: SelectableText(
                                          _messages[index]['message']!,
                                          textAlign: _messages[index]['type'] ==
                                                  'question'
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          style: TextStyle(
                                            color: _messages[index]['type'] ==
                                                    'question'
                                                ? Colors.black
                                                : Colors.black,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_messages[index]['type'] == 'question')
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/cat_icon.png',
                                          height: 50,
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
                          width: 750,
                          // 여기 코드 수정 필요
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (RawKeyEvent event) {
                              if (event is RawKeyUpEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter &&
                                  event.isShiftPressed) {
                                // Shift + Enter 키를 눌렀을 때 처리
                                _handleShiftEnter();
                              } else if (event is RawKeyUpEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter && !event.isShiftPressed && _isTyping == false) {
                                // Enter 키를 눌렀을 때 처리
                                _handleEnter();
                              }
                            },
                            child: TextField(
                              focusNode: _textFocusNode,
                              onEditingComplete: _onEditingComplete,
                              controller: _questionController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: '질문',
                                hintText: '여기에 질문을 입력하세요.',
                              ),
                              maxLines: null,
                              // Allows multiple lines
                              // keyboardType: TextInputType.multiline,
                              // textInputAction: TextInputAction.newline,
                              // 추가된 부분
                              // 엔터를 눌렀을때 동작
                              // onSubmitted: (_) {
                              //   _sendMessage();
                              // },
                              // // Disable submission on enter
                              // // 바뀐게 없으면 동작하지 않음
                              // onChanged: (text) {
                              //   // Check if the last character is a newline
                              //   if (text.isNotEmpty && text.endsWith('\n')) {
                              //     // Remove the newline character and send the message
                              //     _questionController.text =
                              //         text.substring(0, text.length - 1);
                              //     _sendMessage();
                              //   }
                              // },
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _sendMessage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(43, 52, 153, 1),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : const Text(
                                    '전송',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 90,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _sendEmail();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(43, 52, 153, 1),
                            ),
                            child: _isEmailSending
                                ? CircularProgressIndicator()
                                : const Text(
                                    '이메일',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onEditingComplete() {
    _sendMessage();
  }

  void _handleShiftEnter() {
    // setState(() {
    //   _questionController.text += '\n';
    // });

    // Move focus to the text field again
    FocusScope.of(context).requestFocus(_textFocusNode);
  }

  void _handleEnter() {
    // Check if the last character is a newline
    String text = _questionController.text;
    if (text.isNotEmpty && text.endsWith('\n')) {
      // Remove the newline character and send the message
      _questionController.text = text.substring(0, text.length - 1);
    }
    _sendMessage(); // _sendMessage 함수 호출
  }

  void _sendMessage() async {
    String question = _questionController.text;
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.insert(0, {'message': question, 'type': 'question'});
      _questionController.clear();
    });

    if (_isTyping == false) {
      await _sendAnswer(question);
    }

    // String? answer = await _request(question);
    //
    // if (answer != null) {
    //   setState(() {
    //     _messages.insert(0,
    //         {'message': '', 'type': 'answer'}); // 빈 문자열을 추가하여 나중에 채워질 공간을 만듭니다.
    //   });
    //
    //   // 한 문장에 대한 타이핑 애니메이션
    //   for (int i = 0; i < answer.length; i++) {
    //     await Future.delayed(Duration(milliseconds: 100));
    //     setState(() {
    //       _messages[0]['message'] =
    //           answer.substring(0, i + 1); // 마지막에 추가된 빈 문자열을 업데이트합니다.
    //     });
    //   }
    // }
    //
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<void> _sendAnswer(String question) async {
    setState(() {
      _isTyping = true;
    });

    String? answer = await _request(question);

    if (answer != null) {
      setState(() {
        _messages.insert(0,
            {'message': '', 'type': 'answer'}); // 빈 문자열을 추가하여 나중에 채워질 공간을 만듭니다.
      });

      // 한 문장에 대한 타이핑 애니메이션
      for (int i = 0; i < answer.length; i++) {
        await Future.delayed(Duration(milliseconds: 50));
        setState(() {
          _messages[0]['message'] =
              answer.substring(0, i + 1); // 마지막에 추가된 빈 문자열을 업데이트합니다.
        });
      }
    }

    setState(() {
      _isLoading = false;
      _isTyping = false;
    });
  }

  void _sendEmail() async {
    print(widget.email);
    String question = _questionController.text;

    print("이메일 전송 시작");
    setState(() {
      _isEmailSending = true;
    });

    String? answer = await _request(question);

    setState(() {
      _isEmailSending = false;
      _messages.insert(0, {'message': question, 'type': 'question'});
      _questionController.clear();
      if (answer != null) {
        _messages.insert(0, {'message': answer, 'type': 'answer'});
      }
    });

    print(_messages.toString());

    final Email email = Email(
      body: _messages.toString(),
      subject: '질문에 대한 답변입니다.',
      recipients: [widget.email],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
    print("이메일 전송 완료");
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
