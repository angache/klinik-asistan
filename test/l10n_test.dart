import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klinik_asistan/l10n/l10n.dart';
import 'package:klinik_asistan/models/clinic.dart';

Map<String, dynamic> _arb(String code) => jsonDecode(
      File('lib/l10n/app_$code.arb').readAsStringSync(),
    ) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

final _placeholder = RegExp(r'\{(\w+)\}');

void main() {
  final template = _arb('en');
  final templateKeys = _messageKeys(template);

  for (final code in kLanguageNames.keys.where((c) => c != 'en')) {
    test('$code: tüm metinler çevrilmiş, yer tutucular aynı', () {
      final arb = _arb(code);
      expect(
        templateKeys.difference(_messageKeys(arb)),
        isEmpty,
        reason: 'app_$code.arb içinde eksik anahtar',
      );
      expect(
        _messageKeys(arb).difference(templateKeys),
        isEmpty,
        reason: 'app_$code.arb içinde şablonda olmayan anahtar',
      );
      for (final key in templateKeys) {
        final meta = template['@$key'] as Map<String, dynamic>?;
        final declared =
            (meta?['placeholders'] as Map<String, dynamic>?)?.keys ?? [];
        final message = arb[key] as String;
        for (final name in declared) {
          expect(
            message.contains('{$name}') || message.contains('{$name,'),
            isTrue,
            reason: '$code/$key içinde {$name} yok',
          );
        }
        if (declared.isEmpty) {
          expect(
            _placeholder.hasMatch(message),
            isFalse,
            reason: '$code/$key şablonda olmayan bir yer tutucu içeriyor',
          );
        }
      }
    });
  }

  test('desteklenen her dilin seçim listesinde adı var', () {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      kLanguageNames.keys.toSet(),
    );
  });

  group('resolveAppLocale', () {
    test('seçilen dil önceliklidir', () {
      expect(
        resolveAppLocale(const Locale('de'), const [Locale('tr', 'TR')]),
        const Locale('de'),
      );
    });

    test('seçim yoksa telefonun dili, bölge kodu atılır', () {
      expect(
        resolveAppLocale(null, const [Locale('fr', 'CA'), Locale('en')]),
        const Locale('fr'),
      );
    });

    test('desteklenmeyen telefon dilinde sıradaki desteklenen dil', () {
      expect(
        resolveAppLocale(null, const [Locale('ja'), Locale('es', 'MX')]),
        const Locale('es'),
      );
    });

    test('hiçbiri desteklenmiyorsa İngilizce', () {
      expect(resolveAppLocale(null, const [Locale('ja')]), const Locale('en'));
    });
  });

  test('rol etiketleri etkin dile göre değişir', () {
    setActiveLocale(const Locale('tr'));
    expect(ClinicRole.asistan.label, 'Asistan');
    setActiveLocale(const Locale('de'));
    expect(ClinicRole.asistan.label, 'Assistenz');
    setActiveLocale(const Locale('tr'));
  });
}
