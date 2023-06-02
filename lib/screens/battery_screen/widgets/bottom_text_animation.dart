import 'package:flutter/material.dart';

class BottomTextAnimation extends StatelessWidget {
  const BottomTextAnimation({
    super.key,
    required this.controller,
    required this.bottomTextAnimation,
    required this.opacityAnimation,
  });

  final AnimationController controller;
  final Animation<double> bottomTextAnimation;
  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedBuilder(
            animation: controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "22 mi/hr",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "232 v",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, bottomTextAnimation.value),
                child: Opacity(opacity: opacityAnimation.value, child: child),
              );
            }));
  }
}
