import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/shared/widgets/animation/fade_transition.dart';
import 'package:flutter_audio_visualizer/shared/widgets/color/blur.dart';

class HomeTitle extends StatefulWidget {
  const HomeTitle({super.key});

  @override
  State<HomeTitle> createState() => _HomeTitleState();
}

class _HomeTitleState extends State<HomeTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late final CurvedAnimation _titleFade;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _titleFade = CurvedAnimation(parent: _animation, curve: const Interval(0.0, 0.3, curve: Curves.easeIn));
    _animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 30),
        child: FadeAnimation(
          animation: _titleFade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("FACE THE SIN,", style: TextStyle(fontSize: 25, height: 1.2, color: Colors.white.withAlpha(220))),
              Text("SAVE THE E.G.O", style: TextStyle(fontSize: 25, height: 1.2, color: Colors.grey.withAlpha(200))),
            ],
          ),
        ),
      ),
    );
  }
}
