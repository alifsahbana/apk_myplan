import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppColors - Design tokens sesuai DESIGN.md
/// Blue Gradient Blur + Glassmorphism system
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
  static const Color cardBg = Color(0xFFFFFFFF);             // Alias untuk surface

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
  static const Color streak = Color(0xFFF28C45);             // #F28C45 (Orange/Fire)
  static const Color xp = Color(0xFF258CCB);                 // #258CCB (Blue)
  static const Color level = Color(0xFF3478D4);              // #3478D4 (Blue)
  static const Color achievement = Color(0xFFD49A24);        // #D49A24 (Gold)
  static const Color reward = Color(0xFF8C70D6);             // #8C70D6 (Purple)

  // Aliases for easier use
  static const Color primaryDark = brandBlueDark;
  static const Color primary = brandBlue;
  static const Color primaryLight = brandSky;
  
  // Legacy aliases (old green theme references) - for backward compatibility
  static const Color streakOrange = streak;
  
  // Legacy green theme colors (for existing screens/widgets)
  // These are kept for backward compatibility during transition
  static const Color highFocusBg = Color(0xFFFFECE5);
  static const Color highFocusText = Color(0xFFD9480F);
  static const Color highFocusBorder = Color(0xFFFFD8A8);
  
  static const Color mediumBg = Color(0xFFE7F5FF);
  static const Color mediumText = Color(0xFF1C7ED6);
  static const Color mediumBorder = Color(0xFFD0EBFF);
  
  static const Color chillBg = Color(0xFFEBFBEE);
  static const Color chillText = Color(0xFF2B8A3E);
  static const Color chillBorder = Color(0xFFD3F9D8);
  
  static const Color primarySage = Color(0xFF2D6A4F);
  static const Color accentGreen = Color(0xFF52B788);
  
  static const Color streakBg = Color(0xFFFFF0EB);
  static const Color borderSubtle = Color(0xFFF0F2F5);
  static const Color cardSubtle = Color(0xFFF1F4F6);
}

/// MyPlan App Theme
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      
      // Primary color
      primaryColor: AppColors.brandBlue,
      colorScheme: ColorScheme.light(
        primary: AppColors.brandBlue,
        onPrimary: Colors.white,
        primaryContainer: AppColors.brandSky,
        onPrimaryContainer: AppColors.textPrimary,
        secondary: AppColors.brandCyan,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
        onError: Colors.white,
      ),

      // Typography
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.31,
          letterSpacing: -0.39,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
          letterSpacing: -0.2,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.41,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.43,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
          height: 1.38,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.22,
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      dividerColor: AppColors.border,
    );
  }
}

