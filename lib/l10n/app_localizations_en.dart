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
}
