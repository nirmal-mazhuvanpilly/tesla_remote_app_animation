import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class CarView extends StatefulWidget {
  const CarView({
    super.key,
  });

  @override
  State<CarView> createState() => _CarViewState();
}

class _CarViewState extends State<CarView> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    slideAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TeslaProvider, int>(
        selector: (_, provider) => provider.selectedIndex,
        child: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: AnimatedBuilder(
                animation: slideAnimation,
                child: SizedBox(
                  height: constraints.maxHeight * .80,
                  width: constraints.maxWidth * .80,
                  child: SvgPicture.asset(Assets.iconsCar),
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        (constraints.maxWidth / 2) * slideAnimation.value, 0),
                    child: child,
                  );
                }),
          );
        }),
        builder: (_, index, child) {
          if (index == 2) {
            controller.forward();
          } else {
            controller.reverse();
          }
          return child!;
        });
  }
}
