import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Renk paleti seçenekleri.
enum AppColorPalette {
  /// Soft slate-mavi klinik görünüm.
  clinic,

  /// Derin okyanus cyan.
  ocean,

  /// Mat tıbbi adaçayı.
  sage,

  /// Soğuk grafit + buz mavisi.
  graphite,

  /// Klasik yeşil (eski WhatsApp benzeri).
  classic,
}

extension AppColorPaletteX on AppColorPalette {
  String get label => switch (this) {
        AppColorPalette.clinic => 'Klinik mavi',
        AppColorPalette.ocean => 'Okyanus',
        AppColorPalette.sage => 'Adaçayı',
        AppColorPalette.graphite => 'Grafit',
        AppColorPalette.classic => 'Klasik yeşil',
      };

  String get description => switch (this) {
        AppColorPalette.clinic => 'Sakin, klinik slate-mavi',
        AppColorPalette.ocean => 'Derin cyan, ferah klinik',
        AppColorPalette.sage => 'Mat yeşil, yumuşak tıbbi',
        AppColorPalette.graphite => 'Nötr grafit, buz mavisi vurgu',
        AppColorPalette.classic => 'Canlı yeşil vurgu',
      };

  Color get previewColor => switch (this) {
        AppColorPalette.clinic => AppTheme.clinicBlue,
        AppColorPalette.ocean => AppTheme.oceanPrimary,
        AppColorPalette.sage => AppTheme.sagePrimary,
        AppColorPalette.graphite => AppTheme.graphitePrimary,
        AppColorPalette.classic => AppTheme.classicHeader,
      };

  static AppColorPalette fromName(String? raw) {
    for (final p in AppColorPalette.values) {
      if (p.name == raw) return p;
    }
    return AppColorPalette.clinic;
  }
}

/// Klinik Asistan temaları — iki palet × açık/koyu.
class AppTheme {
  AppTheme._();

  /// Aktif palet (MaterialApp yeniden kurulunca güncellenir).
  static AppColorPalette activePalette = AppColorPalette.clinic;

  // ── Klinik mavi ──────────────────────────────────────────
  static const Color clinicBlue = Color(0xFF2B5C7A);
  static const Color clinicBlueSoft = Color(0xFF4A7C9B);
  static const Color clinicBluePale = Color(0xFFD6E6F0);
  static const Color clinicInk = Color(0xFF1A2A36);
  static const Color clinicDarkScaffold = Color(0xFF10151C);
  static const Color clinicDarkSurface = Color(0xFF171D26);
  static const Color clinicDarkCard = Color(0xFF1E2630);
  static const Color clinicDarkElevated = Color(0xFF283140);

  // ── Klasik yeşil ─────────────────────────────────────────
  static const Color classicGreen = Color(0xFF25D366);
  static const Color classicTeal = Color(0xFF00A884);
  static const Color classicHeader = Color(0xFF008069);
  static const Color classicDarkHeader = Color(0xFF1F2C34);
  static const Color classicDarkScaffold = Color(0xFF0B141A);
  static const Color classicDarkSurface = Color(0xFF111B21);
  static const Color classicDarkCard = Color(0xFF1F2C34);
  static const Color classicDarkElevated = Color(0xFF2A3942);

  // ── Okyanus ──────────────────────────────────────────────
  static const Color oceanPrimary = Color(0xFF0E7490);
  static const Color oceanSoft = Color(0xFF155E75);
  static const Color oceanPale = Color(0xFFCFFAFE);
  static const Color oceanDarkScaffold = Color(0xFF0B1220);
  static const Color oceanDarkSurface = Color(0xFF111B2E);
  static const Color oceanDarkCard = Color(0xFF1A2740);
  static const Color oceanDarkElevated = Color(0xFF243552);

  // ── Adaçayı ──────────────────────────────────────────────
  static const Color sagePrimary = Color(0xFF4F6F52);
  static const Color sageSoft = Color(0xFF6B8F71);
  static const Color sagePale = Color(0xFFDCE8DD);
  static const Color sageDarkScaffold = Color(0xFF121612);
  static const Color sageDarkSurface = Color(0xFF1A1F1A);
  static const Color sageDarkCard = Color(0xFF242A24);
  static const Color sageDarkElevated = Color(0xFF303830);

