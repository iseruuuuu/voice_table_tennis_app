import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String lastWords = "";
  String lastError = '';
  String lastStatus = '';
  stt.SpeechToText speech = stt.SpeechToText();

  //TODO 点数
  int rightScore = 0;
  int leftScore = 0;

  //TODO マッチポイント
  int rightPoint = 0;
  int leftPoint = 0;

  Future<void> speak() async {
    bool available = await speech.initialize(
      onError: error,
      onStatus: status,
    );
    if (available) {
      speech.listen(onResult: resultListener, localeId: 'ja_JP');
      await Future.delayed(const Duration(seconds: 3));
      speech.stop();
      if ('$lastWords' == 'Right') {
        addScore(true);
      } else if ('$lastWords' == 'Left') {
        addScore(false);
      } else {
        print('認識できないよ');
      }
      //TODO ③得点を追加する。

    } else {}
  }

  void addScore(bool isScore) {
    //右 true 左 false
    if (isScore) {
      setState(() {
        rightPoint++;
      });
      checkScore();
    } else {
      setState(() {
        leftScore++;
      });
      checkScore();
    }
  }

  void checkScore() {

  }

  void checkPoint() {

  }

  Future<void> stop() async {
    speech.stop();
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void error(SpeechRecognitionError error) {
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void status(String status) {
    setState(() {
      lastStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '11 - 8',
        ),
      ),
      body: Column(
        children: [
          Text(
            '変換文字:$lastWords',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            'ステータス : $lastStatus',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rightScore++;
                    });
                  },
                  child: Container(
                    width: mediaHeight / 2,
                    height: mediaWidth / 4,
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        "$rightScore",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  '-',
                  style: TextStyle(
                    fontSize: mediaWidth / 5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      leftScore++;
                    });
                  },
                  child: Container(
                    width: mediaHeight / 2,
                    height: mediaWidth / 4,
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(
                        "$leftScore",
                        style: TextStyle(
                          fontSize: mediaWidth / 5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: speak,
            child: const Icon(
              Icons.play_arrow,
            ),
          ),
          FloatingActionButton(
            onPressed: stop,
            child: const Icon(
              Icons.stop,
            ),
          ),
        ],
      ),
    );
  }
}
