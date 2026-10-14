// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get emailInvalid => 'Gültige E-Mail eingeben';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordMinLength => 'Mindestens 6 Zeichen';

  @override
  String get fullNameLabel => 'Vor- und Nachname';

  @override
  String get fullNameRequired => 'Name ist erforderlich';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get settingsAndAccount => 'Einstellungen und Konto';

  @override
  String linkOpenFailed(String url) {
    return 'Link konnte nicht geöffnet werden: $url';
  }

  @override
  String clinicCodeCopied(String code) {
    return 'Praxiscode kopiert: $code';
  }

  @override
  String get userFallback => 'Benutzer';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleDoctor => 'Zahnarzt';

  @override
  String get roleAssistant => 'Assistenz';

  @override
  String get joinStatusPending => 'Wartet auf Bestätigung';

  @override
  String get joinStatusApproved => 'Bestätigt';

  @override
  String get joinStatusRejected => 'Abgelehnt';

  @override
  String get loginSubtitle => 'Anmelden';

  @override
  String get forgotPassword => 'Passwort vergessen';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get loginCreateAccount => 'Konto erstellen / Praxis beitreten';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get clinicRequiredTitle => 'Praxis erforderlich';

  @override
  String get serverUnreachableTitle => 'Server nicht erreichbar';

  @override
  String get serverUnreachableBody =>
      'Prüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get signupTitle => 'Registrieren';

  @override
  String get createClinic => 'Praxis anlegen';

  @override
  String get joinClinic => 'Praxis beitreten';

  @override
  String get signupCreateIntro =>
      'Sie legen eine neue Praxis an und werden Administrator und Zahnarzt. Assistenzkräfte laden Sie mit dem Praxiscode ein.';

  @override
  String get clinicNameLabel => 'Name der Praxis';

  @override
  String get clinicNameRequired => 'Name der Praxis ist erforderlich';

  @override
  String get alreadyHaveAccount => 'Ich habe bereits ein Konto';

  @override
  String get signupJoinIntro =>
      'Senden Sie mit dem Praxiscode vom Administrator eine Beitrittsanfrage. Nach der Bestätigung erhalten Sie Zugriff.';

  @override
  String get clinicCodeLabel => 'Praxiscode';

  @override
  String get clinicCodeHint => 'z. B. A3K9PX';

  @override
  String get clinicCodeRequired => 'Code ist erforderlich';

  @override
  String get myRole => 'Meine Rolle';

  @override
  String get joinButton => 'Beitreten';

  @override
  String get resetCodeSent =>
      'Falls die Adresse registriert ist, wurde ein Code an Ihre E-Mail gesendet';

  @override
  String get passwordUpdated => 'Ihr Passwort wurde geändert';

  @override
  String get resetIntroEmail =>
      'Geben Sie die E-Mail-Adresse Ihres Kontos ein; wir senden Ihnen einen Code zum Zurücksetzen.';

  @override
  String get resetIntroCode =>
      'Geben Sie den Code aus der E-Mail und Ihr neues Passwort ein.';

  @override
  String get resetCodeLabel => 'Code';

  @override
  String get resetCodeInvalid => 'Code aus der E-Mail eingeben';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get newPasswordRepeatLabel => 'Neues Passwort (wiederholen)';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get updatePasswordButton => 'Passwort ändern';

  @override
  String get sendCodeButton => 'Code senden';

  @override
  String get resetRequestNewCode => 'Neuen Code anfordern / E-Mail ändern';

  @override
  String get legalConsentText =>
      'Ich habe die Datenschutzhinweise, die Datenschutzerklärung und die Nutzungsbedingungen gelesen und verpflichte mich, Patientendaten ausschließlich zu Diagnose- und Behandlungszwecken und im Einklang mit dem Datenschutzrecht zu verarbeiten.';

  @override
  String get legalConsentRequired =>
      'Zum Fortfahren ist Ihre Zustimmung erforderlich';

  @override
  String get privacyNotice => 'Datenschutzhinweise';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAccountSection => 'Konto';

  @override
  String get settingsLegalSection => 'Rechtliches';

  @override
  String supportEmail(String email) {
    return 'Support: $email';
  }

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageSystem => 'Telefonsprache';

  @override
  String get settingsDangerZone => 'Gefahrenbereich';

  @override
  String get deleteMyAccount => 'Mein Konto löschen';

  @override
  String get deleteMyAccountSubtitle => 'Ihr Konto wird endgültig gelöscht';

  @override
  String accountInfoFailed(String error) {
    return 'Kontoinformationen konnten nicht geladen werden: $error';
  }

  @override
  String get transferAdminTitle => 'Zuerst Administratorrechte übertragen';

  @override
  String transferAdminBody(String clinics) {
    return 'Sie sind der einzige Administrator dieser Praxen, die weitere Mitglieder haben:\n\n$clinics\n\nErnennen Sie im Bereich Mitglieder ein anderes Mitglied zum Administrator und versuchen Sie es dann erneut.';
  }

  @override
  String get accountDeleted => 'Ihr Konto wurde gelöscht';

  @override
  String accountDeleteFailed(String error) {
    return 'Konto konnte nicht gelöscht werden: $error';
  }

  @override
  String serverError(int status) {
    return 'Serverfehler ($status)';
  }

  @override
  String get deleteAccountTitle => 'Konto endgültig löschen';

  @override
  String get deleteAccountWarning =>
      'Ihr Konto und Ihre Anmeldedaten werden gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountClinicsWarning =>
      'Sie sind das einzige Mitglied der folgenden Praxen. Sie werden mit allen Patientenakten, Behandlungen, Fotos und Sprachaufnahmen gelöscht:';

  @override
  String get deleteAccountMembershipOnly =>
      'Die Daten in Praxen, denen Sie angehören, bleiben bei der Praxis; nur Ihre Mitgliedschaft endet.';

  @override
  String deleteAccountTypeToConfirm(String word) {
    return 'Geben Sie zur Bestätigung \"$word\" ein:';
  }

  @override
  String get deleteAccountConfirmWord => 'LÖSCHEN';

  @override
  String get deleteAccountButton => 'Konto löschen';

  @override
  String get errInvalidCredentials => 'E-Mail oder Passwort ist falsch';

  @override
  String get errAlreadyRegistered =>
      'Diese E-Mail ist bereits registriert. Bitte melden Sie sich an.';

  @override
  String get errPasswordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen haben';

  @override
  String get errTooManyAttempts =>
      'Zu viele Versuche. Bitte warten Sie kurz und versuchen Sie es erneut.';

  @override
  String get errAlreadyMember => 'Sie sind bereits Mitglied dieser Praxis';

  @override
  String get errClinicCodeNotFound => 'Praxiscode nicht gefunden';

  @override
  String get errOnlyAdminCanApprove =>
      'Nur der Praxisadministrator kann bestätigen';

  @override
  String get errResetCodeInvalid =>
      'Der Code ist falsch oder abgelaufen. Fordern Sie einen neuen Code an.';

  @override
  String get errSamePassword =>
      'Das neue Passwort muss sich vom alten unterscheiden';

  @override
  String get errSignupIncomplete =>
      'Die Registrierung konnte nicht abgeschlossen werden. Prüfen Sie die E-Mail-Bestätigung.';

  @override
  String get errSessionRequired => 'Bitte melden Sie sich an';

  @override
  String get errClinicCreateFailed => 'Praxis konnte nicht angelegt werden';

  @override
  String get errRoleInvalid => 'Die Rolle muss Zahnarzt oder Assistenz sein';

  @override
  String get errJoinRequestFailed =>
      'Beitrittsanfrage konnte nicht erstellt werden';

  @override
  String get errNotMember => 'Sie sind kein Mitglied dieser Praxis';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get close => 'Schließen';

  @override
  String get view => 'Anzeigen';

  @override
  String get copy => 'Kopieren';

  @override
  String get approve => 'Bestätigen';

  @override
  String get reject => 'Ablehnen';

  @override
  String get remove => 'Entfernen';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneOptionalLabel => 'Telefon (optional)';

  @override
  String get noPhone => 'Kein Telefon';

  @override
  String loadFailed(String error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get clinicFallback => 'Praxis';

  @override
  String get recalls => 'Recall';

  @override
  String get todos => 'Aufgaben';

  @override
  String get followUps => 'Wiedervorlagen';

  @override
  String get reports => 'Berichte';

  @override
  String get clinics => 'Praxen';

  @override
  String get newPatient => 'Neuer Patient';

  @override
  String get addPatient => 'Patient hinzufügen';

  @override
  String get patientAdded => 'Patient hinzugefügt';

  @override
  String patientAddFailed(String error) {
    return 'Patient konnte nicht hinzugefügt werden: $error';
  }

  @override
  String get signOutTitle => 'Abmelden';

  @override
  String get signOutConfirm => 'Möchten Sie sich von Ihrem Konto abmelden?';

  @override
  String get myClinics => 'Meine Praxen';

  @override
  String get copyCode => 'Code kopieren';

  @override
  String get activeClinicCode => 'Aktueller Praxiscode';

  @override
  String get clinicCodeShareHint =>
      'Teilen Sie den Code; wer beitritt, wartet auf Ihre Bestätigung und wird nicht sofort Mitglied.';

  @override
  String get joinRequests => 'Beitrittsanfragen';

  @override
  String joinRequestsCount(int count) {
    return 'Beitrittsanfragen ($count)';
  }

  @override
  String get members => 'Mitglieder';

  @override
  String get appearance => 'Darstellung';

  @override
  String get treatmentTemplates => 'Behandlungsvorlagen';

  @override
  String get addOrJoinClinic => 'Weitere Praxis anlegen / beitreten';

  @override
  String followUpsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wiedervorlagen sind fällig',
      one: '1 Wiedervorlage ist fällig',
    );
    return '$_temp0';
  }

  @override
  String get followUpsOffline =>
      'Keine Internetverbindung oder Server nicht erreichbar. Wiedervorlagen konnten nicht geladen werden.';

  @override
  String followUpsLoadFailed(String error) {
    return 'Wiedervorlagen konnten nicht geladen werden: $error';
  }

  @override
  String get searchPatientsHint => 'Patienten suchen (Name oder Telefon)…';

  @override
  String get sortByName => 'A–Z';

  @override
  String get sortByLastVisit => 'Letzte Behandlung';

  @override
  String get selectPatientHint =>
      'Wählen Sie einen Patienten aus, um Details zu sehen';

  @override
  String get themeLabel => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSystem => 'System';

  @override
  String get colorPalette => 'Farbpalette';

  @override
  String get paletteClinic => 'Praxisblau';

  @override
  String get paletteClinicDesc => 'Ruhiges, klinisches Schieferblau';

  @override
  String get paletteOcean => 'Ozean';

  @override
  String get paletteOceanDesc => 'Tiefes Cyan, frisch und luftig';

  @override
  String get paletteSage => 'Salbei';

  @override
  String get paletteSageDesc => 'Gedämpftes Grün, sanft medizinisch';

  @override
  String get paletteGraphite => 'Graphit';

  @override
  String get paletteGraphiteDesc => 'Neutrales Graphit mit eisblauem Akzent';

  @override
  String get paletteClassic => 'Klassisches Grün';

  @override
  String get paletteClassicDesc => 'Lebhafter grüner Akzent';

  @override
  String get patientsLoadFailed => 'Patienten konnten nicht geladen werden.';

  @override
  String get noPatientsYet => 'Noch keine Patienten.\nOben rechts hinzufügen.';

  @override
  String get noPatientsMatch => 'Keine Patienten zur Suche gefunden.';

  @override
  String get newProcedure => 'Neue Behandlung';

  @override
  String get procedureSaved => 'Behandlung gespeichert';

  @override
  String get plannedForNextSession => 'Für die nächste Sitzung geplant';

  @override
  String get voiceNoteSaved => 'Sprachnotiz gespeichert';

  @override
  String get editPatientTitle => 'Patient bearbeiten';

  @override
  String get deletePatientTitle => 'Patient löschen';

  @override
  String deletePatientConfirm(String name) {
    return '$name und alle zugehörigen Daten löschen?';
  }

  @override
  String patientDeleteFailed(String error) {
    return 'Patient konnte nicht gelöscht werden: $error';
  }

  @override
  String get sharePdfTitle => 'Behandlungsverlauf teilen';

  @override
  String get sharePdfWarning =>
      'Das PDF enthält Gesundheitsdaten des Patienten. Senden Sie es nur an den Patienten selbst oder mit seiner Einwilligung an berechtigte Personen.';

  @override
  String get createPdf => 'PDF erstellen';

  @override
  String followUpAdded(String title) {
    return 'Wiedervorlage hinzugefügt: $title';
  }

  @override
  String get markedAsDone => 'Behandlung als erledigt gespeichert';

  @override
  String completeFailed(String error) {
    return 'Konnte nicht abgeschlossen werden: $error';
  }

  @override
  String followUpCompleteFailed(String error) {
    return 'Wiedervorlage konnte nicht abgeschlossen werden: $error';
  }

  @override
  String get deleteFollowUpTitle => 'Wiedervorlage löschen';

  @override
  String deleteItemConfirm(String name) {
    return '„$name“ löschen?';
  }

  @override
  String followUpDeleteFailed(String error) {
    return 'Wiedervorlage konnte nicht gelöscht werden: $error';
  }

  @override
  String get addFollowUp => 'Wiedervorlage hinzufügen';

  @override
  String get voiceNote => 'Sprachnotiz';

  @override
  String get shareAsPdf => 'Als PDF teilen';

  @override
  String plannedProcedures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geplante Behandlungen ($count)',
      one: 'Geplante Behandlung',
    );
    return '$_temp0';
  }

  @override
  String get markDone => 'Erledigt';

  @override
  String dataLoadFailed(String error) {
    return 'Daten konnten nicht geladen werden: $error';
  }

  @override
  String get noRecordsYet =>
      'Noch keine Einträge.\nFügen Sie eine Sprachnotiz oder Behandlung hinzu.';

  @override
  String get openFollowUps => 'Offene Wiedervorlagen';

  @override
  String labReminderOn(String date) {
    return 'Labor-Erinnerung: $date';
  }

  @override
  String get complete => 'Abschließen';

  @override
  String get pendingVoiceNotes => 'Offene Sprachnotizen';

  @override
  String get procedureHistory => 'Behandlungsverlauf';

  @override
  String get noProceduresYet => 'Noch keine Behandlungen.';

  @override
  String get processedVoiceNotes => 'Bearbeitete Sprachnotizen';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String procedureCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Behandlungen',
      one: '1 Behandlung',
    );
    return '$_temp0';
  }

  @override
  String get manageCreateIntro =>
      'Sie legen eine neue Praxis an und werden dort Administrator. Ihre anderen Praxen bleiben erhalten — Sie können zwischen ihnen wechseln.';

  @override
  String get manageJoinIntro =>
      'Geben Sie den Praxiscode ein. Nach der Bestätigung durch den Administrator erhalten Sie Zugriff.';

  @override
  String clinicCreated(String name, String code) {
    return '$name angelegt. Code: $code';
  }

  @override
  String get joinRequestSent =>
      'Beitrittsanfrage gesendet. Warten auf Bestätigung durch den Administrator.';

  @override
  String approvedName(String name) {
    return '$name bestätigt';
  }

  @override
  String approveFailed(String error) {
    return 'Bestätigung fehlgeschlagen: $error';
  }

  @override
  String get rejectRequestTitle => 'Anfrage ablehnen';

  @override
  String rejectRequestConfirm(String name) {
    return 'Möchten Sie die Anfrage von $name ablehnen?';
  }

  @override
  String rejectedName(String name) {
    return '$name abgelehnt';
  }

  @override
  String rejectFailed(String error) {
    return 'Ablehnung fehlgeschlagen: $error';
  }

  @override
  String noPendingRequests(String clinic) {
    return 'Keine offenen Anfragen für $clinic.';
  }

  @override
  String wantsToJoinAs(String role) {
    return 'Möchte als $role beitreten';
  }

  @override
  String get awaitingApprovalTitle => 'Warten auf Bestätigung';

  @override
  String get awaitingApprovalBody =>
      'Ihre Beitrittsanfrage wartet auf die Bestätigung durch den Praxisadministrator. Danach können Sie hier fortfahren.';

  @override
  String get refreshStatus => 'Status aktualisieren';

  @override
  String get createOrJoinOtherClinic => 'Weitere Praxis anlegen / beitreten';

  @override
  String get cannotChangeOwnAdmin =>
      'Sie können Ihre eigene Administratorrolle nicht ändern';

  @override
  String roleFor(String name) {
    return 'Rolle: $name';
  }

  @override
  String roleUpdateFailed(String error) {
    return 'Rolle konnte nicht geändert werden: $error';
  }

  @override
  String get cannotRemoveOwnAdmin =>
      'Ihr Administratorkonto kann hier nicht entfernt werden';

  @override
  String get removeMemberTitle => 'Mitglied entfernen';

  @override
  String removeMemberConfirm(String name) {
    return '$name aus der Praxis entfernen?';
  }

  @override
  String removeFailed(String error) {
    return 'Entfernen fehlgeschlagen: $error';
  }

  @override
  String get clinicMembersTitle => 'Praxismitglieder';

  @override
  String memberYou(String name) {
    return '$name (Sie)';
  }

  @override
  String get changeRole => 'Rolle ändern';
}
