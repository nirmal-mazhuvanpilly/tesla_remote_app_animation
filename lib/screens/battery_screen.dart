import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

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

  final ValueNotifier<bool> screenVisibility = ValueNotifier(true);

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
        screenVisibility.value = true;
      } else if (status == AnimationStatus.dismissed) {
        screenVisibility.value = false;
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
        builder: (context, value, child) {
          return Visibility(
            visible: value,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: Selector<TeslaProvider, int>(
                selector: (context, provider) => provider.selectedIndex,
                builder: (context, value, child) {
                  if (value == 1) {
                    Future.delayed(const Duration(milliseconds: 0), () {
                      controller.forward();
                    });
                  } else {
                    controller.reverse();
                  }
                  return Stack(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedBuilder(
                              animation: topTextAnimation,
                              child: Selector<TeslaProvider, int>(
                                  selector: (context, provider) =>
                                      provider.selectedIndex,
                                  builder: (context, value, child) {
                                    return Column(
                                      children: const [
                                        Text(
                                          "220 mi",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40),
                                        ),
                                        Text(
                                          "60%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    );
                                  }),
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, topTextAnimation.value),
                                  child: Opacity(
                                      opacity: opacityAnimation.value,
                                      child: child),
                                );
                              })),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedBuilder(
                              animation: topTextAnimation,
                              child: Selector<TeslaProvider, int>(
                                  selector: (context, provider) =>
                                      provider.selectedIndex,
                                  builder: (context, value, child) {
                                    return AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOutBack,
                                      opacity: value == 1 ? 1 : 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                    );
                                  }),
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, bottomTextAnimation.value),
                                  child: Opacity(
                                      opacity: opacityAnimation.value,
                                      child: child),
                                );
                              })),
                      Align(
                        alignment: Alignment.center,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Selector<TeslaProvider, int>(
                                    selector: (context, provider) =>
                                        provider.selectedIndex,
                                    builder: (context, value, child) {
                                      return AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOutBack,
                                        opacity: value == 1 ? 1 : 0,
                                        child: SizedBox(
                                          height: constraints.maxHeight * .50,
                                          width: constraints.maxWidth * .50,
                                          child: SvgPicture.asset(
                                              Assets.iconsBattery),
                                        ),
                                      );
                                    }),
                                AnimatedBuilder(
                                    animation: topTextAnimation,
                                    child: Column(
                                      children: const [
                                        Text(
                                          "CHARGING",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "18 min remaining",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    builder: (context, child) {
                                      return Opacity(
                                        opacity: opacityAnimation.value,
                                        child: Transform.translate(
                                          offset:
                                              Offset(0, topTextAnimation.value),
                                          child: child,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                }),
          );
        });
  }
}
