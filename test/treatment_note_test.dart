import 'package:flutter_test/flutter_test.dart';

import 'package:klinik_asistan/models/clinic_todo.dart';
import 'package:klinik_asistan/models/treatment_note.dart';
import 'package:klinik_asistan/widgets/edit_session_dialog.dart';

void main() {
  group('parseKanalBoyu', () {
    test('boşluklu kanal adları ve virgüllü değerler korunur', () {
      expect(
        parseKanalBoyu('MB: 19mm, MB 2: 19,5mm, P: 21.5mm'),
        {'MB': '19', 'MB 2': '19,5', 'P': '21.5'},
      );
    });

    test('boş girdi', () {
      expect(parseKanalBoyu(null), isEmpty);
      expect(parseKanalBoyu('  '), isEmpty);
    });
  });

  group('nextRecurrenceDate', () {
    test('aylık: ay sonu sıkıştırılır', () {
      expect(
        nextRecurrenceDate(
            DateTime(2026, 1, 31, 9, 30), TodoRecurrence.monthly),
        DateTime(2026, 2, 28, 9, 30),
      );
      expect(
        nextRecurrenceDate(DateTime(2028, 1, 31), TodoRecurrence.monthly),
        DateTime(2028, 2, 29),
      );
      expect(
        nextRecurrenceDate(DateTime(2026, 12, 15), TodoRecurrence.monthly),
        DateTime(2027, 1, 15),
      );
    });

    test('günlük ve haftalık ay/yıl sınırını geçer', () {
      expect(
        nextRecurrenceDate(DateTime(2026, 12, 31, 8), TodoRecurrence.daily),
        DateTime(2027, 1, 1, 8),
      );
      expect(
        nextRecurrenceDate(DateTime(2026, 2, 25), TodoRecurrence.weekly),
        DateTime(2026, 3, 4),
      );
    });
  });

  test('TreatmentNoteInput RPC payload', () {
    final json = TreatmentNoteInput(
      hastaId: 'h1',
      kapsam: TreatmentScope.tumAgiz,
      disNo: '11',
      islemBaslik: 'Temizlik',
      notIcerik: '',
      fotografUrls: const ['a.jpg', 'b.jpg'],
      labBeklenenTarih: DateTime(2026, 3, 4),
    ).toRpcJson(klinikId: 'k1');

    expect(json['klinik_id'], 'k1');
    expect(json['dis_no'], isNull);
    expect(json['fotograf_url'], 'a.jpg');
    expect(json['fotograf_urls'], ['a.jpg', 'b.jpg']);
    expect(json['lab_beklenen_tarih'], '2026-03-04');
    expect(json.containsKey('tarih'), isFalse);
  });
}
