import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen>
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
    final teslaModel = context.read<TeslaProvider>();
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
                  if (value == 2) {
                    Future.delayed(const Duration(milliseconds: 0), () {
                      controller.forward();
                    });
                  } else {
                    controller.reverse();
                  }
                  return Stack(
                    children: [
                      AnimatedBuilder(
                          animation: topTextAnimation,
                          child: Selector<TeslaProvider, int>(
                              selector: (context, provider) =>
                                  provider.selectedIndex,
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Selector<TeslaProvider, bool>(
                                              selector: (context, provider) =>
                                                  provider.isCool,
                                              builder: (context, value, child) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    teslaModel.setCool();
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    350),
                                                        curve: Curves
                                                            .easeInOutBack,
                                                        height: value ? 75 : 50,
                                                        width: value ? 75 : 50,
                                                        child: SvgPicture.asset(
                                                          Assets.iconsCoolShape,
                                                          color:
                                                              Colors.cyanAccent,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      const Text(
                                                        "COOL",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .cyanAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                          const SizedBox(width: 10),
                                          Selector<TeslaProvider, bool>(
                                              selector: (context, provider) =>
                                                  provider.isHot,
                                              builder: (context, value, child) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    teslaModel.setHot();
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    250),
                                                        curve: Curves
                                                            .easeInOutBack,
                                                        height: value ? 75 : 50,
                                                        width: value ? 75 : 50,
                                                        child: SizedBox.square(
                                                          dimension:
                                                              value ? 75 : 50,
                                                          child:
                                                              SvgPicture.asset(
                                                            Assets
                                                                .iconsHeatShape,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      const Text(
                                                        "HOT",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .redAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                teslaModel
                                                    .increaseTemperature();
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_up,
                                                size: 48,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Selector<TeslaProvider, int>(
                                                selector: (context, provider) =>
                                                    provider.temperature,
                                                builder:
                                                    (context, value, child) {
                                                  return Text(
                                                    "$value° C",
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 80),
                                                  );
                                                }),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                teslaModel
                                                    .decreaseTemperature();
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                size: 48,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "CURRENT TEMPERATURE",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    "INSIDE",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "20° C",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                children: const [
                                                  Text(
                                                    "OUTSIDE",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "35° C",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                );
                              }),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, topTextAnimation.value),
                              child: Opacity(
                                  opacity: opacityAnimation.value,
                                  child: child),
                            );
                          }),
                      Selector<TeslaProvider, int>(
                          selector: (context, provider) =>
                              provider.selectedIndex,
                          builder: (context, value, child) {
                            return value == 2
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Selector<TeslaProvider, bool>(
                                        selector: (context, provider) =>
                                            provider.isCool,
                                        builder: (context, value, child) {
                                          return Image.asset(value
                                              ? Assets.imagesCoolGlow2
                                              : Assets.imagesHotGlow4);
                                        }),
                                  )
                                : const SizedBox.shrink();
                          }),
                    ],
                  );
                }),
          );
        });
  }
}
