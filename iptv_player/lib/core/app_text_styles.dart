import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle titleBold = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyBold = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodyWhite20 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyWhite16 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static final TextStyle body11 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle body8 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 8,
    fontWeight: FontWeight.normal,
  );
}
