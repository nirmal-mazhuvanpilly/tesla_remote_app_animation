import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animation/generated/assets.dart';

class TyreAnimation extends StatelessWidget {
  const TyreAnimation({
    super.key,
    required this.controller,
    required this.opacityAnimation,
    required this.bottomTyreSlideAnimation,
  });

  final AnimationController controller;
  final Animation<double> opacityAnimation;
  final Animation<double> bottomTyreSlideAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SizedBox(
            height: constraints.maxHeight * .80,
            width: constraints.maxWidth * .80,
            child: LayoutBuilder(builder: (context, subConstraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: subConstraints.maxHeight * .13,
                    left: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.white),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(-bottomTyreSlideAnimation.value,
                                    -bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  ),
                  Positioned(
                    top: subConstraints.maxHeight * .13,
                    right: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.white),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(bottomTyreSlideAnimation.value,
                                    -bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  ),
                  Positioned(
                    bottom: subConstraints.maxHeight * .20,
                    left: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.white),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(-bottomTyreSlideAnimation.value,
                                    bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  ),
                  Positioned(
                    bottom: subConstraints.maxHeight * .20,
                    right: subConstraints.maxWidth * .12,
                    child: AnimatedBuilder(
                      animation: controller,
                      child: SizedBox(
                        height: constraints.maxHeight * .10,
                        width: constraints.maxWidth * .10,
                        child: SvgPicture.asset(Assets.iconsFLTyre,
                            color: Colors.white),
                      ),
                      builder: (context, child) {
                        return Opacity(
                            opacity: opacityAnimation.value,
                            child: Transform.translate(
                                offset: Offset(bottomTyreSlideAnimation.value,
                                    bottomTyreSlideAnimation.value),
                                child: child));
                      },
                    ),
                  )
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
