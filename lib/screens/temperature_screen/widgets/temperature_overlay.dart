import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class TemperatureOverlay extends StatelessWidget {
  const TemperatureOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TeslaProvider, int>(
        selector: (_, provider) => provider.selectedIndex,
        child: Align(
          alignment: Alignment.centerRight,
          child: Selector<TeslaProvider, bool>(
              selector: (_, provider) => provider.isCool,
              builder: (_, value, __) {
                return Image.asset(
                    value ? Assets.imagesCoolGlow2 : Assets.imagesHotGlow4);
              }),
        ),
        builder: (_, value, child) {
          return value == 2 ? child! : const SizedBox.shrink();
        });
  }
}
