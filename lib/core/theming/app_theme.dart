import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/core/theming/app_colors.dart';

final appTheme = ThemeData(
  fontFamily: GoogleFonts.getFont("DM Sans").fontFamily,
  primaryColor: AppColors.primaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white
);
