import 'package:flutter/material.dart';

class TopTextAnimation extends StatelessWidget {
  const TopTextAnimation({
    super.key,
    required this.controller,
    required this.topTextAnimation,
    required this.opacityAnimation,
  });

  final AnimationController controller;
  final Animation<double> topTextAnimation;
  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedBuilder(
        animation: controller,
        child: Column(
          children: const [
            Text(
              "220 mi",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            Text(
              "60%",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(0, topTextAnimation.value),
            child: Opacity(opacity: opacityAnimation.value, child: child),
          );
        },
      ),
    );
  }
}
