import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settingsAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Settings and account'**
  String get settingsAndAccount;

  /// No description provided for @linkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open link: {url}'**
  String linkOpenFailed(String url);

  /// No description provided for @clinicCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Clinic code copied: {code}'**
  String clinicCodeCopied(String code);

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get roleDoctor;

  /// No description provided for @roleAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get roleAssistant;

  /// No description provided for @joinStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get joinStatusPending;

  /// No description provided for @joinStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get joinStatusApproved;

  /// No description provided for @joinStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get joinStatusRejected;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account / Join a clinic'**
  String get loginCreateAccount;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get loginFailed;

  /// No description provided for @clinicRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinic required'**
  String get clinicRequiredTitle;

  /// No description provided for @serverUnreachableTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server'**
  String get serverUnreachableTitle;

  /// No description provided for @serverUnreachableBody.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get serverUnreachableBody;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupTitle;

  /// No description provided for @createClinic.
  ///
  /// In en, this message translates to:
  /// **'Create clinic'**
  String get createClinic;

  /// No description provided for @joinClinic.
  ///
  /// In en, this message translates to:
  /// **'Join a clinic'**
  String get joinClinic;

  /// No description provided for @signupCreateIntro.
  ///
  /// In en, this message translates to:
  /// **'You open a new clinic and become its admin and doctor. You invite assistants with the clinic code.'**
  String get signupCreateIntro;

  /// No description provided for @clinicNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinic name'**
  String get clinicNameLabel;

  /// No description provided for @clinicNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Clinic name is required'**
  String get clinicNameRequired;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @signupJoinIntro.
  ///
  /// In en, this message translates to:
  /// **'Send a join request with the clinic code you got from the admin. You get access once the admin approves.'**
  String get signupJoinIntro;

  /// No description provided for @clinicCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinic code'**
  String get clinicCodeLabel;

  /// No description provided for @clinicCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. A3K9PX'**
  String get clinicCodeHint;

  /// No description provided for @clinicCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Code is required'**
  String get clinicCodeRequired;

  /// No description provided for @myRole.
  ///
  /// In en, this message translates to:
  /// **'My role'**
  String get myRole;

  /// No description provided for @joinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinButton;

  /// No description provided for @resetCodeSent.
  ///
  /// In en, this message translates to:
  /// **'If the address is registered, a code has been sent to your email'**
  String get resetCodeSent;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated'**
  String get passwordUpdated;

  /// No description provided for @resetIntroEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your account\'s email address and we\'ll send you a reset code.'**
  String get resetIntroEmail;

  /// No description provided for @resetIntroCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your email and your new password.'**
  String get resetIntroCode;

  /// No description provided for @resetCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get resetCodeLabel;

  /// No description provided for @resetCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from the email'**
  String get resetCodeInvalid;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @newPasswordRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'New password (again)'**
  String get newPasswordRepeatLabel;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePasswordButton;

  /// No description provided for @sendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCodeButton;

  /// No description provided for @resetRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Request a new code / change email'**
  String get resetRequestNewCode;

  /// No description provided for @legalConsentText.
  ///
  /// In en, this message translates to:
  /// **'I have read the privacy notice, privacy policy and terms of use, and I agree to process patient data only for diagnosis and treatment, in compliance with data protection law.'**
  String get legalConsentText;

  /// No description provided for @legalConsentRequired.
  ///
  /// In en, this message translates to:
  /// **'You must agree to continue'**
  String get legalConsentRequired;

  /// No description provided for @privacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Privacy notice'**
  String get privacyNotice;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSection;

  /// No description provided for @settingsLegalSection.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settingsLegalSection;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Support: {email}'**
  String supportEmail(String email);

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get languageSystem;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settingsDangerZone;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @deleteMyAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is permanently deleted'**
  String get deleteMyAccountSubtitle;

  /// No description provided for @accountInfoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load account information: {error}'**
  String accountInfoFailed(String error);

  /// No description provided for @transferAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer admin rights first'**
  String get transferAdminTitle;

  /// No description provided for @transferAdminBody.
  ///
  /// In en, this message translates to:
  /// **'You are the only admin of these clinics, which have other members:\n\n{clinics}\n\nMake another member an admin on the Members screen, then try again.'**
  String transferAdminBody(String clinics);

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get accountDeleted;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete account: {error}'**
  String accountDeleteFailed(String error);

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error ({status})'**
  String serverError(int status);

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Your account and sign-in details will be deleted. This cannot be undone.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountClinicsWarning.
  ///
  /// In en, this message translates to:
  /// **'You are the only member of the clinics below. They will be deleted together with all patient records, procedures, photos and voice recordings:'**
  String get deleteAccountClinicsWarning;

  /// No description provided for @deleteAccountMembershipOnly.
  ///
  /// In en, this message translates to:
  /// **'Records in clinics you belong to stay with the clinic; only your membership ends.'**
  String get deleteAccountMembershipOnly;

  /// No description provided for @deleteAccountTypeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type \"{word}\" to confirm:'**
  String deleteAccountTypeToConfirm(String word);

  /// No description provided for @deleteAccountConfirmWord.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAccountConfirmWord;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountButton;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get errInvalidCredentials;

  /// No description provided for @errAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please sign in.'**
  String get errAlreadyRegistered;

  /// No description provided for @errPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errPasswordTooShort;

  /// No description provided for @errTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment and try again.'**
  String get errTooManyAttempts;

  /// No description provided for @errAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this clinic'**
  String get errAlreadyMember;

  /// No description provided for @errClinicCodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Clinic code not found'**
  String get errClinicCodeNotFound;

  /// No description provided for @errOnlyAdminCanApprove.
  ///
  /// In en, this message translates to:
  /// **'Only the clinic admin can approve'**
  String get errOnlyAdminCanApprove;

  /// No description provided for @errResetCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'The code is wrong or has expired. Request a new code.'**
  String get errResetCodeInvalid;

  /// No description provided for @errSamePassword.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the old one'**
  String get errSamePassword;

  /// No description provided for @errSignupIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Sign-up could not be completed. Check your email verification.'**
  String get errSignupIncomplete;

  /// No description provided for @errSessionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in'**
  String get errSessionRequired;

  /// No description provided for @errClinicCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create clinic'**
  String get errClinicCreateFailed;

  /// No description provided for @errRoleInvalid.
  ///
  /// In en, this message translates to:
  /// **'Role must be doctor or assistant'**
  String get errRoleInvalid;

  /// No description provided for @errJoinRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create join request'**
  String get errJoinRequestFailed;

  /// No description provided for @errNotMember.
  ///
  /// In en, this message translates to:
  /// **'You are not a member of this clinic'**
  String get errNotMember;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptionalLabel;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get noPhone;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load: {error}'**
  String loadFailed(String error);

  /// No description provided for @clinicFallback.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinicFallback;

  /// No description provided for @recalls.
  ///
  /// In en, this message translates to:
  /// **'Recalls'**
  String get recalls;

  /// No description provided for @todos.
  ///
  /// In en, this message translates to:
  /// **'To-dos'**
  String get todos;

  /// No description provided for @followUps.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups'**
  String get followUps;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @clinics.
  ///
  /// In en, this message translates to:
  /// **'Clinics'**
  String get clinics;

  /// No description provided for @newPatient.
  ///
  /// In en, this message translates to:
  /// **'New patient'**
  String get newPatient;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add patient'**
  String get addPatient;

  /// No description provided for @patientAdded.
  ///
  /// In en, this message translates to:
  /// **'Patient added'**
  String get patientAdded;

  /// No description provided for @patientAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add patient: {error}'**
  String patientAddFailed(String error);

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutTitle;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to sign out of your account?'**
  String get signOutConfirm;

  /// No description provided for @myClinics.
  ///
  /// In en, this message translates to:
  /// **'My clinics'**
  String get myClinics;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// No description provided for @activeClinicCode.
  ///
  /// In en, this message translates to:
  /// **'Active clinic code'**
  String get activeClinicCode;

  /// No description provided for @clinicCodeShareHint.
  ///
  /// In en, this message translates to:
  /// **'Share the code; whoever joins waits for your approval and does not become a member right away.'**
  String get clinicCodeShareHint;

  /// No description provided for @joinRequests.
  ///
  /// In en, this message translates to:
  /// **'Join requests'**
  String get joinRequests;

  /// No description provided for @joinRequestsCount.
  ///
  /// In en, this message translates to:
  /// **'Join requests ({count})'**
  String joinRequestsCount(int count);

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @treatmentTemplates.
  ///
  /// In en, this message translates to:
  /// **'Procedure templates'**
  String get treatmentTemplates;

  /// No description provided for @addOrJoinClinic.
  ///
  /// In en, this message translates to:
  /// **'Add / join another clinic'**
  String get addOrJoinClinic;

  /// No description provided for @followUpsDue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 follow-up is due} other{{count} follow-ups are due}}'**
  String followUpsDue(int count);

  /// No description provided for @followUpsOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection or the server is unreachable. Follow-ups could not be loaded.'**
  String get followUpsOffline;

  /// No description provided for @followUpsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load follow-ups: {error}'**
  String followUpsLoadFailed(String error);

  /// No description provided for @searchPatientsHint.
  ///
  /// In en, this message translates to:
  /// **'Search patients (name or phone)…'**
  String get searchPatientsHint;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get sortByName;

  /// No description provided for @sortByLastVisit.
  ///
  /// In en, this message translates to:
  /// **'Last procedure'**
  String get sortByLastVisit;

  /// No description provided for @selectPatientHint.
  ///
  /// In en, this message translates to:
  /// **'Select a patient to see details'**
  String get selectPatientHint;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @colorPalette.
  ///
  /// In en, this message translates to:
  /// **'Color palette'**
  String get colorPalette;

  /// No description provided for @paletteClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic blue'**
  String get paletteClinic;

  /// No description provided for @paletteClinicDesc.
  ///
  /// In en, this message translates to:
  /// **'Calm clinical slate blue'**
  String get paletteClinicDesc;

  /// No description provided for @paletteOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get paletteOcean;

  /// No description provided for @paletteOceanDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep cyan, fresh and airy'**
  String get paletteOceanDesc;

  /// No description provided for @paletteSage.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get paletteSage;

  /// No description provided for @paletteSageDesc.
  ///
  /// In en, this message translates to:
  /// **'Muted green, soft and medical'**
  String get paletteSageDesc;

  /// No description provided for @paletteGraphite.
  ///
  /// In en, this message translates to:
  /// **'Graphite'**
  String get paletteGraphite;

  /// No description provided for @paletteGraphiteDesc.
  ///
  /// In en, this message translates to:
  /// **'Neutral graphite with an ice-blue accent'**
  String get paletteGraphiteDesc;

  /// No description provided for @paletteClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic green'**
  String get paletteClassic;

  /// No description provided for @paletteClassicDesc.
  ///
  /// In en, this message translates to:
  /// **'Vivid green accent'**
  String get paletteClassicDesc;

  /// No description provided for @patientsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load patients.'**
  String get patientsLoadFailed;

  /// No description provided for @noPatientsYet.
  ///
  /// In en, this message translates to:
  /// **'No patients yet.\nAdd one from the top right.'**
  String get noPatientsYet;

  /// No description provided for @noPatientsMatch.
  ///
  /// In en, this message translates to:
  /// **'No patients match your search.'**
  String get noPatientsMatch;

  /// No description provided for @newProcedure.
  ///
  /// In en, this message translates to:
  /// **'New procedure'**
  String get newProcedure;

  /// No description provided for @procedureSaved.
  ///
  /// In en, this message translates to:
  /// **'Procedure saved'**
  String get procedureSaved;

  /// No description provided for @plannedForNextSession.
  ///
  /// In en, this message translates to:
  /// **'Planned for the next session'**
  String get plannedForNextSession;

  /// No description provided for @voiceNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'Voice note saved'**
  String get voiceNoteSaved;

  /// No description provided for @editPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit patient'**
  String get editPatientTitle;

  /// No description provided for @deletePatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete patient'**
  String get deletePatientTitle;

  /// No description provided for @deletePatientConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name} and all related records?'**
  String deletePatientConfirm(String name);

  /// No description provided for @patientDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete patient: {error}'**
  String patientDeleteFailed(String error);

  /// No description provided for @sharePdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Share treatment history'**
  String get sharePdfTitle;

  /// No description provided for @sharePdfWarning.
  ///
  /// In en, this message translates to:
  /// **'The PDF contains the patient\'s health data. Send it only to the patient or, with their consent, to authorized persons.'**
  String get sharePdfWarning;

  /// No description provided for @createPdf.
  ///
  /// In en, this message translates to:
  /// **'Create PDF'**
  String get createPdf;

  /// No description provided for @followUpAdded.
  ///
  /// In en, this message translates to:
  /// **'Follow-up added: {title}'**
  String followUpAdded(String title);

  /// No description provided for @markedAsDone.
  ///
  /// In en, this message translates to:
  /// **'Procedure marked as done'**
  String get markedAsDone;

  /// No description provided for @completeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete: {error}'**
  String completeFailed(String error);

  /// No description provided for @followUpCompleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete follow-up: {error}'**
  String followUpCompleteFailed(String error);

  /// No description provided for @deleteFollowUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete follow-up'**
  String get deleteFollowUpTitle;

  /// No description provided for @deleteItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteItemConfirm(String name);

  /// No description provided for @followUpDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete follow-up: {error}'**
  String followUpDeleteFailed(String error);

  /// No description provided for @addFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Add follow-up'**
  String get addFollowUp;

  /// No description provided for @voiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get voiceNote;

  /// No description provided for @shareAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Share as PDF'**
  String get shareAsPdf;

  /// No description provided for @plannedProcedures.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Planned procedure} other{Planned procedures ({count})}}'**
  String plannedProcedures(int count);

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get markDone;

  /// No description provided for @dataLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load data: {error}'**
  String dataLoadFailed(String error);

  /// No description provided for @noRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No records yet.\nAdd a voice note or a procedure.'**
  String get noRecordsYet;

  /// No description provided for @openFollowUps.
  ///
  /// In en, this message translates to:
  /// **'Open follow-ups'**
  String get openFollowUps;

  /// No description provided for @labReminderOn.
  ///
  /// In en, this message translates to:
  /// **'Lab reminder: {date}'**
  String labReminderOn(String date);

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @pendingVoiceNotes.
  ///
  /// In en, this message translates to:
  /// **'Pending voice notes'**
  String get pendingVoiceNotes;

  /// No description provided for @procedureHistory.
  ///
  /// In en, this message translates to:
  /// **'Procedure history'**
  String get procedureHistory;

  /// No description provided for @noProceduresYet.
  ///
  /// In en, this message translates to:
  /// **'No procedures yet.'**
  String get noProceduresYet;

  /// No description provided for @processedVoiceNotes.
  ///
  /// In en, this message translates to:
  /// **'Processed voice notes'**
  String get processedVoiceNotes;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @procedureCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 procedure} other{{count} procedures}}'**
  String procedureCount(int count);

  /// No description provided for @manageCreateIntro.
  ///
  /// In en, this message translates to:
  /// **'You open a new clinic and become its admin. Your other clinics are kept — you can switch between them.'**
  String get manageCreateIntro;

  /// No description provided for @manageJoinIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the clinic code. You get access once the admin approves.'**
  String get manageJoinIntro;

  /// No description provided for @clinicCreated.
  ///
  /// In en, this message translates to:
  /// **'{name} created. Code: {code}'**
  String clinicCreated(String name, String code);

  /// No description provided for @joinRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Join request sent. Waiting for admin approval.'**
  String get joinRequestSent;

  /// No description provided for @approvedName.
  ///
  /// In en, this message translates to:
  /// **'{name} approved'**
  String approvedName(String name);

  /// No description provided for @approveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not approve: {error}'**
  String approveFailed(String error);

  /// No description provided for @rejectRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject request'**
  String get rejectRequestTitle;

  /// No description provided for @rejectRequestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reject the request from {name}?'**
  String rejectRequestConfirm(String name);

  /// No description provided for @rejectedName.
  ///
  /// In en, this message translates to:
  /// **'{name} rejected'**
  String rejectedName(String name);

  /// No description provided for @rejectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reject: {error}'**
  String rejectFailed(String error);

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests for {clinic}.'**
  String noPendingRequests(String clinic);

  /// No description provided for @wantsToJoinAs.
  ///
  /// In en, this message translates to:
  /// **'Wants to join as {role}'**
  String wantsToJoinAs(String role);

  /// No description provided for @awaitingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get awaitingApprovalTitle;

  /// No description provided for @awaitingApprovalBody.
  ///
  /// In en, this message translates to:
  /// **'Your join request is waiting for the clinic admin\'s approval. Once approved, you can continue from here.'**
  String get awaitingApprovalBody;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh status'**
  String get refreshStatus;

  /// No description provided for @createOrJoinOtherClinic.
  ///
  /// In en, this message translates to:
  /// **'Create / join another clinic'**
  String get createOrJoinOtherClinic;

  /// No description provided for @cannotChangeOwnAdmin.
  ///
  /// In en, this message translates to:
  /// **'You cannot change your own admin role'**
  String get cannotChangeOwnAdmin;

  /// No description provided for @roleFor.
  ///
  /// In en, this message translates to:
  /// **'Role: {name}'**
  String roleFor(String name);

  /// No description provided for @roleUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update role: {error}'**
  String roleUpdateFailed(String error);

  /// No description provided for @cannotRemoveOwnAdmin.
  ///
  /// In en, this message translates to:
  /// **'You cannot remove your admin account here'**
  String get cannotRemoveOwnAdmin;

  /// No description provided for @removeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMemberTitle;

  /// No description provided for @removeMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the clinic?'**
  String removeMemberConfirm(String name);

  /// No description provided for @removeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove: {error}'**
  String removeFailed(String error);

  /// No description provided for @clinicMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinic members'**
  String get clinicMembersTitle;

  /// No description provided for @memberYou.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String memberYou(String name);

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get changeRole;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ru',
        'tr'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
