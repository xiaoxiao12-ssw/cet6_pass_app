import 'package:flutter/material.dart';

/// 护眼浅灰白背景 + 沉稳深蓝主色 · 极简克制设计系统
class AppColors {
  static const Color background = Color(0xFFF5F7FA); // 护眼浅灰白
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFEDF1F7);
  static const Color border = Color(0xFFE1E7EF);

  static const Color primary = Color(0xFF1B3A5C); // 沉稳深蓝
  static const Color primarySoft = Color(0xFFEAF0F6);
  static const Color accentBlue = Color(0xFF2B5B84);

  static const Color textPrimary = Color(0xFF1D2939);
  static const Color textSecondary = Color(0xFF526378);
  static const Color textMuted = Color(0xFF8896A6);

  static const Color success = Color(0xFF266D52);
  static const Color successSoft = Color(0xFFEAF5F0);

  static const Color warning = Color(0xFFB56B14);
  static const Color warningSoft = Color(0xFFFDF5E6);

  static const Color danger = Color(0xFFB33A3A);
  static const Color dangerSoft = Color(0xFFFBECEC);
}

class AppTheme {
  static ThemeData build() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accentBlue,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
