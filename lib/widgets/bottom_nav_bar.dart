import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.grey.shade900,
        height: 50,
        child: Row(
          children: const [
            BottomNavBarItem(
              itemIndex: 0,
              asset: Assets.iconsLock,
            ),
            BottomNavBarItem(
              itemIndex: 1,
              asset: Assets.iconsCharge,
            ),
            BottomNavBarItem(
              itemIndex: 2,
              asset: Assets.iconsTemp,
            ),
            BottomNavBarItem(
              itemIndex: 3,
              asset: Assets.iconsTyre,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    super.key,
    required this.itemIndex,
    required this.asset,
  });

  final int itemIndex;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final teslaModel = context.read<TeslaProvider>();
    return Expanded(
        child: SizedBox.square(
      dimension: 30,
      child: InkWell(
        onTap: () {
          teslaModel.updateSelectedIndex(itemIndex);
        },
        child: Selector<TeslaProvider, int>(
            selector: (_, provider) => provider.selectedIndex,
            builder: (_, index, __) {
              return SvgPicture.asset(asset,
                  color: index == itemIndex ? Colors.cyanAccent : Colors.grey);
            }),
      ),
    ));
  }
}
