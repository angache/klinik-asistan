import 'package:flutter/material.dart';

import '../config/legal_config.dart';
import '../screens/settings_screen.dart';

/// Kayıtta zorunlu KVKK / gizlilik onayı.
class LegalConsentField extends FormField<bool> {
  LegalConsentField({super.key})
      : super(
          initialValue: false,
          validator: (v) =>
              v == true ? null : 'Devam etmek için onaylamanız gerekir',
          builder: (state) {
            final context = state.context;
            final scheme = Theme.of(context).colorScheme;
            final links = [
              if (LegalConfig.kvkkNoticeUrl.isNotEmpty)
                ('KVKK aydınlatma metni', LegalConfig.kvkkNoticeUrl),
              if (LegalConfig.privacyPolicyUrl.isNotEmpty)
                ('Gizlilik politikası', LegalConfig.privacyPolicyUrl),
              if (LegalConfig.termsUrl.isNotEmpty)
                ('Kullanım koşulları', LegalConfig.termsUrl),
            ];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: state.value ?? false,
                  onChanged: state.didChange,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'KVKK aydınlatma metnini, gizlilik politikasını ve '
                    'kullanım koşullarını okudum; hasta verilerini yalnızca '
                    'teşhis ve tedavi hizmeti amacıyla, KVKK\'ya uygun '
                    'şekilde işleyeceğimi kabul ediyorum.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                if (links.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final (title, url) in links)
                        TextButton(
                          onPressed: () => openExternalUrl(context, url),
                          child: Text(title),
                        ),
                    ],
                  ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: scheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}
