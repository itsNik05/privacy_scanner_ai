import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final heading = GoogleFonts.syne(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static final title = GoogleFonts.syne(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static final subtitle = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
  );

  static final smallMuted = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.text3,
  );

  static final statValue = GoogleFonts.syne(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
}
