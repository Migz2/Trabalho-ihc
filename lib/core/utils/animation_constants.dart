import 'package:flutter/material.dart';

/// Centralized animation timing and easing for the whole app.
/// Keeps motion consistent across screens instead of ad-hoc durations.
class AnimationDurations {
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration crawl = Duration(milliseconds: 800);

  AnimationDurations._();
}

class AnimationCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;

  AnimationCurves._();
}
