import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/screens/temperature_screen/widgets/temperature_details.dart';
import 'package:tesla_animation/screens/temperature_screen/widgets/temperature_overlay.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({Key? key}) : super(key: key);

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> slideAnimation;
  late Animation<double> opacityAnimation;

  final ValueNotifier<bool> screenVisibility = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    slideAnimation =
        Tween<double>(begin: 50.0, end: 0.0).animate(CurvedAnimation(
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
              TemperatureDetails(
                  slideAnimation: slideAnimation,
                  opacityAnimation: opacityAnimation),
              const TemperatureOverlay(),
            ],
          ),
          builder: (_, index, child) {
            if (index == 2) {
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
      },
    );
  }
}
