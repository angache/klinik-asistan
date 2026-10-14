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

  @override
  String get scopeTooth => 'Zahn';

  @override
  String get scopeUpperJaw => 'Oberkiefer';

  @override
  String get scopeLowerJaw => 'Unterkiefer';

  @override
  String get scopeFullMouth => 'Gesamter Mund';

  @override
  String scopeToothWithNumber(String teeth) {
    return 'Zahn: $teeth';
  }

  @override
  String get fieldScope => 'Bereich';

  @override
  String get fieldTooth => 'Zahn';

  @override
  String get fieldTitle => 'Titel';

  @override
  String get fieldNote => 'Notiz';

  @override
  String get fieldCanalLength => 'Kanallänge';

  @override
  String get fieldFile => 'Feile';

  @override
  String get fieldMedicament => 'Medikament';

  @override
  String get fieldDate => 'Datum';

  @override
  String photosAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos hinzugefügt',
      one: '1 Foto hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos entfernt',
      one: '1 Foto entfernt',
    );
    return '$_temp0';
  }

  @override
  String get canalMain => 'Haupt';

  @override
  String get handFile => 'Handfeile';

  @override
  String get noMedicament => 'Ohne Medikament';

  @override
  String get errNoteConflict =>
      'Diese Behandlung wurde zwischenzeitlich von jemand anderem bearbeitet. Aktualisieren Sie die Liste und versuchen Sie es erneut.';

  @override
  String get errNoClinicSelected =>
      'Keine Praxis ausgewählt – bitte zuerst anmelden.';

  @override
  String get errNoPermissionDeletePatient =>
      'Sie haben keine Berechtigung, diesen Patienten zu löschen';

  @override
  String get errNoPermissionDeleteNote =>
      'Sie haben keine Berechtigung, diese Behandlung zu löschen';

  @override
  String labFollowUpTitle(String title) {
    return 'Labor: $title';
  }

  @override
  String labExpectedReturnOn(String date) {
    return 'Erwartete Laborrückgabe: $date';
  }

  @override
  String labExpectedReturnFor(String date, String name) {
    return 'Erwartete Laborrückgabe: $date · $name';
  }

  @override
  String get savingEllipsis => 'Wird gespeichert…';

  @override
  String get procedureDate => 'Behandlungsdatum';

  @override
  String get select => 'Auswählen';

  @override
  String get expectedLabReturn => 'Erwartete Laborrückgabe';

  @override
  String get followUpDate => 'Kontrolltermin';

  @override
  String get errSelectOrTypeProcedure =>
      'Wählen Sie eine Behandlung oder geben Sie einen Titel ein';

  @override
  String get errSelectScope => 'Bereich auswählen';

  @override
  String get errSelectTooth => 'Wählen Sie mindestens einen Zahn';

  @override
  String get errSelectLabDate =>
      'Wählen Sie das erwartete Rückgabedatum vom Labor';

  @override
  String get errSelectFollowUpDate => 'Wählen Sie den Kontrolltermin';

  @override
  String get errFollowUpNoteRequired =>
      'Geben Sie eine Notiz zur Wiedervorlage ein';

  @override
  String get uploadingPhotos => 'Fotos werden in die Cloud hochgeladen…';

  @override
  String get savingProcedure => 'Behandlung wird gespeichert…';

  @override
  String uploadingPhotoProgress(int current, int total) {
    return 'Foto wird hochgeladen ($current/$total)…';
  }

  @override
  String saveFailed(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get creatingLabReminder => 'Labor-Erinnerung wird erstellt…';

  @override
  String get creatingFollowUpReminder => 'Kontroll-Erinnerung wird erstellt…';

  @override
  String followUpTitle(String title) {
    return 'Kontrolle: $title';
  }

  @override
  String get reminderKindLab => 'Labor';

  @override
  String get reminderKindFollowUp => 'Kontrolle';

  @override
  String reminderCreateFailed(String kinds) {
    return 'Behandlung gespeichert, aber diese Erinnerungen konnten nicht erstellt werden: $kinds. Fügen Sie sie unter Wiedervorlagen hinzu.';
  }

  @override
  String get planForNextSession => 'Für nächste Sitzung planen';

  @override
  String saveTeethCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zähne speichern',
      one: '1 Zahn speichern',
    );
    return '$_temp0';
  }

  @override
  String get pastRecordHint => 'Früherer Eintrag (aus Papierakten übernommen)';

  @override
  String get change => 'Ändern';

  @override
  String get procedureSection => 'Behandlung';

  @override
  String get procedureSectionHint =>
      'Wählen Sie mindestens eine Behandlung oder geben Sie einen Titel ein';

  @override
  String get procedureTitleLabel => 'Behandlungstitel';

  @override
  String get noteOptionalLabel => 'Notiz (optional)';

  @override
  String get noteHint => 'Bei Bedarf hier eingeben…';

  @override
  String get addFollowUpSubtitle =>
      'Kontrolltermin und Erinnerung nach der Behandlung';

  @override
  String get followUpNoteLabel => 'Notiz zur Wiedervorlage';

  @override
  String get followUpNoteHint => 'z. B. Perkussion und Röntgenkontrolle';

  @override
  String get presetOneWeek => '1 Woche';

  @override
  String get presetOneMonth => '1 Monat';

  @override
  String get presetThreeMonths => '3 Monate';

  @override
  String get presetSixMonths => '6 Monate';

  @override
  String get pickDate => 'Datum wählen';

  @override
  String get remindWhenLabel => 'Wann erinnern?';

  @override
  String get remindOnDay => 'Am Kontrolltag';

  @override
  String get remindOneDayBefore => '1 Tag vorher';

  @override
  String get remindThreeDaysBefore => '3 Tage vorher';

  @override
  String get remindOneWeekBefore => '1 Woche vorher';

  @override
  String followUpSummary(String date, String reminder) {
    return 'Kontrolle: $date · Erinnerung: $reminder';
  }

  @override
  String get scopeToothRequired =>
      'Für diese Behandlung ist eine Zahnauswahl erforderlich';

  @override
  String get scopeRequired => 'Bereichsauswahl erforderlich';

  @override
  String get scopeSuitable => 'Passender Bereich für die Behandlung';

  @override
  String get canalSelectToothFirst =>
      'Wählen Sie zuerst einen Zahn für die Kanalparameter. Bei mehreren Zähnen wird jeder Zahn einzeln gespeichert.';

  @override
  String get canalPerToothTitle => 'Kanalangaben pro Zahn';

  @override
  String get canalPerToothHint =>
      'Tippen Sie auf einen Zahn und geben Sie die Parameter ein. Jeder Zahn wird als eigene Notiz gespeichert.';

  @override
  String toothNumber(String tooth) {
    return 'Zahn $tooth';
  }

  @override
  String get photoSection => 'Foto';

  @override
  String get photoPrivacyHint =>
      'Das Gesicht des Patienten darf nicht sichtbar sein. Nur Behandlungs- bzw. intraorale Aufnahmen.';

  @override
  String get planningSection => 'Planung';

  @override
  String get labCountsAsDone =>
      'Wenn ans Labor gesendet, gilt die Behandlung als durchgeführt';

  @override
  String get info => 'Info';

  @override
  String get planInfoLabBlocked =>
      'Diese Option ist nicht verfügbar, solange „Ans Labor gesendet“ aktiviert ist; die Behandlung gilt in dieser Sitzung als durchgeführt.';

  @override
  String get planInfo =>
      'Die Behandlung gilt heute als nicht durchgeführt. Beim nächsten Besuch wird der Patient oben hervorgehoben; nach „Erledigt“ wird sie zum Behandlungsverlauf dieses Tages hinzugefügt.';

  @override
  String get sentToLab => 'Ans Labor gesendet';

  @override
  String get sentToLabInfo =>
      'Aktivieren Sie dies, wenn die Arbeit ans Labor geschickt wurde. Wiedervorlagen und eine Benachrichtigung erinnern 1 Tag vor dem erwarteten Rückgabedatum. Die Behandlung gilt damit als durchgeführt; „Für nächste Sitzung planen“ wird deaktiviert.';

  @override
  String addExtraCanalForTooth(String tooth) {
    return 'Zusätzlichen Kanal hinzufügen · Zahn $tooth';
  }

  @override
  String get addExtraCanal => 'Zusätzlichen Kanal hinzufügen';

  @override
  String get extraCanalHint =>
      'Wählen Sie einen Kanal, der nicht in der typischen Liste steht, oder geben Sie einen eigenen Namen ein.';

  @override
  String get allStandardCanalsAdded =>
      'Alle Standardcodes sind bereits hinzugefügt. Verwenden Sie einen eigenen Namen.';

  @override
  String get customCanalName => 'Eigener Kanalname';

  @override
  String get customCanalHint => 'z. B. MB3, DB2…';

  @override
  String get editProcedureTitle => 'Behandlung bearbeiten';

  @override
  String editVersionHint(int version) {
    return 'v$version → wird als neue Version gespeichert; die alte bleibt erhalten';
  }

  @override
  String get errTitleRequired => 'Behandlungstitel ist erforderlich';

  @override
  String get noChanges => 'Keine Änderungen';

  @override
  String get saveAsNewVersion => 'Als neue Version speichern';

  @override
  String get quadrantUpperRight => 'Oben rechts';

  @override
  String get quadrantUpperLeft => 'Oben links';

  @override
  String get quadrantLowerRight => 'Unten rechts';

  @override
  String get quadrantLowerLeft => 'Unten links';

  @override
  String get toothNumberSection => 'Zahnnummer';

  @override
  String get clearSelection => 'Auswahl löschen';

  @override
  String get typeToSelectLabel => 'Per Eingabe wählen (FDI)';

  @override
  String get typeToSelectHint => 'z. B. 15  oder  14-17  oder  36,37';

  @override
  String get apply => 'Übernehmen';

  @override
  String get toothSelectorHelp =>
      'Tippen: auswählen · Lange drücken: Quadrant vergrößern · Nach unten wischen oder OK: schließen';

  @override
  String get jawUpper => 'OBEN';

  @override
  String get jawLower => 'UNTEN';

  @override
  String get sideRight => 'Rechts';

  @override
  String get sideLeft => 'Links';

  @override
  String get selectTeeth => 'Zähne auswählen';

  @override
  String selectedTeeth(String teeth) {
    return 'Ausgewählt: $teeth';
  }

  @override
  String get swipeDownToClose =>
      'Sie können auch nach unten wischen, um zu schließen';

  @override
  String canalParamsForTooth(String tooth) {
    return 'Kanalparameter · Zahn $tooth';
  }

  @override
  String get canalParamsTitle => 'Parameter der Wurzelkanalbehandlung';

  @override
  String get canalLengthMm => 'Kanallänge (mm)';

  @override
  String get extra => 'Zusätzlich';

  @override
  String get fileSystem => 'Feilensystem';

  @override
  String get intracanalMedicament => 'Medikamentöse Einlage';

  @override
  String toothCanalHint(String tooth, String canals) {
    return 'Zahn $tooth · typisch: $canals – bei Bedarf weitere hinzufügen';
  }

  @override
  String get newVersionSaved => 'Neue Version gespeichert';

  @override
  String get deleteProcedureTitle => 'Behandlung löschen';

  @override
  String get deleteProcedureConfirm =>
      'Diese Notiz und alle früheren Versionen werden dauerhaft gelöscht.';

  @override
  String get procedureDeleted => 'Behandlung gelöscht';

  @override
  String procedureDeleteFailed(String error) {
    return 'Behandlung konnte nicht gelöscht werden: $error';
  }

  @override
  String get labShort => 'Labor';

  @override
  String labReturnShort(String date) {
    return 'Labor → $date';
  }

  @override
  String get history => 'Verlauf';

  @override
  String get share => 'Teilen';

  @override
  String get versionHistory => 'Versionsverlauf';

  @override
  String historyLoadFailed(String error) {
    return 'Verlauf konnte nicht geladen werden: $error';
  }

  @override
  String get noVersionsFound => 'Keine Versionen gefunden';

  @override
  String get currentVersion => 'Aktuell';

  @override
  String get oldVersion => 'Alte Version';

  @override
  String get changesInVersion => 'Änderungen in dieser Version';

  @override
  String get firstRecord => 'Erster Eintrag';

  @override
  String get micPermissionRequired => 'Mikrofonberechtigung erforderlich';

  @override
  String get micPermissionMissing => 'Keine Mikrofonberechtigung';

  @override
  String get recordingEmpty =>
      'Die Aufnahme ist leer oder konnte nicht erstellt werden';

  @override
  String voiceUploadFailed(String error) {
    return 'Sprachaufnahme konnte nicht hochgeladen werden: $error';
  }

  @override
  String get quickVoiceNote => 'Schnelle Sprachnotiz';

  @override
  String get voicePrivacyHint =>
      'Die Aufnahme dient nur der Behandlungszusammenfassung durch Arzt oder Assistenz. Gespräche mit Patienten werden nicht aufgezeichnet.';

  @override
  String get recordingInProgress => 'Aufnahme läuft…';

  @override
  String get uploadingVoice => 'Audio wird in die Cloud hochgeladen…';

  @override
  String get voiceStartHint =>
      'Tippen Sie auf das Mikrofon und sprechen Sie, dann auf „Beenden & speichern“';

  @override
  String get pleaseWait => 'Bitte warten…';

  @override
  String get finishAndSave => 'Beenden & speichern';

  @override
  String playFailed(String error) {
    return 'Wiedergabe fehlgeschlagen: $error';
  }

  @override
  String get memoMarkedProcessed => 'Sprachnotiz als verarbeitet markiert';

  @override
  String markFailed(String error) {
    return 'Markieren fehlgeschlagen: $error';
  }

  @override
  String get deleteVoiceNoteTitle => 'Sprachnotiz löschen';

  @override
  String get deleteVoiceNoteConfirm =>
      'Diese Sprachnotiz wird dauerhaft gelöscht.';

  @override
  String deleteFailed(String error) {
    return 'Löschen fehlgeschlagen: $error';
  }

  @override
  String get processedVoiceNote => 'Verarbeitete Sprachnotiz';

  @override
  String get pendingVoiceNote => 'Offene Sprachnotiz';

  @override
  String durationLabel(String duration) {
    return 'Dauer: $duration';
  }

  @override
  String get stop => 'Stopp';

  @override
  String get listen => 'Anhören';

  @override
  String get convertToNote => 'In Notiz umwandeln';

  @override
  String get audioFileEmpty => 'Die Audiodatei ist leer';

  @override
  String photoOpenFailed(String error) {
    return 'Foto konnte nicht geöffnet werden: $error';
  }

  @override
  String photoCount(int count, int max) {
    return '$count / $max Fotos';
  }

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get fromGallery => 'Aus Galerie';

  @override
  String get shareThisPhoto => 'Dieses Foto teilen';

  @override
  String shareAllPhotos(int count) {
    return 'Alle Fotos teilen ($count)';
  }

  @override
  String get procedurePhoto => 'Behandlungsfoto';

  @override
  String procedurePhotoIndex(int index, int count) {
    return 'Behandlungsfoto $index/$count';
  }

  @override
  String get shareTooltip => 'Teilen (WhatsApp, E-Mail…)';

  @override
  String get photoLoadFailed => 'Foto konnte nicht geladen werden';

  @override
  String preparingPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos werden vorbereitet…',
      one: 'Foto wird vorbereitet…',
    );
    return '$_temp0';
  }

  @override
  String shareFailed(String error) {
    return 'Teilen fehlgeschlagen: $error';
  }

  @override
  String completedItem(String title) {
    return 'Erledigt: $title';
  }

  @override
  String actionFailed(String error) {
    return 'Aktion fehlgeschlagen: $error';
  }

  @override
  String deletedItem(String title) {
    return 'Gelöscht: $title';
  }

  @override
  String patientOpenFailed(String error) {
    return 'Patient konnte nicht geöffnet werden: $error';
  }

  @override
  String get noOpenFollowUps => 'Keine offenen Wiedervorlagen.';

  @override
  String get sectionOverdue => 'Überfällig';

  @override
  String get sectionReminderDue => 'Demnächst (Erinnerung fällig)';

  @override
  String get sectionUpcoming => 'Demnächst';

  @override
  String get patientFallback => 'Patient';

  @override
  String reminderOn(String date) {
    return 'Erinnerung: $date';
  }

  @override
  String get goToPatient => 'Zum Patienten';

  @override
  String get errFollowUpTitleRequired => 'Titel der Wiedervorlage eingeben';

  @override
  String get followUpWhatLabel => 'Was soll nachverfolgt werden?';

  @override
  String get followUpWhatHint =>
      'z. B. Kontrolle, Fadenentfernung, Schmerzkontrolle…';

  @override
  String get whenLabel => 'Wann?';

  @override
  String notifFollowUpTitle(String name) {
    return 'Wiedervorlage: $name';
  }

  @override
  String notifCheckupBody(String title, String date) {
    return '$title · Kontrolle: $date';
  }

  @override
  String get notifChannelFollowUps => 'Wiedervorlagen';

  @override
  String get notifChannelFollowUpsDesc =>
      'Erinnerungen an Kontrollen und Wiedervorlagen';

  @override
  String get notifChannelClinic => 'Praxisbenachrichtigungen';

  @override
  String get notifChannelClinicDesc =>
      'Erinnerungen zu Beitritten, Wiedervorlagen und Aufgaben';

  @override
  String get todoAdded => 'Aufgabe hinzugefügt';

  @override
  String get noOpenTodos =>
      'Keine offenen Aufgaben.\nMit Hinzufügen eine Text- oder Sprachnotiz anlegen.';

  @override
  String get todosIntro =>
      'Allgemeine Praxisnotizen — Termine, Rückrufe, Erinnerungen…';

  @override
  String get sectionUndated => 'Ohne Datum';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterMine => 'Mir zugewiesen';

  @override
  String get filterTodayOverdue => 'Heute/überfällig';

  @override
  String get filterCompleted => 'Erledigt';

  @override
  String commentAddFailed(String error) {
    return 'Kommentar konnte nicht hinzugefügt werden: $error';
  }

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galerie';

  @override
  String get cameraPermissionRequired => 'Kameraberechtigung erforderlich';

  @override
  String cameraOpenFailed(String error) {
    return 'Kamera konnte nicht geöffnet werden: $error';
  }

  @override
  String galleryOpenFailed(String error) {
    return 'Galerie konnte nicht geöffnet werden: $error';
  }

  @override
  String imageAddFailed(String error) {
    return 'Bild konnte nicht hinzugefügt werden: $error';
  }

  @override
  String imageOpenFailed(String error) {
    return 'Bild konnte nicht geöffnet werden: $error';
  }

  @override
  String get deleteImageTitle => 'Bild löschen';

  @override
  String get deleteImageConfirm => 'Dieses Bild aus der Aufgabe entfernen?';

  @override
  String imageDeleteFailed(String error) {
    return 'Bild konnte nicht gelöscht werden: $error';
  }

  @override
  String get todoDetailTitle => 'Aufgabendetails';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get markAsCompleted => 'Als erledigt markieren';

  @override
  String get wholeClinic => 'Ganze Praxis';

  @override
  String get clinicMemberFallback => 'Praxismitglied';

  @override
  String createdByOn(String name, String date) {
    return 'Erstellt von $name am $date';
  }

  @override
  String get images => 'Bilder';

  @override
  String get noImages => 'Keine Bilder hinzugefügt';

  @override
  String commentsCount(int count) {
    return 'Kommentare ($count)';
  }

  @override
  String get noCommentsYet => 'Noch keine Kommentare';

  @override
  String get addCommentHint => 'Kommentar hinzufügen…';

  @override
  String get noHistory => 'Kein Verlauf vorhanden';

  @override
  String get eventCreated => 'Aufgabe erstellt';

  @override
  String get eventCompleted => 'Aufgabe erledigt';

  @override
  String get eventCommentAdded => 'Kommentar hinzugefügt';

  @override
  String get eventImageAdded => 'Bild hinzugefügt';

  @override
  String get eventImageDeleted => 'Bild entfernt';

  @override
  String get completedMessage => 'Erledigt';

  @override
  String get deleteTodoConfirm => 'Diese Aufgabe löschen?';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityImportant => 'Wichtig';

  @override
  String get priorityUrgent => 'Dringend';

  @override
  String get recurrenceNone => 'Keine Wiederholung';

  @override
  String get recurrenceDaily => 'Täglich';

  @override
  String get recurrenceWeekly => 'Wöchentlich';

  @override
  String get recurrenceMonthly => 'Monatlich';

  @override
  String get voiceTodo => 'Sprachaufgabe';

  @override
  String get todoFallback => 'Aufgabe';

  @override
  String previewPlayFailed(String error) {
    return 'Vorschau konnte nicht abgespielt werden: $error';
  }

  @override
  String get taskTime => 'Uhrzeit der Aufgabe';

  @override
  String get errTextOrVoiceRequired => 'Notiz schreiben oder Audio aufnehmen';

  @override
  String get errFinishRecordingFirst => 'Beenden Sie zuerst die Aufnahme';

  @override
  String get addTodo => 'Aufgabe hinzufügen';

  @override
  String get todoNoteHint =>
      'z. B. Herrn Müller morgen einen Termin geben, Patienten zurückrufen…';

  @override
  String get voiceOptional => 'Audio (optional)';

  @override
  String get finish => 'Beenden';

  @override
  String voiceRecorded(String duration) {
    return 'Audio aufgenommen · $duration';
  }

  @override
  String get reRecord => 'Neu aufnehmen';

  @override
  String get recordVoice => 'Audio aufnehmen';

  @override
  String get tomorrow => 'Morgen';

  @override
  String targetDate(String date) {
    return 'Ziel: $date';
  }

  @override
  String get priority => 'Priorität';

  @override
  String get addTime => 'Uhrzeit hinzufügen';

  @override
  String get assignee => 'Zuständig';

  @override
  String get patientLinkOptional => 'Verknüpfter Patient (optional)';

  @override
  String get noPatientSelected => 'Kein Patient ausgewählt';

  @override
  String get recurrence => 'Wiederholung';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get remindOnTime => 'Pünktlich';

  @override
  String get remindOneHourBefore => '1 Stunde vorher';

  @override
  String get errCommentEmpty => 'Kommentar darf nicht leer sein';

  @override
  String get recurringTask => 'Wiederkehrende Aufgabe';

  @override
  String get errInvalidFilePath => 'Ungültiger Dateipfad';

  @override
  String get periodThisWeek => 'Diese Woche';

  @override
  String get periodLastWeek => 'Letzte Woche';

  @override
  String get periodThisMonth => 'Dieser Monat';

  @override
  String get periodLastMonth => 'Letzter Monat';

  @override
  String get reportPeriod => 'Berichtszeitraum';

  @override
  String comparedWith(String range) {
    return 'Vergleich: $range';
  }

  @override
  String get topProcedures => 'Häufigste Behandlungen';

  @override
  String get noProceduresInPeriod =>
      'In diesem Zeitraum wurden keine Behandlungen erfasst.';

  @override
  String get byCategory => 'Nach Kategorie';

  @override
  String get dailyActivity => 'Auslastung nach Tagen';

  @override
  String get followUpStatus => 'Stand der Wiedervorlagen';

  @override
  String get patientsToRecall => 'Zurückzurufende Patienten';

  @override
  String daysPlus(int days) {
    return '$days+ Tage';
  }

  @override
  String get noRecallsDue => 'Keine Patienten zur Kontrolle fällig.';

  @override
  String recallsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Patienten sind zur Kontrolle fällig',
      one: '1 Patient ist zur Kontrolle fällig',
    );
    return '$_temp0';
  }

  @override
  String oldRecallsCount(int count) {
    return '+ $count ältere Patienten (Kontrolle seit über 12 Monaten fällig)';
  }

  @override
  String get openList => 'Liste öffnen';

  @override
  String get statProceduresDone => 'Durchgeführte Behandlungen';

  @override
  String get statProceduresHint =>
      'Behandlungen an mehreren Zähnen werden pro Zahn gezählt';

  @override
  String get statPatientsTreated => 'Behandelte Patienten';

  @override
  String get statVisits => 'Patientenbesuche';

  @override
  String get statVisitsHint =>
      'Besuche desselben Patienten an verschiedenen Tagen zählen einzeln';

  @override
  String get statNewPatients => 'Neue Patienten';

  @override
  String get statTotalPatients => 'Patienten gesamt';

  @override
  String get statPendingPlanned => 'Offene geplante Behandlungen';

  @override
  String get sameAsPrevious => 'Wie im Vorzeitraum';

  @override
  String weekOf(String label) {
    return 'Woche ab $label';
  }

  @override
  String busiestDay(String day, String procedures) {
    return 'Stärkster Tag: $day ($procedures)';
  }

  @override
  String overdueCount(int count) {
    return '$count überfällig';
  }

  @override
  String get labPending => 'Arbeiten im Labor';

  @override
  String get controlPending => 'Offene Kontrollen';

  @override
  String get openTasks => 'Offene Aufgaben';

  @override
  String completedInPeriod(int lab, int control, int task) {
    return 'In diesem Zeitraum erledigt — Labor: $lab, Kontrollen: $control, Aufgaben: $task';
  }

  @override
  String stalledHint(int days) {
    return 'Patienten mit geplanten Behandlungen, die seit $days Tagen nicht da waren und keine künftige Kontrolle haben.';
  }

  @override
  String get noPatientsToRecall => 'Keine Patienten zum Zurückrufen.';

  @override
  String lastProcedure(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'vor $days Tagen',
      one: 'vor 1 Tag',
      zero: 'heute',
    );
    return 'Letzte Behandlung: $date ($_temp0)';
  }

  @override
  String plannedList(String items) {
    return 'Geplant: $items';
  }

  @override
  String callPhone(String phone) {
    return 'Anrufen: $phone';
  }

  @override
  String firstNPatients(int count) {
    return 'Die ersten $count Patienten werden angezeigt.';
  }

  @override
  String get moreAfterLogging =>
      'Weitere erscheinen, sobald Sie Anrufergebnisse erfassen.';

  @override
  String get call => 'Anrufen';

  @override
  String get recallResultAppointment => 'Termin vereinbart';

  @override
  String get recallResultUnreachable => 'Nicht erreicht';

  @override
  String get recallResultDeclined => 'Kein Interesse';

  @override
  String get recallAppointmentHint =>
      'Kontrolltermin wählen; eine Wiedervorlage wird angelegt';

  @override
  String get recallUnreachableHint =>
      'Erscheint in 7 Tagen wieder in der Liste';

  @override
  String get recallDeclinedHint =>
      'Bis zur nächsten Behandlung nicht in der Liste';

  @override
  String get openPatientCard => 'Patientenakte öffnen';

  @override
  String recallLogged(String name, String result) {
    return '$name: als „$result“ gespeichert';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String undoFailed(String error) {
    return 'Rückgängig machen fehlgeschlagen: $error';
  }

  @override
  String recallDateHelp(String name) {
    return '$name · Kontrolltermin';
  }

  @override
  String get periodicCheckup => 'Regelmäßige Kontrolle';

  @override
  String checkupReason(String procedure, String date) {
    return 'Grund der Kontrolle: $procedure ($date)';
  }

  @override
  String checkupScheduled(String name, String date) {
    return '$name: Kontrolle für $date geplant';
  }

  @override
  String appointmentSaveFailed(String error) {
    return 'Termin konnte nicht gespeichert werden: $error';
  }

  @override
  String get recallCurrent => 'Aktuell';

  @override
  String get recallOld => 'Ältere Patienten';

  @override
  String get recallOldHint =>
      'Patienten, deren Kontrolltermin über 12 Monate zurückliegt. Sie werden getrennt geführt, da sie lange nicht da waren.';

  @override
  String get recallCurrentHint =>
      'Patienten, deren Kontrollintervall nach einer Behandlung abgelaufen ist. Die Intervalle werden unter Behandlungsvorlagen festgelegt. Patienten mit Termin, geplanter Behandlung oder künftiger Wiedervorlage werden nicht angezeigt.';

  @override
  String get noOldRecalls =>
      'Keine älteren Patienten warten auf eine Kontrolle.';

  @override
  String checkupDue(String date) {
    return 'Kontrolle: $date';
  }

  @override
  String checkupOverdue(String date, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months Monate überfällig',
      one: '1 Monat überfällig',
    );
    return 'Kontrolle: $date ($_temp0)';
  }

  @override
  String lastCall(String result) {
    return 'Letzter Anruf: $result';
  }

  @override
  String get noMissingDefaults => 'Keine fehlenden Standardeinträge';

  @override
  String defaultsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Standardbehandlungen hinzugefügt',
      one: '1 Standardbehandlung hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String addFailed(String error) {
    return 'Hinzufügen fehlgeschlagen: $error';
  }

  @override
  String updateFailed(String error) {
    return 'Aktualisierung fehlgeschlagen: $error';
  }

  @override
  String deleteTemplateConfirm(String name) {
    return '„$name“ aus der Liste entfernen?\nFrühere Patientendaten bleiben unverändert.';
  }

  @override
  String get seedMissingTooltip => 'Fehlende Standardeinträge wiederherstellen';

  @override
  String get hideInactive => 'Inaktive ausblenden';

  @override
  String get showInactive => 'Inaktive anzeigen';

  @override
  String get addProcedure => 'Behandlung hinzufügen';

  @override
  String get templatesIntro =>
      'Behandlungsliste der Praxis. Diese erscheinen im Formular für neue Behandlungen. Frühere Einträge ändern sich nicht.';

  @override
  String get templatesEditRestricted =>
      'Nur Ärzte oder Administratoren können bearbeiten.';

  @override
  String get tagCanal => 'Wurzelkanal';

  @override
  String get tagToothRequired => 'Zahn erforderlich';

  @override
  String get tagJawOk => 'Kiefer/Mund möglich';

  @override
  String get tagLabTracking => 'Laborverfolgung';

  @override
  String tagCheckupMonths(int months) {
    return 'Kontrolle: $months Mon.';
  }

  @override
  String get tagInactive => 'Inaktiv';

  @override
  String get deactivate => 'Deaktivieren';

  @override
  String get activate => 'Aktivieren';

  @override
  String get noTemplatesYet => 'Noch keine Behandlungen.';

  @override
  String get category => 'Kategorie';

  @override
  String get procedureName => 'Name der Behandlung';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get canalProcedure => 'Wurzelkanalbehandlung';

  @override
  String get canalProcedureHint => 'Zeigt Felder für Kanallänge / Feile';

  @override
  String get toothRequired => 'Zahnauswahl erforderlich';

  @override
  String get toothRequiredHint =>
      'Wenn aus, sind Ober-/Unterkiefer oder ganzer Mund wählbar';

  @override
  String get labTracking => 'Laborverfolgung';

  @override
  String get labTrackingHint =>
      'Zeigt „Ans Labor gesendet“ und das Rückgabedatum im Formular';

  @override
  String get periodicCheckupHelper =>
      'Nach dieser Behandlung kommt der Patient auf die Recall-Liste';

  @override
  String get none => 'Keine';

  @override
  String monthsAfter(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'nach $months Monaten',
      one: 'nach 1 Monat',
    );
    return '$_temp0';
  }

  @override
  String get active => 'Aktiv';

  @override
  String get catDiagnosis => 'Diagnose und Planung';

  @override
  String get catTreatment => 'Behandlung';

  @override
  String get catProsthetics => 'Prothetik';

  @override
  String get catGeneral => 'Allgemein';

  @override
  String pdfDocTitle(String name) {
    return 'Behandlungsverlauf - $name';
  }

  @override
  String pdfHeader(String name) {
    return '$name · Behandlungsverlauf';
  }

  @override
  String get pdfConfidential =>
      'Vertraulich: enthält besondere Kategorien personenbezogener Daten (Gesundheitsdaten).';

  @override
  String pdfPage(int page, int total) {
    return 'Seite $page / $total';
  }

  @override
  String get pdfSubtitle => 'Behandlungsverlauf des Patienten';

  @override
  String get pdfRegistered => 'Angelegt am';

  @override
  String get pdfReportDate => 'Berichtsdatum';

  @override
  String pdfPreparedBy(String name) {
    return 'Erstellt von: $name';
  }

  @override
  String pdfDoneProcedures(int count) {
    return 'Durchgeführte Behandlungen ($count)';
  }

  @override
  String get pdfNoProcedures => 'Keine Behandlungen erfasst.';

  @override
  String pdfPlannedProcedures(int count) {
    return 'Geplante Behandlungen ($count)';
  }

  @override
  String get pdfColAdded => 'Hinzugefügt';

  @override
  String get pdfColDetails => 'Details';

  @override
  String pdfLabReturn(String date) {
    return 'Labor · Rückgabe $date';
  }

  @override
  String photoCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos',
      one: '1 Foto',
    );
    return '$_temp0';
  }

  @override
  String get preparingPdf => 'PDF wird erstellt…';

  @override
  String get pdfFilePrefix => 'behandlungsverlauf';

  @override
  String pdfCreateFailed(String error) {
    return 'PDF konnte nicht erstellt werden: $error';
  }

  @override
  String get pdfTreatmentHistory => 'Behandlungsverlauf';
}
