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
        style: IconButton.styleFrom(
          foregroundColor: appTheme.color.onSurface,
        )
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
  const AppTextTheme({required this.body});

  factory AppTextTheme.normal() {
    return AppTextTheme(
      body: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  @override
  final TextStyle body;
}

@TailorMixinComponent()
class AppColorTheme extends ThemeExtension<AppColorTheme>
    with _$AppColorThemeTailorMixin {
  const AppColorTheme({
    required this.bg,
    required this.surface,
    required this.onSurface,
  });

  factory AppColorTheme.dark() {
    return AppColorTheme(
      bg: Color(0xFF202020),
      surface: Color(0xFF303030),
      onSurface: Color(0xFFFAFAFA),
    );
  }

  @override
  final Color bg;

  @override
  final Color surface;

  @override
  final Color onSurface;
}
