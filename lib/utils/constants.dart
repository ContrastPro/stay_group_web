import 'package:flutter/material.dart';

enum BlocStatus { initial, loading, loaded, success, failed }

enum DateDifference { seconds, minutes, days }

const BorderRadius kCircleRadius = BorderRadius.all(
  Radius.circular(100.0),
);

const Duration kDebugRequestDuration = Duration(milliseconds: 50);

const Duration kProdRequestDuration = Duration(milliseconds: 1400);

const Duration kAnimationDuration = Duration(milliseconds: 800);

const Duration kFadeInDuration = Duration(milliseconds: 350);

const Curve kCurveAnimations = Curves.easeInBack;
