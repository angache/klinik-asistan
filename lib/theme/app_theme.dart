import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// WhatsApp benzeri açık / koyu tema.
class AppTheme {
  // WhatsApp yeşilleri
  static const Color waGreen = Color(0xFF25D366);
  static const Color waTeal = Color(0xFF00A884);
  static const Color waHeaderLight = Color(0xFF008069);
  static const Color waHeaderDark = Color(0xFF1F2C34);
  /// Sesli not — parlak WhatsApp yeşili (seans teal'inden ayrı)
  static const Color voiceAccent = waGreen;
  static const Color voiceAccentDark = Color(0xFF1FA855);

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: waHeaderLight,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFD1F4E0),
      onPrimaryContainer: Color(0xFF054C3E),
      secondary: waTeal,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFD9FDD3),
      onSecondaryContainer: Color(0xFF0B3D32),
      tertiary: waGreen,
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFE7FCE3),
      onTertiaryContainer: Color(0xFF0B3D1F),
      error: Color(0xFFEA0038),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF111B21),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF0F2F5),
      surfaceContainer: Color(0xFFE9EDEF),
      surfaceContainerHigh: Color(0xFFE9EDEF),
      surfaceContainerHighest: Color(0xFFD1D7DB),
      onSurfaceVariant: Color(0xFF667781),
      outline: Color(0xFF8696A0),
      outlineVariant: Color(0xFFD1D7DB),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF233138),
      onInverseSurface: Color(0xFFE9EDEF),
      inversePrimary: waTeal,
      surfaceTint: waHeaderLight,
    );

    return _base(scheme, scaffold: const Color(0xFFF0F2F5)).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: waHeaderLight,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: waTeal,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: waTeal,
      onPrimary: Color(0xFF00382E),
      primaryContainer: Color(0xFF005C4B),
      onPrimaryContainer: Color(0xFFD1F4E0),
      secondary: Color(0xFF25D366),
      onSecondary: Color(0xFF00381A),
      secondaryContainer: Color(0xFF005C4B),
      onSecondaryContainer: Color(0xFFD9FDD3),
      tertiary: waGreen,
      onTertiary: Color(0xFF00381A),
      tertiaryContainer: Color(0xFF1F3C34),
      onTertiaryContainer: Color(0xFFD1F4E0),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF111B21),
      onSurface: Color(0xFFE9EDEF),
      surfaceContainerLowest: Color(0xFF0B141A),
      surfaceContainerLow: Color(0xFF111B21),
      surfaceContainer: Color(0xFF1F2C34),
      surfaceContainerHigh: Color(0xFF2A3942),
      surfaceContainerHighest: Color(0xFF2A3942),
      onSurfaceVariant: Color(0xFF8696A0),
      outline: Color(0xFF667781),
      outlineVariant: Color(0xFF3B4A54),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE9EDEF),
      onInverseSurface: Color(0xFF111B21),
      inversePrimary: waHeaderLight,
      surfaceTint: waTeal,
    );

    return _base(scheme, scaffold: const Color(0xFF0B141A)).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: waHeaderDark,
        foregroundColor: Color(0xFFE9EDEF),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color(0xFFE9EDEF),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFE9EDEF)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: waTeal,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _base(ColorScheme scheme, {required Color scaffold}) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF1F2C34) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark
                ? const Color(0xFF2A3942)
                : const Color(0xFFE9EDEF),
          ),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(
          isDark ? const Color(0xFF1F2C34) : Colors.white,
        ),
        elevation: const WidgetStatePropertyAll(0),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(color: scheme.onSurfaceVariant),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: scheme.onSurface),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2A3942) : const Color(0xFFF0F2F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: isDark ? Colors.white : Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        selectedColor: isDark
            ? const Color(0xFF005C4B)
            : const Color(0xFFD1F4E0),
        checkmarkColor: isDark ? waGreen : waHeaderLight,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF1F2C34) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
      ),
    );
  }
}
