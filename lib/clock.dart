import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomato Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: TomatoTimer(),
    );
  }
}

class TomatoTimer extends StatefulWidget {
  @override
  _TomatoTimerState createState() => _TomatoTimerState();
}

class _TomatoTimerState extends State<TomatoTimer> {
  int _seconds = 1500; // 初始时长为25分钟
  bool _isActive = false;
  late Timer _timer;
  TextEditingController _timeController = TextEditingController();

  void _toggleTimer() {
    setState(() {
      _isActive = !_isActive;
      if (_isActive) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds -= 1;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _resetTimer() {
    setState(() {
      _stopTimer();
      _seconds = 1500;
      _isActive = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds}';
  }

  void _setCustomTime() {
    int customTime = int.tryParse(_timeController.text) ?? 0;
    if (customTime > 0) {
      setState(() {
        _stopTimer();
        _seconds = customTime * 60;
        _isActive = false;
      });
      _timeController.clear();
    } else {
      // 处理无效输入
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content:
                Text('Please enter a valid positive integer for the time.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomato Timer'),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 300.0, // 设置容器宽度，影响环形进度条的半径
          height: 300.0, // 设置容器高度，影响环形进度条的半径
          child: CircularProgressIndicator(
            value: _seconds / 1500, // 百分比进度
            strokeWidth: 30, // 增加进度条的宽度
            valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 0, 4, 255)), // 设置进度条颜色
            backgroundColor: Colors.grey[200], // 设置背景颜色
            semanticsLabel: 'Circular progress indicator', // 用于辅助技术的描述性标签
          ),
        ),
        SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, // 设置 TextField 的宽度
              child: TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Set Custom Time (minutes)',
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _setCustomTime,
              child: Text('Set'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_seconds),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleTimer,
                  child: Text(_isActive ? 'Pause' : 'Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ])),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