  // ── Grafit ───────────────────────────────────────────────
  static const Color graphitePrimary = Color(0xFF3D4F5F);
  static const Color graphiteAccent = Color(0xFF5B8DEF);
  static const Color graphitePale = Color(0xFFE2E8F0);
  static const Color graphiteDarkScaffold = Color(0xFF0C0E12);
  static const Color graphiteDarkSurface = Color(0xFF14171C);
  static const Color graphiteDarkCard = Color(0xFF1C2128);
  static const Color graphiteDarkElevated = Color(0xFF2A313C);

  /// Sesli not vurgusu — aktif palete göre.
  static Color get voiceAccent => voiceAccentFor(activePalette);
  static Color get voiceAccentDark => voiceAccentDarkFor(activePalette);

  static Color voiceAccentFor(AppColorPalette palette) => switch (palette) {
        AppColorPalette.clinic => const Color(0xFFD97706),
        AppColorPalette.ocean => const Color(0xFFF59E0B),
        AppColorPalette.sage => const Color(0xFFC2410C),
        AppColorPalette.graphite => graphiteAccent,
        AppColorPalette.classic => classicGreen,
      };

  static Color voiceAccentDarkFor(AppColorPalette palette) =>
      switch (palette) {
        AppColorPalette.clinic => const Color(0xFFB45309),
        AppColorPalette.ocean => const Color(0xFFD97706),
        AppColorPalette.sage => const Color(0xFF9A3412),
        AppColorPalette.graphite => const Color(0xFF3B6FD4),
        AppColorPalette.classic => const Color(0xFF1FA855),
      };

  static ThemeData light([AppColorPalette palette = AppColorPalette.clinic]) {
    return switch (palette) {
      AppColorPalette.clinic => _clinicLight(),
      AppColorPalette.ocean => _oceanLight(),
      AppColorPalette.sage => _sageLight(),
      AppColorPalette.graphite => _graphiteLight(),
      AppColorPalette.classic => _classicLight(),
    };
  }

  static ThemeData dark([AppColorPalette palette = AppColorPalette.clinic]) {
    return switch (palette) {
      AppColorPalette.clinic => _clinicDark(),
      AppColorPalette.ocean => _oceanDark(),
      AppColorPalette.sage => _sageDark(),
      AppColorPalette.graphite => _graphiteDark(),
      AppColorPalette.classic => _classicDark(),
    };
  }

  // ── Klinik light / dark ──────────────────────────────────

