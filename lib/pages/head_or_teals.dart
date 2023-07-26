import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HeadsOrTailsPage extends StatefulWidget {
  const HeadsOrTailsPage({Key? key}) : super(key: key);

  @override
  DiceState createState() => DiceState();
}

class DiceState extends State<HeadsOrTailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isHeads = true;
  bool _isAnimating = false;


  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false;
            _isHeads = Random().nextBool();
          });
          _animationController.reset();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_isAnimating) {
      setState(() {
        _isAnimating = true;
      });

      _animationController.forward();
    }
  }

  Widget _buildCoin() {
    return Transform(
      transform: Matrix4.rotationX(_animation.value),
      alignment: Alignment.center,
      child: Image.asset(
        _isHeads ? 'assets/images/money1.png' : 'assets/images/money2.png',
        width: 150,
        height: 150,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yazı Tura'),
        backgroundColor: Colors.orange,
      ),
      body: GestureDetector(
        onTap: (){
          final player=AudioCache();
          _startAnimation();
          player.play("coinsound.mp3");
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/desk.jpg"),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: _isAnimating
                ? _buildCoin()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _isHeads
                            ? 'assets/images/money1.png'
                            : 'assets/images/money2.png',
                        width: 150,
                        height: 150,
                      ),
                      Text(
                        _isHeads ? 'Tura' : 'Yazı',
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
