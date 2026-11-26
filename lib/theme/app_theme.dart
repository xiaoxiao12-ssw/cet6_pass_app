import 'package:flutter/material.dart';

/// 六级必过通 v1.0 现代教育科技美学规范
/// - 护眼浅米白底色 (#F8F6F1) + 活力克莱因蓝 (#1B4DFF)
/// - 支持一键切换夜间护眼深色模式 (#0D1321)
class AppTheme {
  // 主色调：克莱因蓝 & 提分强调色
  static const Color kleinBlue = Color(0xFF1B4DFF);
  static const Color kleinBlueLight = Color(0xFF4C7BFF);
  static const Color kleinTint = Color(0xFFEEF3FF);
  static const Color mintGreen = Color(0xFF10B981);
  static const Color warmAmber = Color(0xFFF59E0B);
  static const Color coralRed = Color(0xFFF43F5E);
  static const Color violetAccent = Color(0xFF7C3AED);

  // 护眼日间模式色阶
  static const Color lightBg = Color(0xFFF8F6F1); // 温暖护眼浅米白
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSubtle = Color(0xFFF0EDE6);
  static const Color lightText = Color(0xFF141B2D);
  static const Color lightSubtext = Color(0xFF647087);

  // 护眼夜间模式色阶
  static const Color darkBg = Color(0xFF0D1321);
  static const Color darkCard = Color(0xFF161E31);
  static const Color darkSubtle = Color(0xFF1F2A42);
  static const Color darkText = Color(0xFFF4F2EC);
  static const Color darkSubtext = Color(0xFF94A3B8);

  static Color primary(bool isDark) => isDark ? kleinBlueLight : kleinBlue;
  static Color textPrimary(bool isDark) => isDark ? darkText : lightText;
  static Color textSecondary(bool isDark) => isDark ? darkSubtext : lightSubtext;
  static Color surface(bool isDark) => isDark ? darkCard : lightCard;
  static Color subtle(bool isDark) => isDark ? darkSubtle : lightSubtle;

  /// 无生硬边框的高级分层卡片装饰
  static BoxDecoration cardDecoration(
    bool isDark, {
    double radius = 22,
    Color? color,
    Color? shadowColor,
  }) {
    return BoxDecoration(
      color: color ?? surface(isDark),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? (isDark ? Colors.black : const Color(0xFF1B4DFF)))
              .withOpacity(isDark ? 0.26 : 0.06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration pillDecoration(bool isDark, {double radius = 14, Color? color}) {
    return BoxDecoration(
      color: color ?? subtle(isDark),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: kleinBlue,
        secondary: mintGreen,
        tertiary: warmAmber,
        surface: lightCard,
        onPrimary: Colors.white,
        onSurface: lightText,
      ),
      scaffoldBackgroundColor: lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: lightText,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: lightText),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightText,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: kleinBlueLight,
        secondary: mintGreen,
        tertiary: warmAmber,
        surface: darkCard,
        onPrimary: Colors.white,
        onSurface: darkText,
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: darkText,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: darkText),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSubtle,
        contentTextStyle: const TextStyle(color: darkText, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
