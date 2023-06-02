import 'package:flutter/material.dart';

class CurrentTemperature extends StatelessWidget {
  const CurrentTemperature({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CURRENT TEMPERATURE",
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            _BuildColumn(text: "INSIDE", temp: "20° C"),
            SizedBox(width: 10),
            _BuildColumn(text: "OUTSIDE", temp: "35° C"),
          ],
        )
      ],
    );
  }
}

class _BuildColumn extends StatelessWidget {
  final String text;
  final String temp;
  const _BuildColumn({required this.text, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
        ),
        Text(
          temp,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
        ),
      ],
    );
  }
}
