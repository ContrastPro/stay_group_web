import 'package:flutter/material.dart';

import '../models/calculations/calculation_period_model.dart';

enum BlocStatus { initial, loading, loaded, success, failed }

enum DateDifference { seconds, minutes, days }

const String kDatePattern = 'dd/MM/yy';

// Min file weight 1 MB
const int kFileWeightMin = 1048576;

// Max file weight 10 MB
const int kFileWeightMax = 10485760;

const double kMobileScreenWidth = 600.0;

const double kTabletScreenWidth = 840.0;

const double kLaptopScreenWidth = 1024.0;

const double kDesktopScreenWidth = 1280.0;

const List<String> kImageFormats = ['jpg', 'jpeg', 'png'];

const List<String> kCurrencies = ['€', '\$', '£', '¥', '₹'];

const List<CalculationPeriodModel> kPeriods = [
  CalculationPeriodModel(
    month: 1,
    name: 'every_month',
  ),
  CalculationPeriodModel(
    month: 3,
    name: 'every_quarter',
  ),
  CalculationPeriodModel(
    month: 6,
    name: 'every_six_months',
  ),
];

const Duration kDebugRequestDuration = Duration(milliseconds: 50);

const Duration kProdRequestDuration = Duration(milliseconds: 1200);

const Duration kAnimationDuration = Duration(milliseconds: 250);

const Duration kFadeInDuration = Duration(milliseconds: 350);

const Curve kCurveAnimations = Curves.linear;
