import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/screens/tyre_screen/widgets/tyre_animation.dart';
import 'package:tesla_animation/screens/tyre_screen/widgets/tyre_details_animation.dart';

class TyreScreen extends StatefulWidget {
  const TyreScreen({Key? key}) : super(key: key);

  @override
  State<TyreScreen> createState() => _TyreScreenState();
}

class _TyreScreenState extends State<TyreScreen> with TickerProviderStateMixin {
  late AnimationController tyreController;
  late AnimationController cardController;
  late Animation<double> opacityAnimation;
  late Animation<double> tyreSlideAnimation;
  late List<Animation<double>> cardScaleAnimationList = [];

  final ValueNotifier<bool> screenVisibility = ValueNotifier(false);

  Animation<double> intervalAnimation(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: cardController,
      curve: Interval(begin, end, curve: Curves.easeInOutBack),
    ));
  }

  @override
  void initState() {
    super.initState();

    tyreController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    cardController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
        reverseDuration: Duration.zero);

    opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: tyreController,
      curve: Curves.linear,
    ));

    tyreSlideAnimation =
        Tween<double>(begin: 100.0, end: 0.0).animate(CurvedAnimation(
      parent: tyreController,
      curve: Curves.easeInOutBack,
    ));

    cardScaleAnimationList = [
      intervalAnimation(0.0, 0.25),
      intervalAnimation(0.25, 0.50),
      intervalAnimation(0.50, 0.75),
      intervalAnimation(0.75, 1.0),
    ];

    animationStatusListener();
  }

  animationStatusListener() {
    tyreController.addStatusListener((status) {
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
    tyreController.dispose();
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
                selector: (_, provider) => provider.selectedIndex,
                builder: (_, index, __) {
                  if (index == 3) {
                    tyreController.forward();
                    cardController.forward();
                  } else {
                    tyreController.reverse();
                    cardController.reverse();
                  }
                  return Stack(
                    children: [
                      TyreAnimation(
                          controller: tyreController,
                          opacityAnimation: opacityAnimation,
                          bottomTyreSlideAnimation: tyreSlideAnimation),
                      TyreDetailsAnimation(
                          cardController: cardController,
                          cardScaleAnimationList: cardScaleAnimationList),
                    ],
                  );
                }),
          );
        });
  }
}
