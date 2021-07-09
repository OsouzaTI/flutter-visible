import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

class WindowsConfigs {

  static Future windowsConfig() async {
    await DesktopWindow.setFullScreen(true);
    await DesktopWindow.setMinWindowSize(Size(860, 640));  
  }


}
