import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';

class SetTemperature extends StatelessWidget {
  const SetTemperature({super.key});

  @override
  Widget build(BuildContext context) {
    final teslaModel = context.read<TeslaProvider>();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              teslaModel.increaseTemperature();
            },
            icon: const Icon(
              Icons.arrow_drop_up,
              size: 48,
              color: Colors.white,
            ),
          ),
          Selector<TeslaProvider, int>(
              selector: (_, provider) => provider.temperature,
              builder: (_, value, __) {
                return Text(
                  "$value° C",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 80),
                );
              }),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              teslaModel.decreaseTemperature();
            },
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
