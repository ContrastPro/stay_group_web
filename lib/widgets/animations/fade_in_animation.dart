import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    super.key,
    this.curve = kCurveAnimations,
    this.duration = kFadeInDuration,
    required this.child,
  });

  final Curve curve;
  final Duration duration;
  final Widget child;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  @override
  void dispose() {
    _setDisposeData();
    super.dispose();
  }

  void _setInitialData() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  void _setDisposeData() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
