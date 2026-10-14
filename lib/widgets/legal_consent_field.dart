import 'package:flutter/material.dart';

import '../config/legal_config.dart';
import '../l10n/l10n.dart';
import '../screens/settings_screen.dart';

/// Kayıtta zorunlu KVKK / gizlilik onayı.
class LegalConsentField extends FormField<bool> {
  LegalConsentField({super.key})
      : super(
          initialValue: false,
          validator: (v) => v == true ? null : currentL10n.legalConsentRequired,
          builder: (state) {
            final context = state.context;
            final scheme = Theme.of(context).colorScheme;
            final l10n = context.l10n;
            final links = [
              if (LegalConfig.kvkkNoticeUrl.isNotEmpty)
                (l10n.privacyNotice, LegalConfig.kvkkNoticeUrl),
              if (LegalConfig.privacyPolicyUrl.isNotEmpty)
                (l10n.privacyPolicy, LegalConfig.privacyPolicyUrl),
              if (LegalConfig.termsUrl.isNotEmpty)
                (l10n.termsOfUse, LegalConfig.termsUrl),
            ];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: state.value ?? false,
                  onChanged: state.didChange,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    l10n.legalConsentText,
                    style: const TextStyle(fontSize: 13),
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
                    padding: const EdgeInsetsDirectional.only(start: 12),
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
