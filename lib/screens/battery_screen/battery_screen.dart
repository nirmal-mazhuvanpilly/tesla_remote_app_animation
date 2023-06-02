import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/screens/battery_screen/widgets/battery_widget.dart';
import 'package:tesla_animation/screens/battery_screen/widgets/bottom_text_animation.dart';
import 'package:tesla_animation/screens/battery_screen/widgets/top_text_animation.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({
    super.key,
  });

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> topTextAnimation;
  late Animation<double> bottomTextAnimation;
  late Animation<double> opacityAnimation;

  final ValueNotifier<bool> screenVisibility = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    topTextAnimation =
        Tween<double>(begin: 50.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    ));

    bottomTextAnimation =
        Tween<double>(begin: 50.0, end: -60.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    ));

    opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    animationStatusListener();
  }

  animationStatusListener() {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          screenVisibility.value = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          screenVisibility.value = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    screenVisibility.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: screenVisibility,
        child: Selector<TeslaProvider, int>(
            selector: (_, provider) => provider.selectedIndex,
            child: Stack(
              children: [
                TopTextAnimation(
                    controller: controller,
                    topTextAnimation: topTextAnimation,
                    opacityAnimation: opacityAnimation),
                BottomTextAnimation(
                    controller: controller,
                    bottomTextAnimation: bottomTextAnimation,
                    opacityAnimation: opacityAnimation),
                BatteryWidget(
                    controller: controller,
                    topTextAnimation: topTextAnimation,
                    opacityAnimation: opacityAnimation),
              ],
            ),
            builder: (_, index, child) {
              if (index == 1) {
                controller.forward();
              } else {
                controller.reverse();
              }
              return child!;
            }),
        builder: (_, value, child) {
          return Visibility(
            visible: value,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: child!,
          );
        });
  }
}
