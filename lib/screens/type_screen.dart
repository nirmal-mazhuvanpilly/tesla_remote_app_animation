import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/tyre_model.dart';

class TyreScreen extends StatefulWidget {
  const TyreScreen({Key? key}) : super(key: key);

  @override
  State<TyreScreen> createState() => _TyreScreenState();
}

class _TyreScreenState extends State<TyreScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController cardController;
  late Animation<double> opacityAnimation;
  late Animation<double> tyreSlideAnimation;
  late List<Animation<double>> listCardScale = [];

  final ValueNotifier<bool> screenVisibility = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    cardController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
        reverseDuration: Duration.zero);

    opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    tyreSlideAnimation =
        Tween<double>(begin: 100.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    ));

    listCardScale.add(
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: cardController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOutBack),
      )),
    );
    listCardScale.add(
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: cardController,
        curve: const Interval(0.25, 0.5, curve: Curves.easeInOutBack),
      )),
    );
    listCardScale.add(
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: cardController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeInOutBack),
      )),
    );
    listCardScale.add(
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: cardController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOutBack),
      )),
    );

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
    cardController.dispose();
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
                  if (value == 3) {
                    Future.delayed(const Duration(milliseconds: 0), () {
                      controller.forward();
                      cardController.forward();
                    });
                  } else {
                    controller.reverse();
                    cardController.reverse();
                  }
                  return Stack(
                    children: [
                      TyreAnimation(
                          controller: controller,
                          opacityAnimation: opacityAnimation,
                          bottomTyreSlideAnimation: tyreSlideAnimation),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: (constraints.maxWidth) /
                                          (constraints.maxHeight - 50),
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: tyreList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                final item = tyreList.elementAt(index);
                                return AnimatedBuilder(
                                  animation: cardController,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: (item.isLow ?? true)
                                            ? Colors.redAccent.withOpacity(.10)
                                            : Colors.cyanAccent
                                                .withOpacity(.10),
                                        border: Border.all(
                                            color: (item.isLow ?? true)
                                                ? Colors.redAccent
                                                : Colors.cyanAccent)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${item.tyrePressure}psi",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "${item.temperature}°C",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        if (item.isLow ?? true)
                                          RichText(
                                            text: const TextSpan(
                                              text: 'LOW\n',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'PRESSURE',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  builder: (context, child) {
                                    return Transform.scale(
                                        scale: listCardScale[index].value,
                                        child: child);
                                  },
                                );
                              });
                        }),
                      ),
                    ],
                  );
                }),
          );
        });
  }
}

class TyreAnimation extends StatelessWidget {
  const TyreAnimation({
    super.key,
    required this.controller,
    required this.opacityAnimation,
    required this.bottomTyreSlideAnimation,
  });

  final AnimationController controller;
  final Animation<double> opacityAnimation;
  final Animation<double> bottomTyreSlideAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SizedBox(
            height: constraints.maxHeight * .80,
            width: constraints.maxWidth * .80,
            child: LayoutBuilder(builder: (context, subConstraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: subConstraints.maxHeight * .13,
                    left: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.cyanAccent),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(-bottomTyreSlideAnimation.value,
                                    -bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  ),
                  Positioned(
                    top: subConstraints.maxHeight * .13,
                    right: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.cyanAccent),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(bottomTyreSlideAnimation.value,
                                    -bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  ),
                  Positioned(
                    bottom: subConstraints.maxHeight * .20,
                    left: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.cyanAccent),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(-bottomTyreSlideAnimation.value,
                                    bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  ),
                  Positioned(
                    bottom: subConstraints.maxHeight * .20,
                    right: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.cyanAccent),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(bottomTyreSlideAnimation.value,
                                    bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  )
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