  static ThemeData _clinicLight() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: clinicBlue,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: clinicBluePale,
      onPrimaryContainer: Color(0xFF16384C),
      secondary: clinicBlueSoft,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE4EEF5),
      onSecondaryContainer: Color(0xFF1A3A4E),
      tertiary: Color(0xFFB45309),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFDE8CD),
      onTertiaryContainer: Color(0xFF5C2E05),
      error: Color(0xFFB42318),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE4E2),
      onErrorContainer: Color(0xFF7A271A),
      surface: Color(0xFFFFFFFF),
      onSurface: clinicInk,
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF5F7F9),
      surfaceContainer: Color(0xFFEEF2F5),
      surfaceContainerHigh: Color(0xFFE6EBEF),
      surfaceContainerHighest: Color(0xFFDCE3E9),
      onSurfaceVariant: Color(0xFF5A6B78),
      outline: Color(0xFF8A9AA8),
      outlineVariant: Color(0xFFD0D8E0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF243040),
      onInverseSurface: Color(0xFFEEF2F5),
      inversePrimary: Color(0xFF8BBAD4),
      surfaceTint: clinicBlue,
    );

    return _base(
      scheme,
      scaffold: const Color(0xFFF3F5F7),
      cardColor: Colors.white,
      cardBorder: const Color(0xFFE2E8EE),
      searchFill: Colors.white,
      inputFill: const Color(0xFFF0F3F6),
      chipSelected: clinicBluePale,
      chipCheck: clinicBlue,
      dialogBg: Colors.white,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.clinic,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: clinicBlue,
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
        backgroundColor: clinicBlue,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _clinicDark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7EB4D0),
      onPrimary: Color(0xFF0F2A3A),
      primaryContainer: Color(0xFF2A4A60),
      onPrimaryContainer: Color(0xFFD6E6F0),
      secondary: Color(0xFF9BC0D6),
      onSecondary: Color(0xFF0F2A3A),
      secondaryContainer: Color(0xFF2E3F4E),
      onSecondaryContainer: Color(0xFFD6E6F0),
      tertiary: Color(0xFFF0B060),
      onTertiary: Color(0xFF3D2200),
      tertiaryContainer: Color(0xFF5C3A12),
      onTertiaryContainer: Color(0xFFFDE8CD),
      error: Color(0xFFF97066),
      onError: Color(0xFF55160C),
      errorContainer: Color(0xFF912018),
      onErrorContainer: Color(0xFFFEE4E2),
      surface: clinicDarkSurface,
      onSurface: Color(0xFFE6EBF0),
      surfaceContainerLowest: clinicDarkScaffold,
      surfaceContainerLow: clinicDarkSurface,
      surfaceContainer: clinicDarkCard,
      surfaceContainerHigh: clinicDarkElevated,
      surfaceContainerHighest: clinicDarkElevated,
      onSurfaceVariant: Color(0xFF9AA8B5),
      outline: Color(0xFF6B7A88),
      outlineVariant: Color(0xFF3A4654),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6EBF0),
      onInverseSurface: Color(0xFF171D26),
      inversePrimary: clinicBlue,
      surfaceTint: Color(0xFF7EB4D0),
    );

    return _base(
      scheme,
      scaffold: clinicDarkScaffold,
      cardColor: clinicDarkCard,
      cardBorder: clinicDarkElevated,
      searchFill: clinicDarkCard,
      inputFill: clinicDarkElevated,
      chipSelected: const Color(0xFF2A4A60),
      chipCheck: const Color(0xFF7EB4D0),
      dialogBg: clinicDarkCard,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.clinic,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF2A4A60),
        foregroundColor: Color(0xFFD6E6F0),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color(0xFFD6E6F0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFD6E6F0)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF7EB4D0),
        foregroundColor: Color(0xFF0F2A3A),
        elevation: 3,
      ),
    );
  }

  // ── Okyanus light / dark ─────────────────────────────────

  static ThemeData _oceanLight() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: oceanPrimary,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: oceanPale,
      onPrimaryContainer: Color(0xFF083344),
      secondary: oceanSoft,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE0F7FA),
      onSecondaryContainer: Color(0xFF0E4A5C),
      tertiary: Color(0xFFD97706),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFEF3C7),
      onTertiaryContainer: Color(0xFF78350F),
      error: Color(0xFFB42318),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE4E2),
      onErrorContainer: Color(0xFF7A271A),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0F172A),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF0F9FF),
      surfaceContainer: Color(0xFFE8F4F8),
      surfaceContainerHigh: Color(0xFFDCEEF4),
      surfaceContainerHighest: Color(0xFFCFE5ED),
      onSurfaceVariant: Color(0xFF4B6470),
      outline: Color(0xFF7A96A3),
      outlineVariant: Color(0xFFC5D8E0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1E293B),
      onInverseSurface: Color(0xFFF1F5F9),
      inversePrimary: Color(0xFF67E8F9),
      surfaceTint: oceanPrimary,
    );

    return _base(
      scheme,
      scaffold: const Color(0xFFF0F7FA),
      cardColor: Colors.white,
      cardBorder: const Color(0xFFD5E8EF),
      searchFill: Colors.white,
      inputFill: const Color(0xFFEAF4F8),
      chipSelected: oceanPale,
      chipCheck: oceanPrimary,
      dialogBg: Colors.white,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.ocean,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: oceanPrimary,
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
        backgroundColor: oceanPrimary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _oceanDark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF22D3EE),
      onPrimary: Color(0xFF083344),
      primaryContainer: Color(0xFF155E75),
      onPrimaryContainer: Color(0xFFCFFAFE),
      secondary: Color(0xFF67E8F9),
      onSecondary: Color(0xFF083344),
      secondaryContainer: Color(0xFF164E63),
      onSecondaryContainer: Color(0xFFCFFAFE),
      tertiary: Color(0xFFFBBF24),
      onTertiary: Color(0xFF422006),
      tertiaryContainer: Color(0xFF78350F),
      onTertiaryContainer: Color(0xFFFEF3C7),
      error: Color(0xFFF97066),
      onError: Color(0xFF55160C),
      errorContainer: Color(0xFF912018),
      onErrorContainer: Color(0xFFFEE4E2),
      surface: oceanDarkSurface,
      onSurface: Color(0xFFE2E8F0),
      surfaceContainerLowest: oceanDarkScaffold,
      surfaceContainerLow: oceanDarkSurface,
      surfaceContainer: oceanDarkCard,
      surfaceContainerHigh: oceanDarkElevated,
      surfaceContainerHighest: oceanDarkElevated,
      onSurfaceVariant: Color(0xFF94A3B8),
      outline: Color(0xFF64748B),
      outlineVariant: Color(0xFF334155),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE2E8F0),
      onInverseSurface: Color(0xFF0F172A),
      inversePrimary: oceanPrimary,
      surfaceTint: Color(0xFF22D3EE),
    );

    return _base(
      scheme,
      scaffold: oceanDarkScaffold,
      cardColor: oceanDarkCard,
      cardBorder: oceanDarkElevated,
      searchFill: oceanDarkCard,
      inputFill: oceanDarkElevated,
      chipSelected: const Color(0xFF155E75),
      chipCheck: const Color(0xFF22D3EE),
      dialogBg: oceanDarkCard,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.ocean,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF155E75),
        foregroundColor: Color(0xFFCFFAFE),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color(0xFFCFFAFE),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFCFFAFE)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF22D3EE),
        foregroundColor: Color(0xFF083344),
        elevation: 3,
      ),
    );
  }

  // ── Adaçayı light / dark ─────────────────────────────────

  static ThemeData _sageLight() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: sagePrimary,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: sagePale,
      onPrimaryContainer: Color(0xFF243528),
      secondary: sageSoft,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE8F0E9),
      onSecondaryContainer: Color(0xFF2F4633),
      tertiary: Color(0xFFC2410C),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFEDD5),
      onTertiaryContainer: Color(0xFF7C2D12),
      error: Color(0xFFB42318),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE4E2),
      onErrorContainer: Color(0xFF7A271A),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1C241E),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF5F7F4),
      surfaceContainer: Color(0xFFEEF2EC),
      surfaceContainerHigh: Color(0xFFE4EBE3),
      surfaceContainerHighest: Color(0xFFD8E2D7),
      onSurfaceVariant: Color(0xFF586558),
      outline: Color(0xFF879487),
      outlineVariant: Color(0xFFCDD6CC),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2A332B),
      onInverseSurface: Color(0xFFEEF2EC),
      inversePrimary: Color(0xFFA3C0A7),
      surfaceTint: sagePrimary,
    );

    return _base(
      scheme,
      scaffold: const Color(0xFFF3F5F1),
      cardColor: Colors.white,
      cardBorder: const Color(0xFFDCE4DA),
      searchFill: Colors.white,
      inputFill: const Color(0xFFEEF2EC),
      chipSelected: sagePale,
      chipCheck: sagePrimary,
      dialogBg: Colors.white,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.sage,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: sagePrimary,
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
        backgroundColor: sagePrimary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _sageDark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA3C0A7),
      onPrimary: Color(0xFF1C2E20),
      primaryContainer: Color(0xFF3A523D),
      onPrimaryContainer: Color(0xFFDCE8DD),
      secondary: Color(0xFFB7CFB9),
      onSecondary: Color(0xFF1C2E20),
      secondaryContainer: Color(0xFF334538),
      onSecondaryContainer: Color(0xFFDCE8DD),
      tertiary: Color(0xFFFB923C),
      onTertiary: Color(0xFF431407),
      tertiaryContainer: Color(0xFF9A3412),
      onTertiaryContainer: Color(0xFFFFEDD5),
      error: Color(0xFFF97066),
      onError: Color(0xFF55160C),
      errorContainer: Color(0xFF912018),
      onErrorContainer: Color(0xFFFEE4E2),
      surface: sageDarkSurface,
      onSurface: Color(0xFFE6EBE6),
      surfaceContainerLowest: sageDarkScaffold,
      surfaceContainerLow: sageDarkSurface,
      surfaceContainer: sageDarkCard,
      surfaceContainerHigh: sageDarkElevated,
      surfaceContainerHighest: sageDarkElevated,
      onSurfaceVariant: Color(0xFFA3B0A4),
      outline: Color(0xFF6F7C70),
      outlineVariant: Color(0xFF3A453B),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6EBE6),
      onInverseSurface: Color(0xFF1C241E),
      inversePrimary: sagePrimary,
      surfaceTint: Color(0xFFA3C0A7),
    );

    return _base(
      scheme,
      scaffold: sageDarkScaffold,
      cardColor: sageDarkCard,
      cardBorder: sageDarkElevated,
      searchFill: sageDarkCard,
      inputFill: sageDarkElevated,
      chipSelected: const Color(0xFF3A523D),
      chipCheck: const Color(0xFFA3C0A7),
      dialogBg: sageDarkCard,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.sage,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF3A523D),
        foregroundColor: Color(0xFFDCE8DD),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color(0xFFDCE8DD),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFDCE8DD)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFA3C0A7),
        foregroundColor: Color(0xFF1C2E20),
        elevation: 3,
      ),
    );
  }

  // ── Grafit light / dark ──────────────────────────────────

  static ThemeData _graphiteLight() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: graphitePrimary,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: graphitePale,
      onPrimaryContainer: Color(0xFF1E293B),
      secondary: graphiteAccent,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFDBEAFE),
      onSecondaryContainer: Color(0xFF1E3A5F),
      tertiary: Color(0xFF5B8DEF),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFDBEAFE),
      onTertiaryContainer: Color(0xFF1E3A5F),
      error: Color(0xFFB42318),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE4E2),
      onErrorContainer: Color(0xFF7A271A),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1E293B),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF8FAFC),
      surfaceContainer: Color(0xFFF1F5F9),
      surfaceContainerHigh: Color(0xFFE2E8F0),
      surfaceContainerHighest: Color(0xFFCBD5E1),
      onSurfaceVariant: Color(0xFF64748B),
      outline: Color(0xFF94A3B8),
      outlineVariant: Color(0xFFCBD5E1),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1E293B),
      onInverseSurface: Color(0xFFF1F5F9),
      inversePrimary: Color(0xFF93C5FD),
      surfaceTint: graphitePrimary,
    );

    return _base(
      scheme,
      scaffold: const Color(0xFFF1F5F9),
      cardColor: Colors.white,
      cardBorder: const Color(0xFFE2E8F0),
      searchFill: Colors.white,
      inputFill: const Color(0xFFF1F5F9),
      chipSelected: graphitePale,
      chipCheck: graphitePrimary,
      dialogBg: Colors.white,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.graphite,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: graphitePrimary,
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
        backgroundColor: graphiteAccent,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _graphiteDark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF93C5FD),
      onPrimary: Color(0xFF0F172A),
      primaryContainer: Color(0xFF334155),
      onPrimaryContainer: Color(0xFFE2E8F0),
      secondary: Color(0xFF7BA6F5),
      onSecondary: Color(0xFF0F172A),
      secondaryContainer: Color(0xFF1E3A5F),
      onSecondaryContainer: Color(0xFFDBEAFE),
      tertiary: Color(0xFF7BA6F5),
      onTertiary: Color(0xFF0F172A),
      tertiaryContainer: Color(0xFF1E3A5F),
      onTertiaryContainer: Color(0xFFDBEAFE),
      error: Color(0xFFF97066),
      onError: Color(0xFF55160C),
      errorContainer: Color(0xFF912018),
      onErrorContainer: Color(0xFFFEE4E2),
      surface: graphiteDarkSurface,
      onSurface: Color(0xFFE2E8F0),
      surfaceContainerLowest: graphiteDarkScaffold,
      surfaceContainerLow: graphiteDarkSurface,
      surfaceContainer: graphiteDarkCard,
      surfaceContainerHigh: graphiteDarkElevated,
      surfaceContainerHighest: graphiteDarkElevated,
      onSurfaceVariant: Color(0xFF94A3B8),
      outline: Color(0xFF64748B),
      outlineVariant: Color(0xFF334155),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE2E8F0),
      onInverseSurface: Color(0xFF0F172A),
      inversePrimary: graphitePrimary,
      surfaceTint: Color(0xFF93C5FD),
    );

    return _base(
      scheme,
      scaffold: graphiteDarkScaffold,
      cardColor: graphiteDarkCard,
      cardBorder: graphiteDarkElevated,
      searchFill: graphiteDarkCard,
      inputFill: graphiteDarkElevated,
      chipSelected: const Color(0xFF334155),
      chipCheck: const Color(0xFF93C5FD),
      dialogBg: graphiteDarkCard,
      buttonRadius: 12,
      chipRadius: 10,
      palette: AppColorPalette.graphite,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF334155),
        foregroundColor: Color(0xFFE2E8F0),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color(0xFFE2E8F0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFE2E8F0)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF7BA6F5),
        foregroundColor: Color(0xFF0F172A),
        elevation: 3,
      ),
    );
  }

  // ── Klasik yeşil light / dark ────────────────────────────

  static ThemeData _classicLight() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: classicHeader,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFD1F4E0),
      onPrimaryContainer: Color(0xFF054C3E),
      secondary: classicTeal,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFD9FDD3),
      onSecondaryContainer: Color(0xFF0B3D32),
      tertiary: classicGreen,
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
      inversePrimary: classicTeal,
      surfaceTint: classicHeader,
    );

    return _base(
      scheme,
      scaffold: const Color(0xFFF0F2F5),
      cardColor: Colors.white,
      cardBorder: const Color(0xFFE9EDEF),
      searchFill: Colors.white,
      inputFill: const Color(0xFFF0F2F5),
      chipSelected: const Color(0xFFD1F4E0),
      chipCheck: classicHeader,
      dialogBg: Colors.white,
      buttonRadius: 24,
      chipRadius: 20,
      palette: AppColorPalette.classic,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: classicHeader,
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
        backgroundColor: classicTeal,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _classicDark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: classicTeal,
      onPrimary: Color(0xFF00382E),
      primaryContainer: Color(0xFF005C4B),
      onPrimaryContainer: Color(0xFFD1F4E0),
      secondary: Color(0xFF25D366),
      onSecondary: Color(0xFF00381A),
      secondaryContainer: Color(0xFF005C4B),
      onSecondaryContainer: Color(0xFFD9FDD3),
      tertiary: classicGreen,
      onTertiary: Color(0xFF00381A),
      tertiaryContainer: Color(0xFF1F3C34),
      onTertiaryContainer: Color(0xFFD1F4E0),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: classicDarkSurface,
      onSurface: Color(0xFFE9EDEF),
      surfaceContainerLowest: classicDarkScaffold,
      surfaceContainerLow: classicDarkSurface,
      surfaceContainer: classicDarkCard,
      surfaceContainerHigh: classicDarkElevated,
      surfaceContainerHighest: classicDarkElevated,
      onSurfaceVariant: Color(0xFF8696A0),
      outline: Color(0xFF667781),
      outlineVariant: Color(0xFF3B4A54),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE9EDEF),
      onInverseSurface: Color(0xFF111B21),
      inversePrimary: classicHeader,
      surfaceTint: classicTeal,
    );

    return _base(
      scheme,
      scaffold: classicDarkScaffold,
      cardColor: classicDarkCard,
      cardBorder: classicDarkElevated,
      searchFill: classicDarkCard,
      inputFill: classicDarkElevated,
      chipSelected: const Color(0xFF005C4B),
      chipCheck: classicGreen,
      dialogBg: classicDarkCard,
      buttonRadius: 24,
      chipRadius: 20,
      palette: AppColorPalette.classic,
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF005C4B),
        foregroundColor: Color(0xFFD1F4E0),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color(0xFFD1F4E0),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFFD1F4E0)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: classicTeal,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
    );
  }

  static ThemeData _base(
    ColorScheme scheme, {
    required Color scaffold,
    required Color cardColor,
    required Color cardBorder,
    required Color searchFill,
    required Color inputFill,
    required Color chipSelected,
    required Color chipCheck,
    required Color dialogBg,
    required double buttonRadius,
    required double chipRadius,
    required AppColorPalette palette,
  }) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cardBorder),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(searchFill),
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
        fillColor: inputFill,
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
          foregroundColor: isDark && palette != AppColorPalette.classic
              ? scheme.onPrimary
              : Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(chipRadius),
        ),
        selectedColor: chipSelected,
        checkmarkColor: chipCheck,
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
        backgroundColor: dialogBg,
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
