import 'package:flutter/material.dart';

class AppTheme {
  final String id;
  final String name;
  final Color textColor;
  final Color? solid;
  final Gradient? gradient;
  final String? imageUrl;

  AppTheme(
      {required this.id,
      required this.name,
      required this.textColor,
      this.gradient,
      this.solid,
      this.imageUrl})
      : assert(gradient != null || solid != null || imageUrl != null);

  bool get isSolid => solid != null;
  bool get isGradient => gradient != null;
  bool get isImage => imageUrl != null;
}
