import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class DoorLock extends StatelessWidget {
  final bool Function(BuildContext, TeslaProvider) selector;
  final void Function()? onTap;
  const DoorLock({
    super.key,
    required this.selector,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TeslaProvider, bool>(
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
        });
  }
}
