import 'package:flutter/material.dart';

class NoAnimationTabController extends TabController {
  NoAnimationTabController({
    required super.initialIndex,
    required super.length,
    required super.vsync,
  });

  @override      //int value, { Duration? duration, Curve curve = Curves.ease }
  void animateTo(int value, {Duration? duration = Duration.zero, Curve curve = Curves.ease}) {
    super.animateTo(value, duration: Duration.zero, curve: curve);
  }
}