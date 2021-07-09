import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AppGradients {
  static final linear = LinearGradient(colors: [
    Color(0xFF57B6E5),
    Color.fromRGBO(130, 87, 229, 0.695),
  ], stops: [
    0.0,
    0.695
  ], transform: GradientRotation(2.13959913 * pi));
  
  static final linear02 = LinearGradient(colors: [
    Color(0xFF185170),
    Color(0xFF1F6083),
  ], stops: [
    0.0,
    0.695
  ], transform: GradientRotation(2.13959913 * pi));


}
