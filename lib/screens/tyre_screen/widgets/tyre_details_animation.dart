import 'package:flutter/material.dart';
import 'package:tesla_animation/tyre_model.dart';

class TyreDetailsAnimation extends StatelessWidget {
  const TyreDetailsAnimation({
    super.key,
    required this.cardController,
    required this.cardScaleAnimationList,
  });

  final AnimationController cardController;
  final List<Animation<double>> cardScaleAnimationList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio:
                    (constraints.maxWidth) / (constraints.maxHeight - 50),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: tyreList.length,
            itemBuilder: (BuildContext ctx, index) {
              final item = tyreList.elementAt(index);
              return AnimatedBuilder(
                animation: cardController,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: (item.isLow ?? true)
                          ? Colors.redAccent.withOpacity(.10)
                          : Colors.cyanAccent.withOpacity(.10),
                      border: Border.all(
                          color: (item.isLow ?? true)
                              ? Colors.redAccent
                              : Colors.cyanAccent)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.tyrePressure}psi",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${item.temperature}°C",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      if (item.isLow ?? true)
                        RichText(
                          text: const TextSpan(
                            text: 'LOW\n',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'PRESSURE',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                builder: (context, child) {
                  return Transform.scale(
                      scale: cardScaleAnimationList[index].value, child: child);
                },
              );
            });
      }),
    );
  }
}
