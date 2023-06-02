import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animation/generated/assets.dart';

class BatteryWidget extends StatelessWidget {
  const BatteryWidget({
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
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: AnimatedBuilder(
              animation: controller,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * .50,
                    width: constraints.maxWidth * .50,
                    child: SvgPicture.asset(Assets.iconsBattery),
                  ),
                  Column(
                    children: const [
                      Text(
                        "CHARGING",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "18 min remaining",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              builder: (context, child) {
                return Opacity(
                  opacity: opacityAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, topTextAnimation.value),
                    child: child,
                  ),
                );
              }),
        );
      }),
    );
  }
}
