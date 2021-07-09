import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yamete_winx/core/AppColors.dart';

class AppTextStyles {

  static final TextStyle font20 = GoogleFonts.notoSans(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle titleMangaCard = GoogleFonts.notoSans(
    color: Colors.white,    
    shadows: <Shadow>[
      Shadow(
        offset: Offset(5.0, 5.0),
        blurRadius: 3.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      Shadow(
        offset: Offset(6.0, 6.0),
        blurRadius: 6.0,
        color: Color.fromARGB(125, 0, 0, 255),

      ),
    ],
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle yameteLabel = GoogleFonts.roboto(
    color: Colors.white,    
    fontSize: 60,
    fontWeight: FontWeight.w600,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(3.0, 3.0),
        blurRadius: 1.5,
        color: AppColors.iconColor,
      ),
    ],
  );

  static final TextStyle labelIcon = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle chapterTileText = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final Color snackBarColorIcon = Colors.white;
  static final TextStyle snackBarTitle = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle snackBarMessage = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static final TextStyle chapterSubTileText = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 12,
    fontWeight: FontWeight.w200,
  );

  static final TextStyle dropdownHint = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle dropdownCategory = GoogleFonts.notoSans(
    color: Colors.white,    
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

}