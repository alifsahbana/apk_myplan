import 'package:flutter/material.dart';

/// Design tokens untuk MyPlan sesuai DESIGN.md
/// 
/// Sistem warna blue gradient blur + glassmorphism
class AppColors {
  // Primary Colors - Blue Palette
  static const Color brandSky = Color(0xFF42BCEB);           // #42BCEB
  static const Color brandBlue = Color(0xFF179FD2);          // #179FD2
  static const Color brandBlueDark = Color(0xFF087FA8);      // #087FA8
  static const Color brandCyan = Color(0xFF64D5F2);          // #64D5F2

  // Gradient Colors
  static const Color gradientStart = Color(0xFFA8E5F8);      // #A8E5F8
  static const Color gradientMiddle = Color(0xFF63C8EF);     // #63C8EF
  static const Color gradientEnd = Color(0xFFD8F2FC);        // #D8F2FC

  // Background & Surface
  static const Color background = Color(0xFFF0F7FC);         // #F0F7FC (ice blue)
  static const Color surface = Color(0xFFFFFFFF);            // #FFFFFF
  static const Color surfaceSoft = Color(0xFFE7F4FA);        // #E7F4FA
  static const Color surfaceBlueTint = Color(0xFFDDF2FB);    // #DDF2FB

  // Text Colors
  static const Color textPrimary = Color(0xFF172B3A);        // #172B3A
  static const Color textSecondary = Color(0xFF5D7484);      // #5D7484
  static const Color textMuted = Color(0xFF72899A);          // #72899A

  // Border
  static const Color border = Color(0xFFD9E8F0);             // #D9E8F0
  static const Color borderLight = Color(0xFFECF5FF);        // Light border

  // Status Colors
  static const Color success = Color(0xFF16865C);            // #16865C
  static const Color warning = Color(0xFFB96B12);            // #B96B12
  static const Color danger = Color(0xFFC53D4B);             // #C53D4B

  // Gamification Colors
  static const Color streak = Color(0xFFF28C45);             // #F28C45 (Orange)
  static const Color xp = Color(0xFF258CCB);                 // #258CCB (Blue)
  static const Color level = Color(0xFF3478D4);              // #3478D4 (Blue)
  static const Color achievement = Color(0xFFD49A24);        // #D49A24 (Gold)
  static const Color reward = Color(0xFF8C70D6);             // #8C70D6 (Purple)

  // Aliases for easier use
  static const Color primaryDark = brandBlueDark;
  static const Color primary = brandBlue;
  static const Color primaryLight = brandSky;
}

/// Typography tokens sesuai DESIGN.md
class AppTypography {
  // Headline Large: 26px, 700, line-height 34px
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 34 / 26,
    letterSpacing: -0.015,
  );

  // Headline Medium: 20px, 600, line-height 28px
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.01,
  );

  // Headline Small: 17px, 600, line-height 24px
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 24 / 17,
  );

  // Body Large: 16px, 500, line-height 24px
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
  );

  // Body Medium: 14px, 400, line-height 20px
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  // Body Small: 13px, 400, line-height 18px
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
  );

  // Label Large: 15px, 600, line-height 20px
  static const TextStyle labelLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
  );

  // Label Medium: 13px, 600, line-height 18px
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
  );

  // Label Small: 11px, 600, line-height 16px
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 16 / 11,
    letterSpacing: 0.02,
  );

  // Caption: 12px, 400, line-height 16px
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );
}

/// Spacing tokens
class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double gutter = 16;
  static const double gutterSm = 12;
}

/// Border radius tokens
class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double full = 9999;
}

/// Shadow definitions
class AppShadows {
  static const BoxShadow sm = BoxShadow(
    color: Color.fromARGB(13, 0, 0, 0),
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const BoxShadow md = BoxShadow(
    color: Color.fromARGB(20, 0, 0, 0),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color.fromARGB(25, 0, 0, 0),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  // Blue-tinted shadow for primary elements
  static const BoxShadow blueSm = BoxShadow(
    color: Color.fromARGB(20, 23, 159, 210),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
}
