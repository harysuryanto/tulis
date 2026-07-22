import 'package:flutter/material.dart';

class NotionColors {
  // Light Palette
  static const lightCanvas = Color(0xFFFFFFFF);
  static const lightSidebar = Color(0xFFF7F6F3);
  static const lightTextPrimary = Color(0xFF37352F);
  static const lightTextMuted = Color(0xFF9B9A97);
  static const lightBorder = Color(0xFFEDECE9);
  static const lightHover = Color(0xFFEFEEEC);
  static const lightActive = Color(0xFFE8E7E3);

  // Dark Palette
  static const darkCanvas = Color(0xFF191919);
  static const darkSidebar = Color(0xFF202020);
  static const darkTextPrimary = Color(0xFFD4D4D4);
  static const darkTextMuted = Color(0xFF7B7B7B);
  static const darkBorder = Color(0xFF2F2F2F);
  static const darkHover = Color(0xFF2C2C2C);
  static const darkActive = Color(0xFF373737);
}

class NotionTheme {
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: NotionColors.lightCanvas,
      canvasColor: NotionColors.lightCanvas,
      cardColor: NotionColors.lightSidebar,
      dividerColor: NotionColors.lightBorder,
      colorScheme: const ColorScheme.light(
        surface: NotionColors.lightCanvas,
        surfaceContainerLow: NotionColors.lightSidebar,
        surfaceContainerLowest: NotionColors.lightCanvas,
        onSurface: NotionColors.lightTextPrimary,
        onSurfaceVariant: NotionColors.lightTextMuted,
        outline: NotionColors.lightBorder,
        outlineVariant: NotionColors.lightBorder,
        primary: NotionColors.lightTextPrimary,
        secondary: NotionColors.lightTextMuted,
      ),
      iconTheme: const IconThemeData(
        color: NotionColors.lightTextPrimary,
        size: 18,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(
            NotionColors.lightCanvas,
          ),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(6),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: NotionColors.lightBorder),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          ),
        ),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          minimumSize: const WidgetStatePropertyAll(Size(0, 28)),
          maximumSize: const WidgetStatePropertyAll(Size(double.infinity, 30)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: NotionColors.lightTextPrimary,
            ),
          ),
          foregroundColor: const WidgetStatePropertyAll(
            NotionColors.lightTextPrimary,
          ),
          overlayColor: const WidgetStatePropertyAll(NotionColors.lightHover),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: NotionColors.lightTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          color: NotionColors.lightTextPrimary,
          fontSize: 15,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: NotionColors.lightTextPrimary,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(color: NotionColors.lightTextMuted, fontSize: 12),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NotionColors.darkCanvas,
      canvasColor: NotionColors.darkCanvas,
      cardColor: NotionColors.darkSidebar,
      dividerColor: NotionColors.darkBorder,
      colorScheme: const ColorScheme.dark(
        surface: NotionColors.darkCanvas,
        surfaceContainerLow: NotionColors.darkSidebar,
        surfaceContainerLowest: NotionColors.darkCanvas,
        onSurface: NotionColors.darkTextPrimary,
        onSurfaceVariant: NotionColors.darkTextMuted,
        outline: NotionColors.darkBorder,
        outlineVariant: NotionColors.darkBorder,
        primary: NotionColors.darkTextPrimary,
        secondary: NotionColors.darkTextMuted,
      ),
      iconTheme: const IconThemeData(
        color: NotionColors.darkTextPrimary,
        size: 18,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(
            NotionColors.darkSidebar,
          ),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(6),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: NotionColors.darkBorder),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          ),
        ),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          minimumSize: const WidgetStatePropertyAll(Size(0, 28)),
          maximumSize: const WidgetStatePropertyAll(Size(double.infinity, 30)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: NotionColors.darkTextPrimary,
            ),
          ),
          foregroundColor: const WidgetStatePropertyAll(
            NotionColors.darkTextPrimary,
          ),
          overlayColor: const WidgetStatePropertyAll(NotionColors.darkHover),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: NotionColors.darkTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          color: NotionColors.darkTextPrimary,
          fontSize: 15,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: NotionColors.darkTextPrimary,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(color: NotionColors.darkTextMuted, fontSize: 12),
      ),
      useMaterial3: true,
    );
  }
}
