import 'package:flutter/material.dart';
import 'package:tesla_animation/screens/temperature_screen/widgets/current_temperature.dart';
import 'package:tesla_animation/screens/temperature_screen/widgets/set_cool_or_hot.dart';
import 'package:tesla_animation/screens/temperature_screen/widgets/set_temperature.dart';

class TemperatureDetails extends StatelessWidget {
  const TemperatureDetails({
    super.key,
    required this.slideAnimation,
    required this.opacityAnimation,
  });

  final Animation<double> slideAnimation;
  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SetCoolOrHot(),
              SetTemperature(),
              CurrentTemperature(),
              SizedBox(height: 50),
            ],
          ),
        ),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, slideAnimation.value),
            child: Opacity(opacity: opacityAnimation.value, child: child),
          );
        });
  }
}
