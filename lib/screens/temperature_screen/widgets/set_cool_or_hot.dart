import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class SetCoolOrHot extends StatelessWidget {
  const SetCoolOrHot({super.key});

  @override
  Widget build(BuildContext context) {
    final teslaModel = context.read<TeslaProvider>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Selector<TeslaProvider, bool>(
            selector: (_, provider) => provider.isCool,
            builder: (_, value, __) {
              return _TempWidget(
                  value: value,
                  text: "COOL",
                  asset: Assets.iconsCoolShape,
                  color: Colors.cyanAccent,
                  onTap: () {
                    teslaModel.setCool();
                  });
            }),
        const SizedBox(width: 10),
        Selector<TeslaProvider, bool>(
            selector: (_, provider) => provider.isHot,
            builder: (_, value, __) {
              return _TempWidget(
                  value: value,
                  text: "HOT",
                  asset: Assets.iconsHeatShape,
                  color: Colors.redAccent,
                  onTap: () {
                    teslaModel.setHot();
                  });
            }),
      ],
    );
  }
}

class _TempWidget extends StatelessWidget {
  final bool value;
  final void Function()? onTap;
  final String text;
  final String asset;
  final Color color;
  const _TempWidget({
    required this.value,
    required this.text,
    required this.asset,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutBack,
            height: value ? 75 : 50,
            width: value ? 75 : 50,
            child: SvgPicture.asset(
              asset,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
