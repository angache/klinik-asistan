import 'package:flutter_test/flutter_test.dart';

import 'package:klinik_asistan/widgets/tooth_selector.dart';

void main() {
  test('formatToothSelection empty', () {
    expect(formatToothSelection({}), '');
  });
}
