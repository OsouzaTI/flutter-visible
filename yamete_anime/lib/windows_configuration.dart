import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

class WindowsConfigs {

  static Future windowsConfig() async {
    Size size = await DesktopWindow.getWindowSize();
    print(size);
    // await DesktopWindow.setWindowSize(Size(1366,768));
    await DesktopWindow.setMinWindowSize(Size(1366,768));
    
  }


}
