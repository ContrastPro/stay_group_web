import 'package:flutter/material.dart';

enum BlocStatus { initial, loading, loaded, success, failed }

const BorderRadius kCircleRadius = BorderRadius.all(
  Radius.circular(100.0),
);

const Duration kAnimationDuration = Duration(milliseconds: 800);

const Duration kFadeInDuration = Duration(milliseconds: 350);

const Curve kCurveAnimations = Curves.easeInBack;
