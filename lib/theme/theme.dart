import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'theme.tailor.dart';

@TailorMixin()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeTailorMixin {
  const AppTheme({required this.text, required this.color});

  factory AppTheme.dark() {
    return AppTheme(text: AppTextTheme.normal(), color: AppColorTheme.dark());
  }

  static ThemeData buildTheme() {
    final appTheme = AppTheme.dark();

    var darkTheme = ThemeData.dark(useMaterial3: true);
    return darkTheme.copyWith(
      scaffoldBackgroundColor: appTheme.color.bg,
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: appTheme.color.onSurface),
      ),
      textTheme: TextTheme(
        titleLarge: appTheme.text.title,
        titleMedium: appTheme.text.subtitle,
        titleSmall: appTheme.text.subtitle,
        bodyLarge: appTheme.text.body,
        bodyMedium: appTheme.text.body,
        bodySmall: appTheme.text.body,
        labelLarge: appTheme.text.label,
        labelMedium: appTheme.text.label,
        labelSmall: appTheme.text.label,
      ),
      extensions: [appTheme],
    );
  }

  @override
  final AppTextTheme text;

  @override
  final AppColorTheme color;
}

@TailorMixinComponent()
class AppTextTheme extends ThemeExtension<AppTextTheme>
    with _$AppTextThemeTailorMixin {
  const AppTextTheme({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.label,
  });

  factory AppTextTheme.normal() {
    return AppTextTheme(
      title: GoogleFonts.rubik(fontSize: 20, fontWeight: FontWeight.w600),
      subtitle: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w500),
      body: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w400),
      label: GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }

  @override
  final TextStyle title;

  @override
  final TextStyle subtitle;

  @override
  final TextStyle body;

  @override
  final TextStyle label;
}

@TailorMixinComponent()
class AppColorTheme extends ThemeExtension<AppColorTheme>
    with _$AppColorThemeTailorMixin {
  const AppColorTheme({
    required this.bg,
    required this.surface,
    required this.onSurfaceDimmed,
    required this.onSurface,
    required this.error,
    required this.success,
  });

  factory AppColorTheme.dark() {
    return AppColorTheme(
      bg: Color(0xFF202020),
      surface: Color(0xFF303030),
      onSurfaceDimmed: Color(0xFF909090),
      onSurface: Color(0xFFFAFAFA),
      error: Color(0xFFE02020),
      success: Color(0xFF20E020),
    );
  }

  @override
  final Color bg;

  @override
  final Color surface;

  @override
  final Color onSurfaceDimmed;

  @override
  final Color onSurface;

  @override
  final Color error;

  final Color success;
}
