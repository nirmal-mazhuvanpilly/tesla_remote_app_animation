import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class DoorLockScreen extends StatelessWidget {
  const DoorLockScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final teslaModel = context.read<TeslaProvider>();
    return Selector<TeslaProvider, bool>(
        selector: (context, provider) => provider.doorLockScreenVisibility,
        builder: (context, value, child) {
          return Visibility(
            visible: value,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: LayoutBuilder(builder: (context, constraints) {
              return Center(
                child: Selector<TeslaProvider, int>(
                    selector: (context, provider) => provider.selectedIndex,
                    builder: (context, value, child) {
                      return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutBack,
                            top: value == 0
                                ? constraints.maxHeight * .12
                                : constraints.maxHeight / 2,
                            child: DoorLock(
                              selector: (context, provider) =>
                                  provider.isBonnetLock,
                              onTap: teslaModel.updateBonnetDoorLock,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutBack,
                            bottom: value == 0
                                ? constraints.maxHeight * .18
                                : constraints.maxHeight / 2,
                            child: DoorLock(
                              selector: (context, provider) =>
                                  provider.isTrunkLock,
                              onTap: teslaModel.updateTrunkDoorLock,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutBack,
                            left: value == 0
                                ? constraints.maxWidth * .05
                                : constraints.maxWidth / 2,
                            child: DoorLock(
                              selector: (context, provider) =>
                                  provider.isLeftDoorLock,
                              onTap: teslaModel.updateLeftDoorLock,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutBack,
                            right: value == 0
                                ? constraints.maxWidth * .05
                                : constraints.maxWidth / 2,
                            child: DoorLock(
                              selector: (context, provider) =>
                                  provider.isRightDoorLock,
                              onTap: teslaModel.updateRightDoorLock,
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }),
          );
        });
  }
}

class DoorLock extends StatelessWidget {
  final bool Function(BuildContext, TeslaProvider) selector;
  final void Function()? onTap;
  const DoorLock({super.key, required this.selector, this.onTap});

  @override
  Widget build(BuildContext context) {
    final teslaModel = context.read<TeslaProvider>();
    return Selector<TeslaProvider, int>(
        selector: (context, provider) => provider.selectedIndex,
        builder: (context, value, child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutBack,
            opacity: value == 0 ? 1 : 0,
            onEnd: () {
              if (value != 0) {
                teslaModel.changeDoorLockScreenVisibility(false);
              }
            },
            child: Selector<TeslaProvider, bool>(
                selector: selector,
                builder: (context, value, child) {
                  return GestureDetector(
                    onTap: onTap,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        final tween = Tween<double>(begin: 0, end: 1)
                            .chain(CurveTween(curve: Curves.easeInOutBack));
                        return ScaleTransition(
                            scale: animation.drive(tween), child: child);
                      },
                      child: value
                          ? SvgPicture.asset(
                              key: const ValueKey("Door Lock"),
                              Assets.iconsDoorLock,
                            )
                          : SvgPicture.asset(
                              key: const ValueKey("Door Unlock"),
                              Assets.iconsDoorUnlock,
                            ),
                    ),
                  );
                }),
          );
        });
  }
}
