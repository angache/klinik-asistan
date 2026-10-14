// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordMinLength => 'At least 6 characters';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get retry => 'Try again';

  @override
  String get signOut => 'Sign out';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsAndAccount => 'Settings and account';

  @override
  String linkOpenFailed(String url) {
    return 'Could not open link: $url';
  }

  @override
  String clinicCodeCopied(String code) {
    return 'Clinic code copied: $code';
  }

  @override
  String get userFallback => 'User';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleDoctor => 'Doctor';

  @override
  String get roleAssistant => 'Assistant';

  @override
  String get joinStatusPending => 'Awaiting approval';

  @override
  String get joinStatusApproved => 'Approved';

  @override
  String get joinStatusRejected => 'Rejected';

  @override
  String get loginSubtitle => 'Sign in';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginCreateAccount => 'Create account / Join a clinic';

  @override
  String get loginFailed => 'Sign-in failed';

  @override
  String get clinicRequiredTitle => 'Clinic required';

  @override
  String get serverUnreachableTitle => 'Could not reach the server';

  @override
  String get serverUnreachableBody =>
      'Check your internet connection and try again.';

  @override
  String get signupTitle => 'Sign up';

  @override
  String get createClinic => 'Create clinic';

  @override
  String get joinClinic => 'Join a clinic';

  @override
  String get signupCreateIntro =>
      'You open a new clinic and become its admin and doctor. You invite assistants with the clinic code.';

  @override
  String get clinicNameLabel => 'Clinic name';

  @override
  String get clinicNameRequired => 'Clinic name is required';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get signupJoinIntro =>
      'Send a join request with the clinic code you got from the admin. You get access once the admin approves.';

  @override
  String get clinicCodeLabel => 'Clinic code';

  @override
  String get clinicCodeHint => 'e.g. A3K9PX';

  @override
  String get clinicCodeRequired => 'Code is required';

  @override
  String get myRole => 'My role';

  @override
  String get joinButton => 'Join';

  @override
  String get resetCodeSent =>
      'If the address is registered, a code has been sent to your email';

  @override
  String get passwordUpdated => 'Your password has been updated';

  @override
  String get resetIntroEmail =>
      'Enter your account\'s email address and we\'ll send you a reset code.';

  @override
  String get resetIntroCode =>
      'Enter the code from your email and your new password.';

  @override
  String get resetCodeLabel => 'Code';

  @override
  String get resetCodeInvalid => 'Enter the code from the email';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get newPasswordRepeatLabel => 'New password (again)';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get updatePasswordButton => 'Update password';

  @override
  String get sendCodeButton => 'Send code';

  @override
  String get resetRequestNewCode => 'Request a new code / change email';

  @override
  String get legalConsentText =>
      'I have read the privacy notice, privacy policy and terms of use, and I agree to process patient data only for diagnosis and treatment, in compliance with data protection law.';

  @override
  String get legalConsentRequired => 'You must agree to continue';

  @override
  String get privacyNotice => 'Privacy notice';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsLegalSection => 'Legal';

  @override
  String supportEmail(String email) {
    return 'Support: $email';
  }

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get settingsDangerZone => 'Danger zone';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get deleteMyAccountSubtitle => 'Your account is permanently deleted';

  @override
  String accountInfoFailed(String error) {
    return 'Could not load account information: $error';
  }

  @override
  String get transferAdminTitle => 'Transfer admin rights first';

  @override
  String transferAdminBody(String clinics) {
    return 'You are the only admin of these clinics, which have other members:\n\n$clinics\n\nMake another member an admin on the Members screen, then try again.';
  }

  @override
  String get accountDeleted => 'Your account has been deleted';

  @override
  String accountDeleteFailed(String error) {
    return 'Could not delete account: $error';
  }

  @override
  String serverError(int status) {
    return 'Server error ($status)';
  }

  @override
  String get deleteAccountTitle => 'Permanently delete account';

  @override
  String get deleteAccountWarning =>
      'Your account and sign-in details will be deleted. This cannot be undone.';

  @override
  String get deleteAccountClinicsWarning =>
      'You are the only member of the clinics below. They will be deleted together with all patient records, procedures, photos and voice recordings:';

  @override
  String get deleteAccountMembershipOnly =>
      'Records in clinics you belong to stay with the clinic; only your membership ends.';

  @override
  String deleteAccountTypeToConfirm(String word) {
    return 'Type \"$word\" to confirm:';
  }

  @override
  String get deleteAccountConfirmWord => 'DELETE';

  @override
  String get deleteAccountButton => 'Delete account';

  @override
  String get errInvalidCredentials => 'Incorrect email or password';

  @override
  String get errAlreadyRegistered =>
      'This email is already registered. Please sign in.';

  @override
  String get errPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get errTooManyAttempts =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get errAlreadyMember => 'You are already a member of this clinic';

  @override
  String get errClinicCodeNotFound => 'Clinic code not found';

  @override
  String get errOnlyAdminCanApprove => 'Only the clinic admin can approve';

  @override
  String get errResetCodeInvalid =>
      'The code is wrong or has expired. Request a new code.';

  @override
  String get errSamePassword =>
      'The new password must be different from the old one';

  @override
  String get errSignupIncomplete =>
      'Sign-up could not be completed. Check your email verification.';

  @override
  String get errSessionRequired => 'Please sign in';

  @override
  String get errClinicCreateFailed => 'Could not create clinic';

  @override
  String get errRoleInvalid => 'Role must be doctor or assistant';

  @override
  String get errJoinRequestFailed => 'Could not create join request';

  @override
  String get errNotMember => 'You are not a member of this clinic';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get view => 'View';

  @override
  String get copy => 'Copy';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get remove => 'Remove';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get phoneOptionalLabel => 'Phone (optional)';

  @override
  String get noPhone => 'No phone';

  @override
  String loadFailed(String error) {
    return 'Could not load: $error';
  }

  @override
  String get clinicFallback => 'Clinic';

  @override
  String get recalls => 'Recalls';

  @override
  String get todos => 'To-dos';

  @override
  String get followUps => 'Follow-ups';

  @override
  String get reports => 'Reports';

  @override
  String get clinics => 'Clinics';

  @override
  String get newPatient => 'New patient';

  @override
  String get addPatient => 'Add patient';

  @override
  String get patientAdded => 'Patient added';

  @override
  String patientAddFailed(String error) {
    return 'Could not add patient: $error';
  }

  @override
  String get signOutTitle => 'Sign out';

  @override
  String get signOutConfirm => 'Do you want to sign out of your account?';

  @override
  String get myClinics => 'My clinics';

  @override
  String get copyCode => 'Copy code';

  @override
  String get activeClinicCode => 'Active clinic code';

  @override
  String get clinicCodeShareHint =>
      'Share the code; whoever joins waits for your approval and does not become a member right away.';

  @override
  String get joinRequests => 'Join requests';

  @override
  String joinRequestsCount(int count) {
    return 'Join requests ($count)';
  }

  @override
  String get members => 'Members';

  @override
  String get appearance => 'Appearance';

  @override
  String get treatmentTemplates => 'Procedure templates';

  @override
  String get addOrJoinClinic => 'Add / join another clinic';

  @override
  String followUpsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count follow-ups are due',
      one: '1 follow-up is due',
    );
    return '$_temp0';
  }

  @override
  String get followUpsOffline =>
      'No internet connection or the server is unreachable. Follow-ups could not be loaded.';

  @override
  String followUpsLoadFailed(String error) {
    return 'Could not load follow-ups: $error';
  }

  @override
  String get searchPatientsHint => 'Search patients (name or phone)…';

  @override
  String get sortByName => 'A–Z';

  @override
  String get sortByLastVisit => 'Last procedure';

  @override
  String get selectPatientHint => 'Select a patient to see details';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get colorPalette => 'Color palette';

  @override
  String get paletteClinic => 'Clinic blue';

  @override
  String get paletteClinicDesc => 'Calm clinical slate blue';

  @override
  String get paletteOcean => 'Ocean';

  @override
  String get paletteOceanDesc => 'Deep cyan, fresh and airy';

  @override
  String get paletteSage => 'Sage';

  @override
  String get paletteSageDesc => 'Muted green, soft and medical';

  @override
  String get paletteGraphite => 'Graphite';

  @override
  String get paletteGraphiteDesc => 'Neutral graphite with an ice-blue accent';

  @override
  String get paletteClassic => 'Classic green';

  @override
  String get paletteClassicDesc => 'Vivid green accent';

  @override
  String get patientsLoadFailed => 'Could not load patients.';

  @override
  String get noPatientsYet => 'No patients yet.\nAdd one from the top right.';

  @override
  String get noPatientsMatch => 'No patients match your search.';

  @override
  String get newProcedure => 'New procedure';

  @override
  String get procedureSaved => 'Procedure saved';

  @override
  String get plannedForNextSession => 'Planned for the next session';

  @override
  String get voiceNoteSaved => 'Voice note saved';

  @override
  String get editPatientTitle => 'Edit patient';

  @override
  String get deletePatientTitle => 'Delete patient';

  @override
  String deletePatientConfirm(String name) {
    return 'Delete $name and all related records?';
  }

  @override
  String patientDeleteFailed(String error) {
    return 'Could not delete patient: $error';
  }

  @override
  String get sharePdfTitle => 'Share treatment history';

  @override
  String get sharePdfWarning =>
      'The PDF contains the patient\'s health data. Send it only to the patient or, with their consent, to authorized persons.';

  @override
  String get createPdf => 'Create PDF';

  @override
  String followUpAdded(String title) {
    return 'Follow-up added: $title';
  }

  @override
  String get markedAsDone => 'Procedure marked as done';

  @override
  String completeFailed(String error) {
    return 'Could not complete: $error';
  }

  @override
  String followUpCompleteFailed(String error) {
    return 'Could not complete follow-up: $error';
  }

  @override
  String get deleteFollowUpTitle => 'Delete follow-up';

  @override
  String deleteItemConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String followUpDeleteFailed(String error) {
    return 'Could not delete follow-up: $error';
  }

  @override
  String get addFollowUp => 'Add follow-up';

  @override
  String get voiceNote => 'Voice note';

  @override
  String get shareAsPdf => 'Share as PDF';

  @override
  String plannedProcedures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Planned procedures ($count)',
      one: 'Planned procedure',
    );
    return '$_temp0';
  }

  @override
  String get markDone => 'Done';

  @override
  String dataLoadFailed(String error) {
    return 'Could not load data: $error';
  }

  @override
  String get noRecordsYet =>
      'No records yet.\nAdd a voice note or a procedure.';

  @override
  String get openFollowUps => 'Open follow-ups';

  @override
  String labReminderOn(String date) {
    return 'Lab reminder: $date';
  }

  @override
  String get complete => 'Complete';

  @override
  String get pendingVoiceNotes => 'Pending voice notes';

  @override
  String get procedureHistory => 'Procedure history';

  @override
  String get noProceduresYet => 'No procedures yet.';

  @override
  String get processedVoiceNotes => 'Processed voice notes';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String procedureCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count procedures',
      one: '1 procedure',
    );
    return '$_temp0';
  }

  @override
  String get manageCreateIntro =>
      'You open a new clinic and become its admin. Your other clinics are kept — you can switch between them.';

  @override
  String get manageJoinIntro =>
      'Enter the clinic code. You get access once the admin approves.';

  @override
  String clinicCreated(String name, String code) {
    return '$name created. Code: $code';
  }

  @override
  String get joinRequestSent =>
      'Join request sent. Waiting for admin approval.';

  @override
  String approvedName(String name) {
    return '$name approved';
  }

  @override
  String approveFailed(String error) {
    return 'Could not approve: $error';
  }

  @override
  String get rejectRequestTitle => 'Reject request';

  @override
  String rejectRequestConfirm(String name) {
    return 'Do you want to reject the request from $name?';
  }

  @override
  String rejectedName(String name) {
    return '$name rejected';
  }

  @override
  String rejectFailed(String error) {
    return 'Could not reject: $error';
  }

  @override
  String noPendingRequests(String clinic) {
    return 'No pending requests for $clinic.';
  }

  @override
  String wantsToJoinAs(String role) {
    return 'Wants to join as $role';
  }

  @override
  String get awaitingApprovalTitle => 'Awaiting approval';

  @override
  String get awaitingApprovalBody =>
      'Your join request is waiting for the clinic admin\'s approval. Once approved, you can continue from here.';

  @override
  String get refreshStatus => 'Refresh status';

  @override
  String get createOrJoinOtherClinic => 'Create / join another clinic';

  @override
  String get cannotChangeOwnAdmin => 'You cannot change your own admin role';

  @override
  String roleFor(String name) {
    return 'Role: $name';
  }

  @override
  String roleUpdateFailed(String error) {
    return 'Could not update role: $error';
  }

  @override
  String get cannotRemoveOwnAdmin =>
      'You cannot remove your admin account here';

  @override
  String get removeMemberTitle => 'Remove member';

  @override
  String removeMemberConfirm(String name) {
    return 'Remove $name from the clinic?';
  }

  @override
  String removeFailed(String error) {
    return 'Could not remove: $error';
  }

  @override
  String get clinicMembersTitle => 'Clinic members';

  @override
  String memberYou(String name) {
    return '$name (you)';
  }

  @override
  String get changeRole => 'Change role';

  @override
  String get scopeTooth => 'Tooth';

  @override
  String get scopeUpperJaw => 'Upper jaw';

  @override
  String get scopeLowerJaw => 'Lower jaw';

  @override
  String get scopeFullMouth => 'Full mouth';

  @override
  String scopeToothWithNumber(String teeth) {
    return 'Tooth: $teeth';
  }

  @override
  String get fieldScope => 'Scope';

  @override
  String get fieldTooth => 'Tooth';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldNote => 'Note';

  @override
  String get fieldCanalLength => 'Canal length';

  @override
  String get fieldFile => 'File';

  @override
  String get fieldMedicament => 'Medicament';

  @override
  String get fieldDate => 'Date';

  @override
  String photosAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos added',
      one: '1 photo added',
    );
    return '$_temp0';
  }

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos removed',
      one: '1 photo removed',
    );
    return '$_temp0';
  }

  @override
  String get canalMain => 'Main';

  @override
  String get handFile => 'Hand file';

  @override
  String get noMedicament => 'No medicament';

  @override
  String get errNoteConflict =>
      'This procedure was edited by someone else in the meantime. Refresh the list and try again.';

  @override
  String get errNoClinicSelected =>
      'No clinic selected — please sign in first.';

  @override
  String get errNoPermissionDeletePatient =>
      'You don\'t have permission to delete this patient';

  @override
  String get errNoPermissionDeleteNote =>
      'You don\'t have permission to delete this procedure';

  @override
  String labFollowUpTitle(String title) {
    return 'Lab: $title';
  }

  @override
  String labExpectedReturnOn(String date) {
    return 'Expected lab return: $date';
  }

  @override
  String labExpectedReturnFor(String date, String name) {
    return 'Expected lab return: $date · $name';
  }

  @override
  String get savingEllipsis => 'Saving…';

  @override
  String get procedureDate => 'Procedure date';

  @override
  String get select => 'Select';

  @override
  String get expectedLabReturn => 'Expected lab return';

  @override
  String get followUpDate => 'Check-up date';

  @override
  String get errSelectOrTypeProcedure => 'Select a procedure or type a title';

  @override
  String get errSelectScope => 'Select a scope';

  @override
  String get errSelectTooth => 'Select at least one tooth';

  @override
  String get errSelectLabDate => 'Select the expected lab return date';

  @override
  String get errSelectFollowUpDate => 'Select the check-up date';

  @override
  String get errFollowUpNoteRequired => 'Enter a follow-up note';

  @override
  String get uploadingPhotos => 'Uploading photos to the cloud…';

  @override
  String get savingProcedure => 'Saving procedure…';

  @override
  String uploadingPhotoProgress(int current, int total) {
    return 'Uploading photo ($current/$total)…';
  }

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get creatingLabReminder => 'Creating lab reminder…';

  @override
  String get creatingFollowUpReminder => 'Creating check-up reminder…';

  @override
  String followUpTitle(String title) {
    return 'Check-up: $title';
  }

  @override
  String get reminderKindLab => 'lab';

  @override
  String get reminderKindFollowUp => 'check-up';

  @override
  String reminderCreateFailed(String kinds) {
    return 'Procedure saved, but these reminders could not be created: $kinds. Add them from the Follow-ups screen.';
  }

  @override
  String get planForNextSession => 'Plan for next session';

  @override
  String saveTeethCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save $count teeth',
      one: 'Save 1 tooth',
    );
    return '$_temp0';
  }

  @override
  String get pastRecordHint => 'Past record (transferred from paper records)';

  @override
  String get change => 'Change';

  @override
  String get procedureSection => 'Procedure';

  @override
  String get procedureSectionHint =>
      'Select at least one procedure or type a title';

  @override
  String get procedureTitleLabel => 'Procedure title';

  @override
  String get noteOptionalLabel => 'Note (optional)';

  @override
  String get noteHint => 'Write here if needed…';

  @override
  String get addFollowUpSubtitle => 'Post-procedure check-up date and reminder';

  @override
  String get followUpNoteLabel => 'Follow-up note';

  @override
  String get followUpNoteHint => 'e.g. Percussion and radiographic check';

  @override
  String get presetOneWeek => '1 week';

  @override
  String get presetOneMonth => '1 month';

  @override
  String get presetThreeMonths => '3 months';

  @override
  String get presetSixMonths => '6 months';

  @override
  String get pickDate => 'Pick date';

  @override
  String get remindWhenLabel => 'When should we remind you?';

  @override
  String get remindOnDay => 'On the check-up day';

  @override
  String get remindOneDayBefore => '1 day before';

  @override
  String get remindThreeDaysBefore => '3 days before';

  @override
  String get remindOneWeekBefore => '1 week before';

  @override
  String followUpSummary(String date, String reminder) {
    return 'Check-up: $date · Reminder: $reminder';
  }

  @override
  String get scopeToothRequired =>
      'Tooth selection is required for this procedure';

  @override
  String get scopeRequired => 'Scope selection is required';

  @override
  String get scopeSuitable => 'Scope suited to the procedure';

  @override
  String get canalSelectToothFirst =>
      'Select a tooth first to enter canal parameters. With several teeth, each tooth is saved separately.';

  @override
  String get canalPerToothTitle => 'Canal details for each tooth';

  @override
  String get canalPerToothHint =>
      'Tap a tooth and enter its parameters. Each tooth is saved as a separate note.';

  @override
  String toothNumber(String tooth) {
    return 'Tooth $tooth';
  }

  @override
  String get photoSection => 'Photo';

  @override
  String get photoPrivacyHint =>
      'Do not show the patient\'s face. Only procedure / intraoral images.';

  @override
  String get planningSection => 'Planning';

  @override
  String get labCountsAsDone =>
      'If sent to the lab, the procedure counts as done';

  @override
  String get info => 'Info';

  @override
  String get planInfoLabBlocked =>
      'This option is unavailable while \'Sent to lab\' is checked; the procedure counts as done in this session.';

  @override
  String get planInfo =>
      'The procedure is treated as not done today. The patient is flagged at the top on their next visit; once marked “Done”, it is added to that day\'s procedure history.';

  @override
  String get sentToLab => 'Sent to lab';

  @override
  String get sentToLabInfo =>
      'Check this when the work is sent to the laboratory. The follow-up list and a notification remind you 1 day before the expected return date. With this option the procedure counts as done and “Plan for next session” is turned off.';

  @override
  String addExtraCanalForTooth(String tooth) {
    return 'Add extra canal · Tooth $tooth';
  }

  @override
  String get addExtraCanal => 'Add extra canal';

  @override
  String get extraCanalHint =>
      'Choose a canal that is not in the typical list, or type a custom name.';

  @override
  String get allStandardCanalsAdded =>
      'All standard codes are already added. Use a custom name.';

  @override
  String get customCanalName => 'Custom canal name';

  @override
  String get customCanalHint => 'e.g. MB3, DB2…';

  @override
  String get editProcedureTitle => 'Edit procedure';

  @override
  String editVersionHint(int version) {
    return 'v$version → saved as a new version; the old one is kept';
  }

  @override
  String get errTitleRequired => 'Procedure title is required';

  @override
  String get noChanges => 'No changes';

  @override
  String get saveAsNewVersion => 'Save as new version';

  @override
  String get quadrantUpperRight => 'Upper right';

  @override
  String get quadrantUpperLeft => 'Upper left';

  @override
  String get quadrantLowerRight => 'Lower right';

  @override
  String get quadrantLowerLeft => 'Lower left';

  @override
  String get toothNumberSection => 'Tooth number';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get typeToSelectLabel => 'Type to select (FDI)';

  @override
  String get typeToSelectHint => 'e.g. 15  or  14-17  or  36,37';

  @override
  String get apply => 'Apply';

  @override
  String get toothSelectorHelp =>
      'Tap: select · Long press: zoom quadrant · Swipe down or OK: close';

  @override
  String get jawUpper => 'UPPER';

  @override
  String get jawLower => 'LOWER';

  @override
  String get sideRight => 'Right';

  @override
  String get sideLeft => 'Left';

  @override
  String get selectTeeth => 'Select teeth';

  @override
  String selectedTeeth(String teeth) {
    return 'Selected: $teeth';
  }

  @override
  String get swipeDownToClose => 'You can also swipe down to close';

  @override
  String canalParamsForTooth(String tooth) {
    return 'Canal parameters · Tooth $tooth';
  }

  @override
  String get canalParamsTitle => 'Root canal treatment parameters';

  @override
  String get canalLengthMm => 'Canal length (mm)';

  @override
  String get extra => 'Extra';

  @override
  String get fileSystem => 'File system';

  @override
  String get intracanalMedicament => 'Intracanal medicament';

  @override
  String toothCanalHint(String tooth, String canals) {
    return 'Tooth $tooth · typical: $canals — add extras if needed';
  }

  @override
  String get newVersionSaved => 'New version saved';

  @override
  String get deleteProcedureTitle => 'Delete procedure';

  @override
  String get deleteProcedureConfirm =>
      'This note and any previous versions will be permanently deleted.';

  @override
  String get procedureDeleted => 'Procedure deleted';

  @override
  String procedureDeleteFailed(String error) {
    return 'Could not delete procedure: $error';
  }

  @override
  String get labShort => 'Lab';

  @override
  String labReturnShort(String date) {
    return 'Lab → $date';
  }

  @override
  String get history => 'History';

  @override
  String get share => 'Share';

  @override
  String get versionHistory => 'Version history';

  @override
  String historyLoadFailed(String error) {
    return 'Could not load history: $error';
  }

  @override
  String get noVersionsFound => 'No versions found';

  @override
  String get currentVersion => 'Current';

  @override
  String get oldVersion => 'Old version';

  @override
  String get changesInVersion => 'Changes in this version';

  @override
  String get firstRecord => 'First record';

  @override
  String get micPermissionRequired => 'Microphone permission is required';

  @override
  String get micPermissionMissing => 'No microphone permission';

  @override
  String get recordingEmpty => 'The recording is empty or could not be created';

  @override
  String voiceUploadFailed(String error) {
    return 'Could not upload the voice recording: $error';
  }

  @override
  String get quickVoiceNote => 'Quick voice note';

  @override
  String get voicePrivacyHint =>
      'Audio is only for the doctor\'s or assistant\'s procedure summary. Patient conversations are not recorded.';

  @override
  String get recordingInProgress => 'Recording…';

  @override
  String get uploadingVoice => 'Uploading audio to the cloud…';

  @override
  String get voiceStartHint =>
      'Tap the microphone and speak, then tap Finish & save';

  @override
  String get pleaseWait => 'Please wait…';

  @override
  String get finishAndSave => 'Finish & save';

  @override
  String playFailed(String error) {
    return 'Could not play: $error';
  }

  @override
  String get memoMarkedProcessed => 'Voice note marked as processed';

  @override
  String markFailed(String error) {
    return 'Could not mark: $error';
  }

  @override
  String get deleteVoiceNoteTitle => 'Delete voice note';

  @override
  String get deleteVoiceNoteConfirm =>
      'This voice note will be permanently deleted.';

  @override
  String deleteFailed(String error) {
    return 'Could not delete: $error';
  }

  @override
  String get processedVoiceNote => 'Processed voice note';

  @override
  String get pendingVoiceNote => 'Pending voice note';

  @override
  String durationLabel(String duration) {
    return 'Duration: $duration';
  }

  @override
  String get stop => 'Stop';

  @override
  String get listen => 'Listen';

  @override
  String get convertToNote => 'Convert to note';

  @override
  String get audioFileEmpty => 'The audio file is empty';

  @override
  String photoOpenFailed(String error) {
    return 'Could not open photo: $error';
  }

  @override
  String photoCount(int count, int max) {
    return '$count / $max photos';
  }

  @override
  String get takePhoto => 'Take photo';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get shareThisPhoto => 'Share this photo';

  @override
  String shareAllPhotos(int count) {
    return 'Share all photos ($count)';
  }

  @override
  String get procedurePhoto => 'Procedure photo';

  @override
  String procedurePhotoIndex(int index, int count) {
    return 'Procedure photo $index/$count';
  }

  @override
  String get shareTooltip => 'Share (WhatsApp, email…)';

  @override
  String get photoLoadFailed => 'Could not load photo';

  @override
  String preparingPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Preparing $count photos…',
      one: 'Preparing photo…',
    );
    return '$_temp0';
  }

  @override
  String shareFailed(String error) {
    return 'Could not share: $error';
  }

  @override
  String completedItem(String title) {
    return 'Completed: $title';
  }

  @override
  String actionFailed(String error) {
    return 'Action failed: $error';
  }

  @override
  String deletedItem(String title) {
    return 'Deleted: $title';
  }

  @override
  String patientOpenFailed(String error) {
    return 'Could not open patient: $error';
  }

  @override
  String get noOpenFollowUps => 'No open follow-ups.';

  @override
  String get sectionOverdue => 'Overdue';

  @override
  String get sectionReminderDue => 'Upcoming (reminder due)';

  @override
  String get sectionUpcoming => 'Upcoming';

  @override
  String get patientFallback => 'Patient';

  @override
  String reminderOn(String date) {
    return 'Reminder: $date';
  }

  @override
  String get goToPatient => 'Go to patient';

  @override
  String get errFollowUpTitleRequired => 'Enter a follow-up title';

  @override
  String get followUpWhatLabel => 'What needs follow-up?';

  @override
  String get followUpWhatHint => 'e.g. Check-up, suture removal, pain check…';

  @override
  String get whenLabel => 'When?';

  @override
  String notifFollowUpTitle(String name) {
    return 'Follow-up: $name';
  }

  @override
  String notifCheckupBody(String title, String date) {
    return '$title · Check-up: $date';
  }

  @override
  String get notifChannelFollowUps => 'Follow-ups';

  @override
  String get notifChannelFollowUpsDesc => 'Check-up and follow-up reminders';

  @override
  String get notifChannelClinic => 'Clinic notifications';

  @override
  String get notifChannelClinicDesc => 'Join, follow-up and to-do reminders';

  @override
  String get todoAdded => 'To-do added';

  @override
  String get noOpenTodos =>
      'No open to-dos.\nTap Add to create a text or voice note.';

  @override
  String get todosIntro =>
      'General clinic notes — appointments, callbacks, reminders…';

  @override
  String get sectionUndated => 'No date';

  @override
  String get filterAll => 'All';

  @override
  String get filterMine => 'Assigned to me';

  @override
  String get filterTodayOverdue => 'Today/overdue';

  @override
  String get filterCompleted => 'Completed';

  @override
  String commentAddFailed(String error) {
    return 'Could not add comment: $error';
  }

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get cameraPermissionRequired => 'Camera permission is required';

  @override
  String cameraOpenFailed(String error) {
    return 'Could not open camera: $error';
  }

  @override
  String galleryOpenFailed(String error) {
    return 'Could not open gallery: $error';
  }

  @override
  String imageAddFailed(String error) {
    return 'Could not add image: $error';
  }

  @override
  String imageOpenFailed(String error) {
    return 'Could not open image: $error';
  }

  @override
  String get deleteImageTitle => 'Delete image';

  @override
  String get deleteImageConfirm => 'Remove this image from the task?';

  @override
  String imageDeleteFailed(String error) {
    return 'Could not delete image: $error';
  }

  @override
  String get todoDetailTitle => 'To-do details';

  @override
  String get refresh => 'Refresh';

  @override
  String get markAsCompleted => 'Mark as completed';

  @override
  String get wholeClinic => 'Whole clinic';

  @override
  String get clinicMemberFallback => 'Clinic member';

  @override
  String createdByOn(String name, String date) {
    return 'Created by $name on $date';
  }

  @override
  String get images => 'Images';

  @override
  String get noImages => 'No images added';

  @override
  String commentsCount(int count) {
    return 'Comments ($count)';
  }

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String get addCommentHint => 'Add a comment…';

  @override
  String get noHistory => 'No history yet';

  @override
  String get eventCreated => 'Task created';

  @override
  String get eventCompleted => 'Task completed';

  @override
  String get eventCommentAdded => 'Comment added';

  @override
  String get eventImageAdded => 'Image added';

  @override
  String get eventImageDeleted => 'Image removed';

  @override
  String get completedMessage => 'Completed';

  @override
  String get deleteTodoConfirm => 'Delete this to-do?';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityImportant => 'Important';

  @override
  String get priorityUrgent => 'Urgent';

  @override
  String get recurrenceNone => 'Does not repeat';

  @override
  String get recurrenceDaily => 'Every day';

  @override
  String get recurrenceWeekly => 'Every week';

  @override
  String get recurrenceMonthly => 'Every month';

  @override
  String get voiceTodo => 'Voice to-do';

  @override
  String get todoFallback => 'To-do';

  @override
  String previewPlayFailed(String error) {
    return 'Could not play preview: $error';
  }

  @override
  String get taskTime => 'Task time';

  @override
  String get errTextOrVoiceRequired => 'Write a note or record audio';

  @override
  String get errFinishRecordingFirst => 'Finish the recording first';

  @override
  String get addTodo => 'Add to-do';

  @override
  String get todoNoteHint =>
      'e.g. Book Mr. Smith an appointment tomorrow, call the patient back…';

  @override
  String get voiceOptional => 'Audio (optional)';

  @override
  String get finish => 'Finish';

  @override
  String voiceRecorded(String duration) {
    return 'Audio recorded · $duration';
  }

  @override
  String get reRecord => 'Record again';

  @override
  String get recordVoice => 'Record audio';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String targetDate(String date) {
    return 'Target: $date';
  }

  @override
  String get priority => 'Priority';

  @override
  String get addTime => 'Add time';

  @override
  String get assignee => 'Assignee';

  @override
  String get patientLinkOptional => 'Linked patient (optional)';

  @override
  String get noPatientSelected => 'No patient selected';

  @override
  String get recurrence => 'Repeat';

  @override
  String get reminder => 'Reminder';

  @override
  String get remindOnTime => 'On time';

  @override
  String get remindOneHourBefore => '1 hour before';

  @override
  String get errCommentEmpty => 'Comment cannot be empty';

  @override
  String get recurringTask => 'Recurring task';

  @override
  String get errInvalidFilePath => 'Invalid file path';

  @override
  String get periodThisWeek => 'This week';

  @override
  String get periodLastWeek => 'Last week';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get periodLastMonth => 'Last month';

  @override
  String get reportPeriod => 'Report period';

  @override
  String comparedWith(String range) {
    return 'Compared with: $range';
  }

  @override
  String get topProcedures => 'Most performed procedures';

  @override
  String get noProceduresInPeriod => 'No procedures recorded in this period.';

  @override
  String get byCategory => 'By category';

  @override
  String get dailyActivity => 'Activity by day';

  @override
  String get followUpStatus => 'Follow-up status';

  @override
  String get patientsToRecall => 'Patients to call back';

  @override
  String daysPlus(int days) {
    return '$days+ days';
  }

  @override
  String get noRecallsDue => 'No patients are due for a check-up.';

  @override
  String recallsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count patients are due for a check-up',
      one: '1 patient is due for a check-up',
    );
    return '$_temp0';
  }

  @override
  String oldRecallsCount(int count) {
    return '+ $count older patients (check-up date passed more than 12 months ago)';
  }

  @override
  String get openList => 'Open list';

  @override
  String get statProceduresDone => 'Procedures performed';

  @override
  String get statProceduresHint =>
      'Multi-tooth procedures are counted per tooth';

  @override
  String get statPatientsTreated => 'Patients treated';

  @override
  String get statVisits => 'Patient visits';

  @override
  String get statVisitsHint =>
      'Visits by the same patient on different days are counted separately';

  @override
  String get statNewPatients => 'New patients';

  @override
  String get statTotalPatients => 'Total patients';

  @override
  String get statPendingPlanned => 'Pending planned procedures';

  @override
  String get sameAsPrevious => 'Same as previous period';

  @override
  String weekOf(String label) {
    return 'Week of $label';
  }

  @override
  String busiestDay(String day, String procedures) {
    return 'Busiest day: $day ($procedures)';
  }

  @override
  String overdueCount(int count) {
    return '$count overdue';
  }

  @override
  String get labPending => 'Work pending at the lab';

  @override
  String get controlPending => 'Pending check-ups';

  @override
  String get openTasks => 'Open tasks';

  @override
  String completedInPeriod(int lab, int control, int task) {
    return 'Completed in this period — lab: $lab, check-ups: $control, tasks: $task';
  }

  @override
  String stalledHint(int days) {
    return 'Patients with planned procedures who haven\'t visited for $days days and have no future check-up.';
  }

  @override
  String get noPatientsToRecall => 'No patients to call back.';

  @override
  String lastProcedure(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
      zero: 'today',
    );
    return 'Last procedure: $date ($_temp0)';
  }

  @override
  String plannedList(String items) {
    return 'Planned: $items';
  }

  @override
  String callPhone(String phone) {
    return 'Call: $phone';
  }

  @override
  String firstNPatients(int count) {
    return 'Showing the first $count patients.';
  }

  @override
  String get moreAfterLogging => 'More appear as you record call results.';

  @override
  String get call => 'Call';

  @override
  String get recallResultAppointment => 'Appointment given';

  @override
  String get recallResultUnreachable => 'Unreachable';

  @override
  String get recallResultDeclined => 'Declined';

  @override
  String get recallAppointmentHint =>
      'Pick a check-up date; a follow-up is created';

  @override
  String get recallUnreachableHint => 'Returns to the list in 7 days';

  @override
  String get recallDeclinedHint =>
      'Hidden from the list until a new procedure is done';

  @override
  String get openPatientCard => 'Open patient card';

  @override
  String recallLogged(String name, String result) {
    return '$name: saved as \"$result\"';
  }

  @override
  String get undo => 'Undo';

  @override
  String undoFailed(String error) {
    return 'Could not undo: $error';
  }

  @override
  String recallDateHelp(String name) {
    return '$name · check-up date';
  }

  @override
  String get periodicCheckup => 'Periodic check-up';

  @override
  String checkupReason(String procedure, String date) {
    return 'Check-up reason: $procedure ($date)';
  }

  @override
  String checkupScheduled(String name, String date) {
    return '$name: check-up scheduled for $date';
  }

  @override
  String appointmentSaveFailed(String error) {
    return 'Could not save appointment: $error';
  }

  @override
  String get recallCurrent => 'Current';

  @override
  String get recallOld => 'Older patients';

  @override
  String get recallOldHint =>
      'Patients whose check-up date passed more than 12 months ago. They are listed separately because they haven\'t visited for a long time.';

  @override
  String get recallCurrentHint =>
      'Patients whose check-up period after a procedure has expired. Periods are set on the Procedure templates screen. Patients with an appointment, a planned procedure or a future follow-up are not listed.';

  @override
  String get noOldRecalls => 'No older patients are awaiting a check-up.';

  @override
  String checkupDue(String date) {
    return 'Check-up: $date';
  }

  @override
  String checkupOverdue(String date, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months overdue',
      one: '1 month overdue',
    );
    return 'Check-up: $date ($_temp0)';
  }

  @override
  String lastCall(String result) {
    return 'Last call: $result';
  }

  @override
  String get noMissingDefaults => 'No missing defaults';

  @override
  String defaultsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count default procedures added',
      one: '1 default procedure added',
    );
    return '$_temp0';
  }

  @override
  String addFailed(String error) {
    return 'Could not add: $error';
  }

  @override
  String updateFailed(String error) {
    return 'Could not update: $error';
  }

  @override
  String deleteTemplateConfirm(String name) {
    return 'Remove \"$name\" from the list?\nPast patient records are not affected.';
  }

  @override
  String get seedMissingTooltip => 'Restore missing defaults';

  @override
  String get hideInactive => 'Hide inactive';

  @override
  String get showInactive => 'Show inactive';

  @override
  String get addProcedure => 'Add procedure';

  @override
  String get templatesIntro =>
      'The clinic\'s procedure list. These appear in the new procedure form. Past records don\'t change.';

  @override
  String get templatesEditRestricted => 'Only doctors or admins can edit.';

  @override
  String get tagCanal => 'Root canal';

  @override
  String get tagToothRequired => 'Tooth required';

  @override
  String get tagJawOk => 'Jaw/mouth OK';

  @override
  String get tagLabTracking => 'Lab tracking';

  @override
  String tagCheckupMonths(int months) {
    return 'Check-up: $months mo';
  }

  @override
  String get tagInactive => 'Inactive';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get activate => 'Activate';

  @override
  String get noTemplatesYet => 'No procedures yet.';

  @override
  String get category => 'Category';

  @override
  String get procedureName => 'Procedure name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get canalProcedure => 'Root canal procedure';

  @override
  String get canalProcedureHint => 'Shows canal length / file fields';

  @override
  String get toothRequired => 'Tooth selection required';

  @override
  String get toothRequiredHint =>
      'If off, upper/lower jaw or full mouth can be selected';

  @override
  String get labTracking => 'Lab tracking';

  @override
  String get labTrackingHint =>
      'Shows “Sent to lab” and the return date in the new procedure form';

  @override
  String get periodicCheckupHelper =>
      'After this procedure the patient is added to the recall list';

  @override
  String get none => 'None';

  @override
  String monthsAfter(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months later',
      one: '1 month later',
    );
    return '$_temp0';
  }

  @override
  String get active => 'Active';

  @override
  String get catDiagnosis => 'Diagnosis and planning';

  @override
  String get catTreatment => 'Treatment';

  @override
  String get catProsthetics => 'Prosthetics';

  @override
  String get catGeneral => 'General';

  @override
  String pdfDocTitle(String name) {
    return 'Treatment history - $name';
  }

  @override
  String pdfHeader(String name) {
    return '$name · Treatment history';
  }

  @override
  String get pdfConfidential =>
      'Confidential: contains special category personal data (health data).';

  @override
  String pdfPage(int page, int total) {
    return 'Page $page / $total';
  }

  @override
  String get pdfSubtitle => 'Patient treatment history';

  @override
  String get pdfRegistered => 'Registered';

  @override
  String get pdfReportDate => 'Report date';

  @override
  String pdfPreparedBy(String name) {
    return 'Prepared by: $name';
  }

  @override
  String pdfDoneProcedures(int count) {
    return 'Procedures performed ($count)';
  }

  @override
  String get pdfNoProcedures => 'No procedures recorded.';

  @override
  String pdfPlannedProcedures(int count) {
    return 'Planned procedures ($count)';
  }

  @override
  String get pdfColAdded => 'Added';

  @override
  String get pdfColDetails => 'Details';

  @override
  String pdfLabReturn(String date) {
    return 'Lab · return $date';
  }

  @override
  String photoCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get preparingPdf => 'Preparing PDF…';

  @override
  String get pdfFilePrefix => 'treatment_history';

  @override
  String pdfCreateFailed(String error) {
    return 'Could not create PDF: $error';
  }

  @override
  String get pdfTreatmentHistory => 'Treatment history';
}
