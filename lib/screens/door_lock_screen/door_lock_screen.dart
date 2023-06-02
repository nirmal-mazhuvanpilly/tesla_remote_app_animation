import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/screens/door_lock_screen/widgets/door_lock.dart';

class DoorLockScreen extends StatefulWidget {
  const DoorLockScreen({
    super.key,
  });

  @override
  State<DoorLockScreen> createState() => _DoorLockScreenState();
}

class _DoorLockScreenState extends State<DoorLockScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> opacityAnimation;

  final ValueNotifier<bool> screenVisibility = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10));

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
    final teslaModel = context.read<TeslaProvider>();
    return ValueListenableBuilder<bool>(
        valueListenable: screenVisibility,
        child: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: SizedBox(
              height: constraints.maxHeight * .80,
              width: constraints.maxWidth * .80,
              child: Center(
                child: LayoutBuilder(builder: (context, subConstraints) {
                  return Selector<TeslaProvider, int>(
                      selector: (_, provider) => provider.selectedIndex,
                      builder: (_, index, __) {
                        if (index == 0) {
                          controller.forward();
                        } else {
                          controller.reverse();
                        }
                        return Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutBack,
                              top: index == 0
                                  ? subConstraints.maxHeight * .12
                                  : subConstraints.maxHeight / 2,
                              child: DoorLock(
                                selector: (context, provider) =>
                                    provider.isBonnetLock,
                                onTap: teslaModel.updateBonnetDoorLock,
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutBack,
                              top: index == 0
                                  ? subConstraints.maxHeight * .80
                                  : subConstraints.maxHeight / 2,
                              child: DoorLock(
                                selector: (context, provider) =>
                                    provider.isTrunkLock,
                                onTap: teslaModel.updateTrunkDoorLock,
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutBack,
                              top: subConstraints.maxHeight / 2,
                              left: index == 0
                                  ? subConstraints.maxWidth * .05
                                  : subConstraints.maxWidth / 2,
                              child: DoorLock(
                                selector: (context, provider) =>
                                    provider.isLeftDoorLock,
                                onTap: teslaModel.updateLeftDoorLock,
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutBack,
                              top: subConstraints.maxHeight / 2,
                              right: index == 0
                                  ? subConstraints.maxWidth * .05
                                  : subConstraints.maxWidth / 2,
                              child: DoorLock(
                                selector: (context, provider) =>
                                    provider.isRightDoorLock,
                                onTap: teslaModel.updateRightDoorLock,
                              ),
                            ),
                          ],
                        );
                      });
                }),
              ),
            ),
          );
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
