import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primary_text_color   = const Color(0xFF006FFF);
const Color secondary_text_color = const Color(0xFFFFFFFF);
const Color background_color     = const Color(0xFF101010);

const double text_size = 70;

const String win_text  = "win";
const String lose_text = "lose";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: "My App",
      home: GameWindow(),
    );
  }
}

class GameWindow extends StatefulWidget {
  _GameWindowState createState() => _GameWindowState();
}

class _GameWindowState extends State<GameWindow>
    with SingleTickerProviderStateMixin {
  int _life = 5;
  int _speed = 2000; // wheel speed in milliseconds

  dynamic _score = 0;

  late AnimationController _controller;

  void _winOrLose(String result) {
    setState(() {
      _score = result;
      _controller.animateBack(0.0);
    });
  }

  void _gameHandler() {
    if (_score == win_text || _score == lose_text) {
      _controller.duration = Duration(milliseconds: _speed = 2000);

      setState(() {
        _life = 5;
        _score = 0;
        _controller.repeat();
      });
    } else {
      if (_controller.value >= 0.98 || _controller.value <= 0.02) {
        _controller.duration = Duration(milliseconds: _speed -= 100);

        setState(() {
          ++_score;
          _controller.repeat();
        });

        if (_score >= 10) _winOrLose(win_text);
      } else {
        setState(() => --_life);

        if (_life <= 0) _winOrLose(lose_text);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _speed),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _gameHandler(),
      child: Scaffold(
        backgroundColor: background_color,
        body: Column(
          children: <Widget>[
            Spacer(flex: 1),
            LifeBar(
              life: _life,
            ),
            Spacer(flex: 4),
            Wheel(
              score: _score,
              controller: _controller,
            ),
            SizedBox(height: 10),
            Image.asset( // ArrowUp
              'res/images/arrow_up.png',
              width: 100,
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LifeBar extends StatelessWidget {
  const LifeBar({
    Key? key,
    @required this.life,
  }) : super(key: key);

  final life;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          ' LIFE ',
          style: TextStyle(
            fontSize: text_size,
            color: primary_text_color,
          ),
        ),
        Text(
          life.toString(),
          style: TextStyle(
            fontSize: text_size,
            color: secondary_text_color,
          ),
        ),
      ],
    );
  }
}

class Wheel extends StatelessWidget {
  Wheel({
    Key? key,
    @required this.score,
    @required this.controller,
  }) : super(key: key);

  final score;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(controller),
          child: Image.asset('res/images/wheel.png', width: 300),
        ),
        ScoreBoard(
          score: score,
        ),
      ],
    );
  }
}

class ScoreBoard extends StatelessWidget {
  ScoreBoard({
    Key? key,
    @required this.score,
  }) : super(key: key);

  final score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SCORE',
          style: TextStyle(
            fontSize: text_size - 20,
            color: primary_text_color,
          ),
        ),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: text_size,
            color: secondary_text_color,
          ),
        ),
      ],
    );
  }
}
