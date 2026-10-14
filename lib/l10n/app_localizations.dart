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

  /// No description provided for @scopeTooth.
  ///
  /// In en, this message translates to:
  /// **'Tooth'**
  String get scopeTooth;

  /// No description provided for @scopeUpperJaw.
  ///
  /// In en, this message translates to:
  /// **'Upper jaw'**
  String get scopeUpperJaw;

  /// No description provided for @scopeLowerJaw.
  ///
  /// In en, this message translates to:
  /// **'Lower jaw'**
  String get scopeLowerJaw;

  /// No description provided for @scopeFullMouth.
  ///
  /// In en, this message translates to:
  /// **'Full mouth'**
  String get scopeFullMouth;

  /// No description provided for @scopeToothWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Tooth: {teeth}'**
  String scopeToothWithNumber(String teeth);

  /// No description provided for @fieldScope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get fieldScope;

  /// No description provided for @fieldTooth.
  ///
  /// In en, this message translates to:
  /// **'Tooth'**
  String get fieldTooth;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get fieldNote;

  /// No description provided for @fieldCanalLength.
  ///
  /// In en, this message translates to:
  /// **'Canal length'**
  String get fieldCanalLength;

  /// No description provided for @fieldFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fieldFile;

  /// No description provided for @fieldMedicament.
  ///
  /// In en, this message translates to:
  /// **'Medicament'**
  String get fieldMedicament;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @photosAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo added} other{{count} photos added}}'**
  String photosAdded(int count);

  /// No description provided for @photosRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo removed} other{{count} photos removed}}'**
  String photosRemoved(int count);

  /// No description provided for @canalMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get canalMain;

  /// No description provided for @handFile.
  ///
  /// In en, this message translates to:
  /// **'Hand file'**
  String get handFile;

  /// No description provided for @noMedicament.
  ///
  /// In en, this message translates to:
  /// **'No medicament'**
  String get noMedicament;

  /// No description provided for @errNoteConflict.
  ///
  /// In en, this message translates to:
  /// **'This procedure was edited by someone else in the meantime. Refresh the list and try again.'**
  String get errNoteConflict;

  /// No description provided for @errNoClinicSelected.
  ///
  /// In en, this message translates to:
  /// **'No clinic selected — please sign in first.'**
  String get errNoClinicSelected;

  /// No description provided for @errNoPermissionDeletePatient.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to delete this patient'**
  String get errNoPermissionDeletePatient;

  /// No description provided for @errNoPermissionDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to delete this procedure'**
  String get errNoPermissionDeleteNote;

  /// No description provided for @labFollowUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab: {title}'**
  String labFollowUpTitle(String title);

  /// No description provided for @labExpectedReturnOn.
  ///
  /// In en, this message translates to:
  /// **'Expected lab return: {date}'**
  String labExpectedReturnOn(String date);

  /// No description provided for @labExpectedReturnFor.
  ///
  /// In en, this message translates to:
  /// **'Expected lab return: {date} · {name}'**
  String labExpectedReturnFor(String date, String name);

  /// No description provided for @savingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingEllipsis;

  /// No description provided for @procedureDate.
  ///
  /// In en, this message translates to:
  /// **'Procedure date'**
  String get procedureDate;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @expectedLabReturn.
  ///
  /// In en, this message translates to:
  /// **'Expected lab return'**
  String get expectedLabReturn;

  /// No description provided for @followUpDate.
  ///
  /// In en, this message translates to:
  /// **'Check-up date'**
  String get followUpDate;

  /// No description provided for @errSelectOrTypeProcedure.
  ///
  /// In en, this message translates to:
  /// **'Select a procedure or type a title'**
  String get errSelectOrTypeProcedure;

  /// No description provided for @errSelectScope.
  ///
  /// In en, this message translates to:
  /// **'Select a scope'**
  String get errSelectScope;

  /// No description provided for @errSelectTooth.
  ///
  /// In en, this message translates to:
  /// **'Select at least one tooth'**
  String get errSelectTooth;

  /// No description provided for @errSelectLabDate.
  ///
  /// In en, this message translates to:
  /// **'Select the expected lab return date'**
  String get errSelectLabDate;

  /// No description provided for @errSelectFollowUpDate.
  ///
  /// In en, this message translates to:
  /// **'Select the check-up date'**
  String get errSelectFollowUpDate;

  /// No description provided for @errFollowUpNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a follow-up note'**
  String get errFollowUpNoteRequired;

  /// No description provided for @uploadingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Uploading photos to the cloud…'**
  String get uploadingPhotos;

  /// No description provided for @savingProcedure.
  ///
  /// In en, this message translates to:
  /// **'Saving procedure…'**
  String get savingProcedure;

  /// No description provided for @uploadingPhotoProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo ({current}/{total})…'**
  String uploadingPhotoProgress(int current, int total);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(String error);

  /// No description provided for @creatingLabReminder.
  ///
  /// In en, this message translates to:
  /// **'Creating lab reminder…'**
  String get creatingLabReminder;

  /// No description provided for @creatingFollowUpReminder.
  ///
  /// In en, this message translates to:
  /// **'Creating check-up reminder…'**
  String get creatingFollowUpReminder;

  /// No description provided for @followUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-up: {title}'**
  String followUpTitle(String title);

  /// No description provided for @reminderKindLab.
  ///
  /// In en, this message translates to:
  /// **'lab'**
  String get reminderKindLab;

  /// No description provided for @reminderKindFollowUp.
  ///
  /// In en, this message translates to:
  /// **'check-up'**
  String get reminderKindFollowUp;

  /// No description provided for @reminderCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Procedure saved, but these reminders could not be created: {kinds}. Add them from the Follow-ups screen.'**
  String reminderCreateFailed(String kinds);

  /// No description provided for @planForNextSession.
  ///
  /// In en, this message translates to:
  /// **'Plan for next session'**
  String get planForNextSession;

  /// No description provided for @saveTeethCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Save 1 tooth} other{Save {count} teeth}}'**
  String saveTeethCount(int count);

  /// No description provided for @pastRecordHint.
  ///
  /// In en, this message translates to:
  /// **'Past record (transferred from paper records)'**
  String get pastRecordHint;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @procedureSection.
  ///
  /// In en, this message translates to:
  /// **'Procedure'**
  String get procedureSection;

  /// No description provided for @procedureSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Select at least one procedure or type a title'**
  String get procedureSectionHint;

  /// No description provided for @procedureTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Procedure title'**
  String get procedureTitleLabel;

  /// No description provided for @noteOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptionalLabel;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Write here if needed…'**
  String get noteHint;

  /// No description provided for @addFollowUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Post-procedure check-up date and reminder'**
  String get addFollowUpSubtitle;

  /// No description provided for @followUpNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow-up note'**
  String get followUpNoteLabel;

  /// No description provided for @followUpNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Percussion and radiographic check'**
  String get followUpNoteHint;

  /// No description provided for @presetOneWeek.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get presetOneWeek;

  /// No description provided for @presetOneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get presetOneMonth;

  /// No description provided for @presetThreeMonths.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get presetThreeMonths;

  /// No description provided for @presetSixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get presetSixMonths;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get pickDate;

  /// No description provided for @remindWhenLabel.
  ///
  /// In en, this message translates to:
  /// **'When should we remind you?'**
  String get remindWhenLabel;

  /// No description provided for @remindOnDay.
  ///
  /// In en, this message translates to:
  /// **'On the check-up day'**
  String get remindOnDay;

  /// No description provided for @remindOneDayBefore.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get remindOneDayBefore;

  /// No description provided for @remindThreeDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get remindThreeDaysBefore;

  /// No description provided for @remindOneWeekBefore.
  ///
  /// In en, this message translates to:
  /// **'1 week before'**
  String get remindOneWeekBefore;

  /// No description provided for @followUpSummary.
  ///
  /// In en, this message translates to:
  /// **'Check-up: {date} · Reminder: {reminder}'**
  String followUpSummary(String date, String reminder);

  /// No description provided for @scopeToothRequired.
  ///
  /// In en, this message translates to:
  /// **'Tooth selection is required for this procedure'**
  String get scopeToothRequired;

  /// No description provided for @scopeRequired.
  ///
  /// In en, this message translates to:
  /// **'Scope selection is required'**
  String get scopeRequired;

  /// No description provided for @scopeSuitable.
  ///
  /// In en, this message translates to:
  /// **'Scope suited to the procedure'**
  String get scopeSuitable;

  /// No description provided for @canalSelectToothFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a tooth first to enter canal parameters. With several teeth, each tooth is saved separately.'**
  String get canalSelectToothFirst;

  /// No description provided for @canalPerToothTitle.
  ///
  /// In en, this message translates to:
  /// **'Canal details for each tooth'**
  String get canalPerToothTitle;

  /// No description provided for @canalPerToothHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a tooth and enter its parameters. Each tooth is saved as a separate note.'**
  String get canalPerToothHint;

  /// No description provided for @toothNumber.
  ///
  /// In en, this message translates to:
  /// **'Tooth {tooth}'**
  String toothNumber(String tooth);

  /// No description provided for @photoSection.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoSection;

  /// No description provided for @photoPrivacyHint.
  ///
  /// In en, this message translates to:
  /// **'Do not show the patient\'s face. Only procedure / intraoral images.'**
  String get photoPrivacyHint;

  /// No description provided for @planningSection.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get planningSection;

  /// No description provided for @labCountsAsDone.
  ///
  /// In en, this message translates to:
  /// **'If sent to the lab, the procedure counts as done'**
  String get labCountsAsDone;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @planInfoLabBlocked.
  ///
  /// In en, this message translates to:
  /// **'This option is unavailable while \'Sent to lab\' is checked; the procedure counts as done in this session.'**
  String get planInfoLabBlocked;

  /// No description provided for @planInfo.
  ///
  /// In en, this message translates to:
  /// **'The procedure is treated as not done today. The patient is flagged at the top on their next visit; once marked “Done”, it is added to that day\'s procedure history.'**
  String get planInfo;

  /// No description provided for @sentToLab.
  ///
  /// In en, this message translates to:
  /// **'Sent to lab'**
  String get sentToLab;

  /// No description provided for @sentToLabInfo.
  ///
  /// In en, this message translates to:
  /// **'Check this when the work is sent to the laboratory. The follow-up list and a notification remind you 1 day before the expected return date. With this option the procedure counts as done and “Plan for next session” is turned off.'**
  String get sentToLabInfo;

  /// No description provided for @addExtraCanalForTooth.
  ///
  /// In en, this message translates to:
  /// **'Add extra canal · Tooth {tooth}'**
  String addExtraCanalForTooth(String tooth);

  /// No description provided for @addExtraCanal.
  ///
  /// In en, this message translates to:
  /// **'Add extra canal'**
  String get addExtraCanal;

  /// No description provided for @extraCanalHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a canal that is not in the typical list, or type a custom name.'**
  String get extraCanalHint;

  /// No description provided for @allStandardCanalsAdded.
  ///
  /// In en, this message translates to:
  /// **'All standard codes are already added. Use a custom name.'**
  String get allStandardCanalsAdded;

  /// No description provided for @customCanalName.
  ///
  /// In en, this message translates to:
  /// **'Custom canal name'**
  String get customCanalName;

  /// No description provided for @customCanalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. MB3, DB2…'**
  String get customCanalHint;

  /// No description provided for @editProcedureTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit procedure'**
  String get editProcedureTitle;

  /// No description provided for @editVersionHint.
  ///
  /// In en, this message translates to:
  /// **'v{version} → saved as a new version; the old one is kept'**
  String editVersionHint(int version);

  /// No description provided for @errTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Procedure title is required'**
  String get errTitleRequired;

  /// No description provided for @noChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes'**
  String get noChanges;

  /// No description provided for @saveAsNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Save as new version'**
  String get saveAsNewVersion;

  /// No description provided for @quadrantUpperRight.
  ///
  /// In en, this message translates to:
  /// **'Upper right'**
  String get quadrantUpperRight;

  /// No description provided for @quadrantUpperLeft.
  ///
  /// In en, this message translates to:
  /// **'Upper left'**
  String get quadrantUpperLeft;

  /// No description provided for @quadrantLowerRight.
  ///
  /// In en, this message translates to:
  /// **'Lower right'**
  String get quadrantLowerRight;

  /// No description provided for @quadrantLowerLeft.
  ///
  /// In en, this message translates to:
  /// **'Lower left'**
  String get quadrantLowerLeft;

  /// No description provided for @toothNumberSection.
  ///
  /// In en, this message translates to:
  /// **'Tooth number'**
  String get toothNumberSection;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// No description provided for @typeToSelectLabel.
  ///
  /// In en, this message translates to:
  /// **'Type to select (FDI)'**
  String get typeToSelectLabel;

  /// No description provided for @typeToSelectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15  or  14-17  or  36,37'**
  String get typeToSelectHint;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @toothSelectorHelp.
  ///
  /// In en, this message translates to:
  /// **'Tap: select · Long press: zoom quadrant · Swipe down or OK: close'**
  String get toothSelectorHelp;

  /// No description provided for @jawUpper.
  ///
  /// In en, this message translates to:
  /// **'UPPER'**
  String get jawUpper;

  /// No description provided for @jawLower.
  ///
  /// In en, this message translates to:
  /// **'LOWER'**
  String get jawLower;

  /// No description provided for @sideRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get sideRight;

  /// No description provided for @sideLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get sideLeft;

  /// No description provided for @selectTeeth.
  ///
  /// In en, this message translates to:
  /// **'Select teeth'**
  String get selectTeeth;

  /// No description provided for @selectedTeeth.
  ///
  /// In en, this message translates to:
  /// **'Selected: {teeth}'**
  String selectedTeeth(String teeth);

  /// No description provided for @swipeDownToClose.
  ///
  /// In en, this message translates to:
  /// **'You can also swipe down to close'**
  String get swipeDownToClose;

  /// No description provided for @canalParamsForTooth.
  ///
  /// In en, this message translates to:
  /// **'Canal parameters · Tooth {tooth}'**
  String canalParamsForTooth(String tooth);

  /// No description provided for @canalParamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Root canal treatment parameters'**
  String get canalParamsTitle;

  /// No description provided for @canalLengthMm.
  ///
  /// In en, this message translates to:
  /// **'Canal length (mm)'**
  String get canalLengthMm;

  /// No description provided for @extra.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get extra;

  /// No description provided for @fileSystem.
  ///
  /// In en, this message translates to:
  /// **'File system'**
  String get fileSystem;

  /// No description provided for @intracanalMedicament.
  ///
  /// In en, this message translates to:
  /// **'Intracanal medicament'**
  String get intracanalMedicament;

  /// No description provided for @toothCanalHint.
  ///
  /// In en, this message translates to:
  /// **'Tooth {tooth} · typical: {canals} — add extras if needed'**
  String toothCanalHint(String tooth, String canals);

  /// No description provided for @newVersionSaved.
  ///
  /// In en, this message translates to:
  /// **'New version saved'**
  String get newVersionSaved;

  /// No description provided for @deleteProcedureTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete procedure'**
  String get deleteProcedureTitle;

  /// No description provided for @deleteProcedureConfirm.
  ///
  /// In en, this message translates to:
  /// **'This note and any previous versions will be permanently deleted.'**
  String get deleteProcedureConfirm;

  /// No description provided for @procedureDeleted.
  ///
  /// In en, this message translates to:
  /// **'Procedure deleted'**
  String get procedureDeleted;

  /// No description provided for @procedureDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete procedure: {error}'**
  String procedureDeleteFailed(String error);

  /// No description provided for @labShort.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get labShort;

  /// No description provided for @labReturnShort.
  ///
  /// In en, this message translates to:
  /// **'Lab → {date}'**
  String labReturnShort(String date);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @versionHistory.
  ///
  /// In en, this message translates to:
  /// **'Version history'**
  String get versionHistory;

  /// No description provided for @historyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load history: {error}'**
  String historyLoadFailed(String error);

  /// No description provided for @noVersionsFound.
  ///
  /// In en, this message translates to:
  /// **'No versions found'**
  String get noVersionsFound;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentVersion;

  /// No description provided for @oldVersion.
  ///
  /// In en, this message translates to:
  /// **'Old version'**
  String get oldVersion;

  /// No description provided for @changesInVersion.
  ///
  /// In en, this message translates to:
  /// **'Changes in this version'**
  String get changesInVersion;

  /// No description provided for @firstRecord.
  ///
  /// In en, this message translates to:
  /// **'First record'**
  String get firstRecord;

  /// No description provided for @micPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required'**
  String get micPermissionRequired;

  /// No description provided for @micPermissionMissing.
  ///
  /// In en, this message translates to:
  /// **'No microphone permission'**
  String get micPermissionMissing;

  /// No description provided for @recordingEmpty.
  ///
  /// In en, this message translates to:
  /// **'The recording is empty or could not be created'**
  String get recordingEmpty;

  /// No description provided for @voiceUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the voice recording: {error}'**
  String voiceUploadFailed(String error);

  /// No description provided for @quickVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Quick voice note'**
  String get quickVoiceNote;

  /// No description provided for @voicePrivacyHint.
  ///
  /// In en, this message translates to:
  /// **'Audio is only for the doctor\'s or assistant\'s procedure summary. Patient conversations are not recorded.'**
  String get voicePrivacyHint;

  /// No description provided for @recordingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Recording…'**
  String get recordingInProgress;

  /// No description provided for @uploadingVoice.
  ///
  /// In en, this message translates to:
  /// **'Uploading audio to the cloud…'**
  String get uploadingVoice;

  /// No description provided for @voiceStartHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the microphone and speak, then tap Finish & save'**
  String get voiceStartHint;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get pleaseWait;

  /// No description provided for @finishAndSave.
  ///
  /// In en, this message translates to:
  /// **'Finish & save'**
  String get finishAndSave;

  /// No description provided for @playFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not play: {error}'**
  String playFailed(String error);

  /// No description provided for @memoMarkedProcessed.
  ///
  /// In en, this message translates to:
  /// **'Voice note marked as processed'**
  String get memoMarkedProcessed;

  /// No description provided for @markFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not mark: {error}'**
  String markFailed(String error);

  /// No description provided for @deleteVoiceNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete voice note'**
  String get deleteVoiceNoteTitle;

  /// No description provided for @deleteVoiceNoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This voice note will be permanently deleted.'**
  String get deleteVoiceNoteConfirm;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete: {error}'**
  String deleteFailed(String error);

  /// No description provided for @processedVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Processed voice note'**
  String get processedVoiceNote;

  /// No description provided for @pendingVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Pending voice note'**
  String get pendingVoiceNote;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String durationLabel(String duration);

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @convertToNote.
  ///
  /// In en, this message translates to:
  /// **'Convert to note'**
  String get convertToNote;

  /// No description provided for @audioFileEmpty.
  ///
  /// In en, this message translates to:
  /// **'The audio file is empty'**
  String get audioFileEmpty;

  /// No description provided for @photoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open photo: {error}'**
  String photoOpenFailed(String error);

  /// No description provided for @photoCount.
  ///
  /// In en, this message translates to:
  /// **'{count} / {max} photos'**
  String photoCount(int count, int max);

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get fromGallery;

  /// No description provided for @shareThisPhoto.
  ///
  /// In en, this message translates to:
  /// **'Share this photo'**
  String get shareThisPhoto;

  /// No description provided for @shareAllPhotos.
  ///
  /// In en, this message translates to:
  /// **'Share all photos ({count})'**
  String shareAllPhotos(int count);

  /// No description provided for @procedurePhoto.
  ///
  /// In en, this message translates to:
  /// **'Procedure photo'**
  String get procedurePhoto;

  /// No description provided for @procedurePhotoIndex.
  ///
  /// In en, this message translates to:
  /// **'Procedure photo {index}/{count}'**
  String procedurePhotoIndex(int index, int count);

  /// No description provided for @shareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share (WhatsApp, email…)'**
  String get shareTooltip;

  /// No description provided for @photoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load photo'**
  String get photoLoadFailed;

  /// No description provided for @preparingPhotos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Preparing photo…} other{Preparing {count} photos…}}'**
  String preparingPhotos(int count);

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share: {error}'**
  String shareFailed(String error);

  /// No description provided for @completedItem.
  ///
  /// In en, this message translates to:
  /// **'Completed: {title}'**
  String completedItem(String title);

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed: {error}'**
  String actionFailed(String error);

  /// No description provided for @deletedItem.
  ///
  /// In en, this message translates to:
  /// **'Deleted: {title}'**
  String deletedItem(String title);

  /// No description provided for @patientOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open patient: {error}'**
  String patientOpenFailed(String error);

  /// No description provided for @noOpenFollowUps.
  ///
  /// In en, this message translates to:
  /// **'No open follow-ups.'**
  String get noOpenFollowUps;

  /// No description provided for @sectionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get sectionOverdue;

  /// No description provided for @sectionReminderDue.
  ///
  /// In en, this message translates to:
  /// **'Upcoming (reminder due)'**
  String get sectionReminderDue;

  /// No description provided for @sectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get sectionUpcoming;

  /// No description provided for @patientFallback.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientFallback;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'Reminder: {date}'**
  String reminderOn(String date);

  /// No description provided for @goToPatient.
  ///
  /// In en, this message translates to:
  /// **'Go to patient'**
  String get goToPatient;

  /// No description provided for @errFollowUpTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a follow-up title'**
  String get errFollowUpTitleRequired;

  /// No description provided for @followUpWhatLabel.
  ///
  /// In en, this message translates to:
  /// **'What needs follow-up?'**
  String get followUpWhatLabel;

  /// No description provided for @followUpWhatHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Check-up, suture removal, pain check…'**
  String get followUpWhatHint;

  /// No description provided for @whenLabel.
  ///
  /// In en, this message translates to:
  /// **'When?'**
  String get whenLabel;

  /// No description provided for @notifFollowUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow-up: {name}'**
  String notifFollowUpTitle(String name);

  /// No description provided for @notifCheckupBody.
  ///
  /// In en, this message translates to:
  /// **'{title} · Check-up: {date}'**
  String notifCheckupBody(String title, String date);

  /// No description provided for @notifChannelFollowUps.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups'**
  String get notifChannelFollowUps;

  /// No description provided for @notifChannelFollowUpsDesc.
  ///
  /// In en, this message translates to:
  /// **'Check-up and follow-up reminders'**
  String get notifChannelFollowUpsDesc;

  /// No description provided for @notifChannelClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic notifications'**
  String get notifChannelClinic;

  /// No description provided for @notifChannelClinicDesc.
  ///
  /// In en, this message translates to:
  /// **'Join, follow-up and to-do reminders'**
  String get notifChannelClinicDesc;

  /// No description provided for @todoAdded.
  ///
  /// In en, this message translates to:
  /// **'To-do added'**
  String get todoAdded;

  /// No description provided for @noOpenTodos.
  ///
  /// In en, this message translates to:
  /// **'No open to-dos.\nTap Add to create a text or voice note.'**
  String get noOpenTodos;

  /// No description provided for @todosIntro.
  ///
  /// In en, this message translates to:
  /// **'General clinic notes — appointments, callbacks, reminders…'**
  String get todosIntro;

  /// No description provided for @sectionUndated.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get sectionUndated;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMine.
  ///
  /// In en, this message translates to:
  /// **'Assigned to me'**
  String get filterMine;

  /// No description provided for @filterTodayOverdue.
  ///
  /// In en, this message translates to:
  /// **'Today/overdue'**
  String get filterTodayOverdue;

  /// No description provided for @filterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterCompleted;

  /// No description provided for @commentAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add comment: {error}'**
  String commentAddFailed(String error);

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open camera: {error}'**
  String cameraOpenFailed(String error);

  /// No description provided for @galleryOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open gallery: {error}'**
  String galleryOpenFailed(String error);

  /// No description provided for @imageAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add image: {error}'**
  String imageAddFailed(String error);

  /// No description provided for @imageOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open image: {error}'**
  String imageOpenFailed(String error);

  /// No description provided for @deleteImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete image'**
  String get deleteImageTitle;

  /// No description provided for @deleteImageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this image from the task?'**
  String get deleteImageConfirm;

  /// No description provided for @imageDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete image: {error}'**
  String imageDeleteFailed(String error);

  /// No description provided for @todoDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'To-do details'**
  String get todoDetailTitle;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markAsCompleted;

  /// No description provided for @wholeClinic.
  ///
  /// In en, this message translates to:
  /// **'Whole clinic'**
  String get wholeClinic;

  /// No description provided for @clinicMemberFallback.
  ///
  /// In en, this message translates to:
  /// **'Clinic member'**
  String get clinicMemberFallback;

  /// No description provided for @createdByOn.
  ///
  /// In en, this message translates to:
  /// **'Created by {name} on {date}'**
  String createdByOn(String name, String date);

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @noImages.
  ///
  /// In en, this message translates to:
  /// **'No images added'**
  String get noImages;

  /// No description provided for @commentsCount.
  ///
  /// In en, this message translates to:
  /// **'Comments ({count})'**
  String commentsCount(int count);

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment…'**
  String get addCommentHint;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @eventCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created'**
  String get eventCreated;

  /// No description provided for @eventCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get eventCompleted;

  /// No description provided for @eventCommentAdded.
  ///
  /// In en, this message translates to:
  /// **'Comment added'**
  String get eventCommentAdded;

  /// No description provided for @eventImageAdded.
  ///
  /// In en, this message translates to:
  /// **'Image added'**
  String get eventImageAdded;

  /// No description provided for @eventImageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image removed'**
  String get eventImageDeleted;

  /// No description provided for @completedMessage.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedMessage;

  /// No description provided for @deleteTodoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this to-do?'**
  String get deleteTodoConfirm;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get priorityImportant;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityUrgent;

  /// No description provided for @recurrenceNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get recurrenceNone;

  /// No description provided for @recurrenceDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get recurrenceDaily;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get recurrenceMonthly;

  /// No description provided for @voiceTodo.
  ///
  /// In en, this message translates to:
  /// **'Voice to-do'**
  String get voiceTodo;

  /// No description provided for @todoFallback.
  ///
  /// In en, this message translates to:
  /// **'To-do'**
  String get todoFallback;

  /// No description provided for @previewPlayFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not play preview: {error}'**
  String previewPlayFailed(String error);

  /// No description provided for @taskTime.
  ///
  /// In en, this message translates to:
  /// **'Task time'**
  String get taskTime;

  /// No description provided for @errTextOrVoiceRequired.
  ///
  /// In en, this message translates to:
  /// **'Write a note or record audio'**
  String get errTextOrVoiceRequired;

  /// No description provided for @errFinishRecordingFirst.
  ///
  /// In en, this message translates to:
  /// **'Finish the recording first'**
  String get errFinishRecordingFirst;

  /// No description provided for @addTodo.
  ///
  /// In en, this message translates to:
  /// **'Add to-do'**
  String get addTodo;

  /// No description provided for @todoNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Book Mr. Smith an appointment tomorrow, call the patient back…'**
  String get todoNoteHint;

  /// No description provided for @voiceOptional.
  ///
  /// In en, this message translates to:
  /// **'Audio (optional)'**
  String get voiceOptional;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @voiceRecorded.
  ///
  /// In en, this message translates to:
  /// **'Audio recorded · {duration}'**
  String voiceRecorded(String duration);

  /// No description provided for @reRecord.
  ///
  /// In en, this message translates to:
  /// **'Record again'**
  String get reRecord;

  /// No description provided for @recordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record audio'**
  String get recordVoice;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @targetDate.
  ///
  /// In en, this message translates to:
  /// **'Target: {date}'**
  String targetDate(String date);

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @assignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get assignee;

  /// No description provided for @patientLinkOptional.
  ///
  /// In en, this message translates to:
  /// **'Linked patient (optional)'**
  String get patientLinkOptional;

  /// No description provided for @noPatientSelected.
  ///
  /// In en, this message translates to:
  /// **'No patient selected'**
  String get noPatientSelected;

  /// No description provided for @recurrence.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get recurrence;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @remindOnTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get remindOnTime;

  /// No description provided for @remindOneHourBefore.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get remindOneHourBefore;

  /// No description provided for @errCommentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Comment cannot be empty'**
  String get errCommentEmpty;

  /// No description provided for @recurringTask.
  ///
  /// In en, this message translates to:
  /// **'Recurring task'**
  String get recurringTask;

  /// No description provided for @errInvalidFilePath.
  ///
  /// In en, this message translates to:
  /// **'Invalid file path'**
  String get errInvalidFilePath;

  /// No description provided for @periodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get periodThisWeek;

  /// No description provided for @periodLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get periodLastWeek;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodThisMonth;

  /// No description provided for @periodLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get periodLastMonth;

  /// No description provided for @reportPeriod.
  ///
  /// In en, this message translates to:
  /// **'Report period'**
  String get reportPeriod;

  /// No description provided for @comparedWith.
  ///
  /// In en, this message translates to:
  /// **'Compared with: {range}'**
  String comparedWith(String range);

  /// No description provided for @topProcedures.
  ///
  /// In en, this message translates to:
  /// **'Most performed procedures'**
  String get topProcedures;

  /// No description provided for @noProceduresInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No procedures recorded in this period.'**
  String get noProceduresInPeriod;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @dailyActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity by day'**
  String get dailyActivity;

  /// No description provided for @followUpStatus.
  ///
  /// In en, this message translates to:
  /// **'Follow-up status'**
  String get followUpStatus;

  /// No description provided for @patientsToRecall.
  ///
  /// In en, this message translates to:
  /// **'Patients to call back'**
  String get patientsToRecall;

  /// No description provided for @daysPlus.
  ///
  /// In en, this message translates to:
  /// **'{days}+ days'**
  String daysPlus(int days);

  /// No description provided for @noRecallsDue.
  ///
  /// In en, this message translates to:
  /// **'No patients are due for a check-up.'**
  String get noRecallsDue;

  /// No description provided for @recallsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 patient is due for a check-up} other{{count} patients are due for a check-up}}'**
  String recallsWaiting(int count);

  /// No description provided for @oldRecallsCount.
  ///
  /// In en, this message translates to:
  /// **'+ {count} older patients (check-up date passed more than 12 months ago)'**
  String oldRecallsCount(int count);

  /// No description provided for @openList.
  ///
  /// In en, this message translates to:
  /// **'Open list'**
  String get openList;

  /// No description provided for @statProceduresDone.
  ///
  /// In en, this message translates to:
  /// **'Procedures performed'**
  String get statProceduresDone;

  /// No description provided for @statProceduresHint.
  ///
  /// In en, this message translates to:
  /// **'Multi-tooth procedures are counted per tooth'**
  String get statProceduresHint;

  /// No description provided for @statPatientsTreated.
  ///
  /// In en, this message translates to:
  /// **'Patients treated'**
  String get statPatientsTreated;

  /// No description provided for @statVisits.
  ///
  /// In en, this message translates to:
  /// **'Patient visits'**
  String get statVisits;

  /// No description provided for @statVisitsHint.
  ///
  /// In en, this message translates to:
  /// **'Visits by the same patient on different days are counted separately'**
  String get statVisitsHint;

  /// No description provided for @statNewPatients.
  ///
  /// In en, this message translates to:
  /// **'New patients'**
  String get statNewPatients;

  /// No description provided for @statTotalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total patients'**
  String get statTotalPatients;

  /// No description provided for @statPendingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Pending planned procedures'**
  String get statPendingPlanned;

  /// No description provided for @sameAsPrevious.
  ///
  /// In en, this message translates to:
  /// **'Same as previous period'**
  String get sameAsPrevious;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {label}'**
  String weekOf(String label);

  /// No description provided for @busiestDay.
  ///
  /// In en, this message translates to:
  /// **'Busiest day: {day} ({procedures})'**
  String busiestDay(String day, String procedures);

  /// No description provided for @overdueCount.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String overdueCount(int count);

  /// No description provided for @labPending.
  ///
  /// In en, this message translates to:
  /// **'Work pending at the lab'**
  String get labPending;

  /// No description provided for @controlPending.
  ///
  /// In en, this message translates to:
  /// **'Pending check-ups'**
  String get controlPending;

  /// No description provided for @openTasks.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get openTasks;

  /// No description provided for @completedInPeriod.
  ///
  /// In en, this message translates to:
  /// **'Completed in this period — lab: {lab}, check-ups: {control}, tasks: {task}'**
  String completedInPeriod(int lab, int control, int task);

  /// No description provided for @stalledHint.
  ///
  /// In en, this message translates to:
  /// **'Patients with planned procedures who haven\'t visited for {days} days and have no future check-up.'**
  String stalledHint(int days);

  /// No description provided for @noPatientsToRecall.
  ///
  /// In en, this message translates to:
  /// **'No patients to call back.'**
  String get noPatientsToRecall;

  /// No description provided for @lastProcedure.
  ///
  /// In en, this message translates to:
  /// **'Last procedure: {date} ({days, plural, =0{today} =1{1 day ago} other{{days} days ago}})'**
  String lastProcedure(String date, int days);

  /// No description provided for @plannedList.
  ///
  /// In en, this message translates to:
  /// **'Planned: {items}'**
  String plannedList(String items);

  /// No description provided for @callPhone.
  ///
  /// In en, this message translates to:
  /// **'Call: {phone}'**
  String callPhone(String phone);

  /// No description provided for @firstNPatients.
  ///
  /// In en, this message translates to:
  /// **'Showing the first {count} patients.'**
  String firstNPatients(int count);

  /// No description provided for @moreAfterLogging.
  ///
  /// In en, this message translates to:
  /// **'More appear as you record call results.'**
  String get moreAfterLogging;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @recallResultAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment given'**
  String get recallResultAppointment;

  /// No description provided for @recallResultUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Unreachable'**
  String get recallResultUnreachable;

  /// No description provided for @recallResultDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get recallResultDeclined;

  /// No description provided for @recallAppointmentHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a check-up date; a follow-up is created'**
  String get recallAppointmentHint;

  /// No description provided for @recallUnreachableHint.
  ///
  /// In en, this message translates to:
  /// **'Returns to the list in 7 days'**
  String get recallUnreachableHint;

  /// No description provided for @recallDeclinedHint.
  ///
  /// In en, this message translates to:
  /// **'Hidden from the list until a new procedure is done'**
  String get recallDeclinedHint;

  /// No description provided for @openPatientCard.
  ///
  /// In en, this message translates to:
  /// **'Open patient card'**
  String get openPatientCard;

  /// No description provided for @recallLogged.
  ///
  /// In en, this message translates to:
  /// **'{name}: saved as \"{result}\"'**
  String recallLogged(String name, String result);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @undoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not undo: {error}'**
  String undoFailed(String error);

  /// No description provided for @recallDateHelp.
  ///
  /// In en, this message translates to:
  /// **'{name} · check-up date'**
  String recallDateHelp(String name);

  /// No description provided for @periodicCheckup.
  ///
  /// In en, this message translates to:
  /// **'Periodic check-up'**
  String get periodicCheckup;

  /// No description provided for @checkupReason.
  ///
  /// In en, this message translates to:
  /// **'Check-up reason: {procedure} ({date})'**
  String checkupReason(String procedure, String date);

  /// No description provided for @checkupScheduled.
  ///
  /// In en, this message translates to:
  /// **'{name}: check-up scheduled for {date}'**
  String checkupScheduled(String name, String date);

  /// No description provided for @appointmentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save appointment: {error}'**
  String appointmentSaveFailed(String error);

  /// No description provided for @recallCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get recallCurrent;

  /// No description provided for @recallOld.
  ///
  /// In en, this message translates to:
  /// **'Older patients'**
  String get recallOld;

  /// No description provided for @recallOldHint.
  ///
  /// In en, this message translates to:
  /// **'Patients whose check-up date passed more than 12 months ago. They are listed separately because they haven\'t visited for a long time.'**
  String get recallOldHint;

  /// No description provided for @recallCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Patients whose check-up period after a procedure has expired. Periods are set on the Procedure templates screen. Patients with an appointment, a planned procedure or a future follow-up are not listed.'**
  String get recallCurrentHint;

  /// No description provided for @noOldRecalls.
  ///
  /// In en, this message translates to:
  /// **'No older patients are awaiting a check-up.'**
  String get noOldRecalls;

  /// No description provided for @checkupDue.
  ///
  /// In en, this message translates to:
  /// **'Check-up: {date}'**
  String checkupDue(String date);

  /// No description provided for @checkupOverdue.
  ///
  /// In en, this message translates to:
  /// **'Check-up: {date} ({months, plural, =1{1 month overdue} other{{months} months overdue}})'**
  String checkupOverdue(String date, int months);

  /// No description provided for @lastCall.
  ///
  /// In en, this message translates to:
  /// **'Last call: {result}'**
  String lastCall(String result);

  /// No description provided for @noMissingDefaults.
  ///
  /// In en, this message translates to:
  /// **'No missing defaults'**
  String get noMissingDefaults;

  /// No description provided for @defaultsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 default procedure added} other{{count} default procedures added}}'**
  String defaultsAdded(int count);

  /// No description provided for @addFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add: {error}'**
  String addFailed(String error);

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update: {error}'**
  String updateFailed(String error);

  /// No description provided for @deleteTemplateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from the list?\nPast patient records are not affected.'**
  String deleteTemplateConfirm(String name);

  /// No description provided for @seedMissingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore missing defaults'**
  String get seedMissingTooltip;

  /// No description provided for @hideInactive.
  ///
  /// In en, this message translates to:
  /// **'Hide inactive'**
  String get hideInactive;

  /// No description provided for @showInactive.
  ///
  /// In en, this message translates to:
  /// **'Show inactive'**
  String get showInactive;

  /// No description provided for @addProcedure.
  ///
  /// In en, this message translates to:
  /// **'Add procedure'**
  String get addProcedure;

  /// No description provided for @templatesIntro.
  ///
  /// In en, this message translates to:
  /// **'The clinic\'s procedure list. These appear in the new procedure form. Past records don\'t change.'**
  String get templatesIntro;

  /// No description provided for @templatesEditRestricted.
  ///
  /// In en, this message translates to:
  /// **'Only doctors or admins can edit.'**
  String get templatesEditRestricted;

  /// No description provided for @tagCanal.
  ///
  /// In en, this message translates to:
  /// **'Root canal'**
  String get tagCanal;

  /// No description provided for @tagToothRequired.
  ///
  /// In en, this message translates to:
  /// **'Tooth required'**
  String get tagToothRequired;

  /// No description provided for @tagJawOk.
  ///
  /// In en, this message translates to:
  /// **'Jaw/mouth OK'**
  String get tagJawOk;

  /// No description provided for @tagLabTracking.
  ///
  /// In en, this message translates to:
  /// **'Lab tracking'**
  String get tagLabTracking;

  /// No description provided for @tagCheckupMonths.
  ///
  /// In en, this message translates to:
  /// **'Check-up: {months} mo'**
  String tagCheckupMonths(int months);

  /// No description provided for @tagInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get tagInactive;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @noTemplatesYet.
  ///
  /// In en, this message translates to:
  /// **'No procedures yet.'**
  String get noTemplatesYet;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @procedureName.
  ///
  /// In en, this message translates to:
  /// **'Procedure name'**
  String get procedureName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @canalProcedure.
  ///
  /// In en, this message translates to:
  /// **'Root canal procedure'**
  String get canalProcedure;

  /// No description provided for @canalProcedureHint.
  ///
  /// In en, this message translates to:
  /// **'Shows canal length / file fields'**
  String get canalProcedureHint;

  /// No description provided for @toothRequired.
  ///
  /// In en, this message translates to:
  /// **'Tooth selection required'**
  String get toothRequired;

  /// No description provided for @toothRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'If off, upper/lower jaw or full mouth can be selected'**
  String get toothRequiredHint;

  /// No description provided for @labTracking.
  ///
  /// In en, this message translates to:
  /// **'Lab tracking'**
  String get labTracking;

  /// No description provided for @labTrackingHint.
  ///
  /// In en, this message translates to:
  /// **'Shows “Sent to lab” and the return date in the new procedure form'**
  String get labTrackingHint;

  /// No description provided for @periodicCheckupHelper.
  ///
  /// In en, this message translates to:
  /// **'After this procedure the patient is added to the recall list'**
  String get periodicCheckupHelper;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @monthsAfter.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{1 month later} other{{months} months later}}'**
  String monthsAfter(int months);

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @catDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis and planning'**
  String get catDiagnosis;

  /// No description provided for @catTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get catTreatment;

  /// No description provided for @catProsthetics.
  ///
  /// In en, this message translates to:
  /// **'Prosthetics'**
  String get catProsthetics;

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catGeneral;

  /// No description provided for @pdfDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment history - {name}'**
  String pdfDocTitle(String name);

  /// No description provided for @pdfHeader.
  ///
  /// In en, this message translates to:
  /// **'{name} · Treatment history'**
  String pdfHeader(String name);

  /// No description provided for @pdfConfidential.
  ///
  /// In en, this message translates to:
  /// **'Confidential: contains special category personal data (health data).'**
  String get pdfConfidential;

  /// No description provided for @pdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} / {total}'**
  String pdfPage(int page, int total);

  /// No description provided for @pdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Patient treatment history'**
  String get pdfSubtitle;

  /// No description provided for @pdfRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get pdfRegistered;

  /// No description provided for @pdfReportDate.
  ///
  /// In en, this message translates to:
  /// **'Report date'**
  String get pdfReportDate;

  /// No description provided for @pdfPreparedBy.
  ///
  /// In en, this message translates to:
  /// **'Prepared by: {name}'**
  String pdfPreparedBy(String name);

  /// No description provided for @pdfDoneProcedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures performed ({count})'**
  String pdfDoneProcedures(int count);

  /// No description provided for @pdfNoProcedures.
  ///
  /// In en, this message translates to:
  /// **'No procedures recorded.'**
  String get pdfNoProcedures;

  /// No description provided for @pdfPlannedProcedures.
  ///
  /// In en, this message translates to:
  /// **'Planned procedures ({count})'**
  String pdfPlannedProcedures(int count);

  /// No description provided for @pdfColAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get pdfColAdded;

  /// No description provided for @pdfColDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get pdfColDetails;

  /// No description provided for @pdfLabReturn.
  ///
  /// In en, this message translates to:
  /// **'Lab · return {date}'**
  String pdfLabReturn(String date);

  /// No description provided for @photoCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String photoCountShort(int count);

  /// No description provided for @preparingPdf.
  ///
  /// In en, this message translates to:
  /// **'Preparing PDF…'**
  String get preparingPdf;

  /// No description provided for @pdfFilePrefix.
  ///
  /// In en, this message translates to:
  /// **'treatment_history'**
  String get pdfFilePrefix;

  /// No description provided for @pdfCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create PDF: {error}'**
  String pdfCreateFailed(String error);

  /// No description provided for @pdfTreatmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Treatment history'**
  String get pdfTreatmentHistory;

  /// No description provided for @errRequestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found'**
  String get errRequestNotFound;

  /// No description provided for @errRequestAlreadyAnswered.
  ///
  /// In en, this message translates to:
  /// **'This request has already been answered'**
  String get errRequestAlreadyAnswered;

  /// No description provided for @errAssigneeOtherClinic.
  ///
  /// In en, this message translates to:
  /// **'The assignee must belong to the same clinic as the task'**
  String get errAssigneeOtherClinic;

  /// No description provided for @errPatientOtherClinic.
  ///
  /// In en, this message translates to:
  /// **'The patient must belong to the same clinic as the task'**
  String get errPatientOtherClinic;

  /// No description provided for @errNoReportPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to view this clinic\'s reports'**
  String get errNoReportPermission;

  /// No description provided for @errInvalidDateRange.
  ///
  /// In en, this message translates to:
  /// **'Invalid date range'**
  String get errInvalidDateRange;

  /// No description provided for @errNoListPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to view this clinic\'s list'**
  String get errNoListPermission;

  /// No description provided for @errNothingToSave.
  ///
  /// In en, this message translates to:
  /// **'Nothing to save'**
  String get errNothingToSave;

  /// No description provided for @errNoteNotFound.
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get errNoteNotFound;

  /// No description provided for @errNoPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this action'**
  String get errNoPermission;

  /// No description provided for @errOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get errOffline;

  /// No description provided for @tplTreatmentPlanning.
  ///
  /// In en, this message translates to:
  /// **'Treatment Planning'**
  String get tplTreatmentPlanning;

  /// No description provided for @tplInitialExam.
  ///
  /// In en, this message translates to:
  /// **'Initial Exam / Diagnosis'**
  String get tplInitialExam;

  /// No description provided for @tplCanalStart.
  ///
  /// In en, this message translates to:
  /// **'Root Canal – Start'**
  String get tplCanalStart;

  /// No description provided for @tplCanalFinish.
  ///
  /// In en, this message translates to:
  /// **'Root Canal – Completion'**
  String get tplCanalFinish;

  /// No description provided for @tplCanalRetreatment.
  ///
  /// In en, this message translates to:
  /// **'Root Canal Retreatment'**
  String get tplCanalRetreatment;

  /// No description provided for @tplCompositeFilling.
  ///
  /// In en, this message translates to:
  /// **'Composite Filling'**
  String get tplCompositeFilling;

  /// No description provided for @tplPulpCapping.
  ///
  /// In en, this message translates to:
  /// **'Pulp Capping'**
  String get tplPulpCapping;

  /// No description provided for @tplExtraction.
  ///
  /// In en, this message translates to:
  /// **'Tooth Extraction'**
  String get tplExtraction;

  /// No description provided for @tplComplicatedExtraction.
  ///
  /// In en, this message translates to:
  /// **'Complicated Extraction'**
  String get tplComplicatedExtraction;

  /// No description provided for @tplSurgicalExtraction.
  ///
  /// In en, this message translates to:
  /// **'Surgical Extraction'**
  String get tplSurgicalExtraction;

  /// No description provided for @tplAlveolitis.
  ///
  /// In en, this message translates to:
  /// **'Dry Socket Treatment (Dressing)'**
  String get tplAlveolitis;

  /// No description provided for @tplCurettage.
  ///
  /// In en, this message translates to:
  /// **'Curettage'**
  String get tplCurettage;

  /// No description provided for @tplWhitening.
  ///
  /// In en, this message translates to:
  /// **'Whitening'**
  String get tplWhitening;

  /// No description provided for @tplToothPreparation.
  ///
  /// In en, this message translates to:
  /// **'Tooth Preparation'**
  String get tplToothPreparation;

  /// No description provided for @tplImpression.
  ///
  /// In en, this message translates to:
  /// **'Impression'**
  String get tplImpression;

  /// No description provided for @tplFrameworkTryIn.
  ///
  /// In en, this message translates to:
  /// **'Framework Try-in'**
  String get tplFrameworkTryIn;

  /// No description provided for @tplBisqueTryIn.
  ///
  /// In en, this message translates to:
  /// **'Bisque Try-in'**
  String get tplBisqueTryIn;

  /// No description provided for @tplTempCementation.
  ///
  /// In en, this message translates to:
  /// **'Temporary Cementation'**
  String get tplTempCementation;

  /// No description provided for @tplPermCementation.
  ///
  /// In en, this message translates to:
  /// **'Permanent Cementation'**
  String get tplPermCementation;

  /// No description provided for @tplNightGuardImpression.
  ///
  /// In en, this message translates to:
  /// **'Night Guard Impression'**
  String get tplNightGuardImpression;

  /// No description provided for @tplScaling.
  ///
  /// In en, this message translates to:
  /// **'Scaling (Cleaning)'**
  String get tplScaling;

  /// No description provided for @tplCheckup.
  ///
  /// In en, this message translates to:
  /// **'Check-up'**
  String get tplCheckup;

  /// No description provided for @errClinicInfoMissing.
  ///
  /// In en, this message translates to:
  /// **'Clinic information is missing'**
  String get errClinicInfoMissing;
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
