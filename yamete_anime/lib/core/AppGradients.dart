import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yamete_anime/core/AppColors.dart';

class AppGradients {

  static final linear01 = LinearGradient(
    colors: [
      Color(0xFF57B6E5),
      Color.fromRGBO(130, 87, 229, 0.695),
    ], stops: [
      0.0,
      0.695
    ], transform: GradientRotation(2.13959913 * pi)
  );

  static final linear02 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000),
      Color(0xFF131813),
    ]
  );

  static final linear03 = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF000000),
      Color(0xC42B2626),
    ]
  );

  static final linearCard = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0x94000000),
      Color(0x2C9C9B9B),
      Color(0x00FFFFFF),
    ]
  );




}
