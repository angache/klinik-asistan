// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailRequired => 'L\'e-mail est obligatoire';

  @override
  String get emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordMinLength => '6 caractères minimum';

  @override
  String get fullNameLabel => 'Nom et prénom';

  @override
  String get fullNameRequired => 'Le nom est obligatoire';

  @override
  String get retry => 'Réessayer';

  @override
  String get signOut => 'Déconnexion';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get settingsAndAccount => 'Paramètres et compte';

  @override
  String linkOpenFailed(String url) {
    return 'Impossible d\'ouvrir le lien : $url';
  }

  @override
  String clinicCodeCopied(String code) {
    return 'Code du cabinet copié : $code';
  }

  @override
  String get userFallback => 'Utilisateur';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleDoctor => 'Praticien';

  @override
  String get roleAssistant => 'Assistant(e)';

  @override
  String get joinStatusPending => 'En attente de validation';

  @override
  String get joinStatusApproved => 'Validée';

  @override
  String get joinStatusRejected => 'Refusée';

  @override
  String get loginSubtitle => 'Connexion';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginCreateAccount => 'Créer un compte / Rejoindre un cabinet';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get clinicRequiredTitle => 'Cabinet requis';

  @override
  String get serverUnreachableTitle => 'Impossible de joindre le serveur';

  @override
  String get serverUnreachableBody =>
      'Vérifiez votre connexion Internet et réessayez.';

  @override
  String get signupTitle => 'Inscription';

  @override
  String get createClinic => 'Créer un cabinet';

  @override
  String get joinClinic => 'Rejoindre un cabinet';

  @override
  String get signupCreateIntro =>
      'Vous créez un nouveau cabinet et en devenez l\'administrateur et le praticien. Vous invitez les assistant(e)s avec le code du cabinet.';

  @override
  String get clinicNameLabel => 'Nom du cabinet';

  @override
  String get clinicNameRequired => 'Le nom du cabinet est obligatoire';

  @override
  String get alreadyHaveAccount => 'J\'ai déjà un compte';

  @override
  String get signupJoinIntro =>
      'Envoyez une demande avec le code du cabinet reçu de l\'administrateur. Vous aurez accès après sa validation.';

  @override
  String get clinicCodeLabel => 'Code du cabinet';

  @override
  String get clinicCodeHint => 'ex. A3K9PX';

  @override
  String get clinicCodeRequired => 'Le code est obligatoire';

  @override
  String get myRole => 'Mon rôle';

  @override
  String get joinButton => 'Rejoindre';

  @override
  String get resetCodeSent =>
      'Si l\'adresse est enregistrée, un code vous a été envoyé par e-mail';

  @override
  String get passwordUpdated => 'Votre mot de passe a été modifié';

  @override
  String get resetIntroEmail =>
      'Saisissez l\'adresse e-mail de votre compte ; nous vous enverrons un code de réinitialisation.';

  @override
  String get resetIntroCode =>
      'Saisissez le code reçu par e-mail et votre nouveau mot de passe.';

  @override
  String get resetCodeLabel => 'Code';

  @override
  String get resetCodeInvalid => 'Saisissez le code reçu par e-mail';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get newPasswordRepeatLabel => 'Nouveau mot de passe (confirmation)';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get updatePasswordButton => 'Modifier le mot de passe';

  @override
  String get sendCodeButton => 'Envoyer le code';

  @override
  String get resetRequestNewCode =>
      'Demander un nouveau code / changer d\'e-mail';

  @override
  String get legalConsentText =>
      'J\'ai lu la notice d\'information, la politique de confidentialité et les conditions d\'utilisation, et je m\'engage à traiter les données des patients uniquement à des fins de diagnostic et de soins, conformément à la législation sur la protection des données.';

  @override
  String get legalConsentRequired =>
      'Votre accord est nécessaire pour continuer';

  @override
  String get privacyNotice => 'Notice d\'information';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAccountSection => 'Compte';

  @override
  String get settingsLegalSection => 'Mentions légales';

  @override
  String supportEmail(String email) {
    return 'Assistance : $email';
  }

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageSystem => 'Langue du téléphone';

  @override
  String get settingsDangerZone => 'Zone sensible';

  @override
  String get deleteMyAccount => 'Supprimer mon compte';

  @override
  String get deleteMyAccountSubtitle =>
      'Votre compte sera définitivement supprimé';

  @override
  String accountInfoFailed(String error) {
    return 'Impossible de récupérer les informations du compte : $error';
  }

  @override
  String get transferAdminTitle =>
      'Transférez d\'abord le rôle d\'administrateur';

  @override
  String transferAdminBody(String clinics) {
    return 'Vous êtes le seul administrateur de ces cabinets, qui comptent d\'autres membres :\n\n$clinics\n\nNommez un autre membre administrateur depuis l\'écran Membres, puis réessayez.';
  }

  @override
  String get accountDeleted => 'Votre compte a été supprimé';

  @override
  String accountDeleteFailed(String error) {
    return 'Impossible de supprimer le compte : $error';
  }

  @override
  String serverError(int status) {
    return 'Erreur serveur ($status)';
  }

  @override
  String get deleteAccountTitle => 'Supprimer définitivement le compte';

  @override
  String get deleteAccountWarning =>
      'Votre compte et vos identifiants seront supprimés. Cette action est irréversible.';

  @override
  String get deleteAccountClinicsWarning =>
      'Vous êtes le seul membre des cabinets ci-dessous. Ils seront supprimés avec tous les dossiers patients, actes, photos et enregistrements vocaux :';

  @override
  String get deleteAccountMembershipOnly =>
      'Les données des cabinets dont vous êtes membre restent au cabinet ; seule votre adhésion prend fin.';

  @override
  String deleteAccountTypeToConfirm(String word) {
    return 'Saisissez « $word » pour confirmer :';
  }

  @override
  String get deleteAccountConfirmWord => 'SUPPRIMER';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get errInvalidCredentials => 'E-mail ou mot de passe incorrect';

  @override
  String get errAlreadyRegistered =>
      'Cet e-mail est déjà enregistré. Connectez-vous.';

  @override
  String get errPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get errTooManyAttempts =>
      'Trop de tentatives. Patientez un instant puis réessayez.';

  @override
  String get errAlreadyMember => 'Vous êtes déjà membre de ce cabinet';

  @override
  String get errClinicCodeNotFound => 'Code du cabinet introuvable';

  @override
  String get errOnlyAdminCanApprove =>
      'Seul l\'administrateur du cabinet peut valider';

  @override
  String get errResetCodeInvalid =>
      'Le code est incorrect ou a expiré. Demandez-en un nouveau.';

  @override
  String get errSamePassword =>
      'Le nouveau mot de passe doit être différent de l\'ancien';

  @override
  String get errSignupIncomplete =>
      'L\'inscription n\'a pas pu être finalisée. Vérifiez la confirmation de votre e-mail.';

  @override
  String get errSessionRequired => 'Veuillez vous connecter';

  @override
  String get errClinicCreateFailed => 'Impossible de créer le cabinet';

  @override
  String get errRoleInvalid => 'Le rôle doit être praticien ou assistant(e)';

  @override
  String get errJoinRequestFailed => 'Impossible de créer la demande';

  @override
  String get errNotMember => 'Vous n\'êtes pas membre de ce cabinet';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get view => 'Voir';

  @override
  String get copy => 'Copier';

  @override
  String get approve => 'Valider';

  @override
  String get reject => 'Refuser';

  @override
  String get remove => 'Retirer';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get phoneOptionalLabel => 'Téléphone (facultatif)';

  @override
  String get noPhone => 'Pas de téléphone';

  @override
  String loadFailed(String error) {
    return 'Chargement impossible : $error';
  }

  @override
  String get clinicFallback => 'Cabinet';

  @override
  String get recalls => 'Rappels';

  @override
  String get todos => 'Tâches';

  @override
  String get followUps => 'Suivis';

  @override
  String get reports => 'Rapports';

  @override
  String get clinics => 'Cabinets';

  @override
  String get newPatient => 'Nouveau patient';

  @override
  String get addPatient => 'Ajouter un patient';

  @override
  String get patientAdded => 'Patient ajouté';

  @override
  String patientAddFailed(String error) {
    return 'Impossible d\'ajouter le patient : $error';
  }

  @override
  String get signOutTitle => 'Déconnexion';

  @override
  String get signOutConfirm => 'Voulez-vous vous déconnecter de votre compte ?';

  @override
  String get myClinics => 'Mes cabinets';

  @override
  String get copyCode => 'Copier le code';

  @override
  String get activeClinicCode => 'Code du cabinet actif';

  @override
  String get clinicCodeShareHint =>
      'Partagez le code : la personne qui rejoint attend votre validation et ne devient pas membre immédiatement.';

  @override
  String get joinRequests => 'Demandes d\'adhésion';

  @override
  String joinRequestsCount(int count) {
    return 'Demandes d\'adhésion ($count)';
  }

  @override
  String get members => 'Membres';

  @override
  String get appearance => 'Apparence';

  @override
  String get treatmentTemplates => 'Modèles d\'actes';

  @override
  String get addOrJoinClinic => 'Ajouter / rejoindre un autre cabinet';

  @override
  String followUpsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suivis arrivent à échéance',
      one: '1 suivi arrive à échéance',
    );
    return '$_temp0';
  }

  @override
  String get followUpsOffline =>
      'Pas de connexion Internet ou serveur injoignable. Impossible de charger les suivis.';

  @override
  String followUpsLoadFailed(String error) {
    return 'Impossible de charger les suivis : $error';
  }

  @override
  String get searchPatientsHint => 'Rechercher un patient (nom ou téléphone)…';

  @override
  String get sortByName => 'A–Z';

  @override
  String get sortByLastVisit => 'Dernier acte';

  @override
  String get selectPatientHint => 'Sélectionnez un patient pour voir le détail';

  @override
  String get themeLabel => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get colorPalette => 'Palette de couleurs';

  @override
  String get paletteClinic => 'Bleu clinique';

  @override
  String get paletteClinicDesc => 'Bleu ardoise calme et clinique';

  @override
  String get paletteOcean => 'Océan';

  @override
  String get paletteOceanDesc => 'Cyan profond, frais et aéré';

  @override
  String get paletteSage => 'Sauge';

  @override
  String get paletteSageDesc => 'Vert doux, ambiance médicale apaisée';

  @override
  String get paletteGraphite => 'Graphite';

  @override
  String get paletteGraphiteDesc => 'Graphite neutre, accent bleu glacier';

  @override
  String get paletteClassic => 'Vert classique';

  @override
  String get paletteClassicDesc => 'Accent vert vif';

  @override
  String get patientsLoadFailed => 'Impossible de charger les patients.';

  @override
  String get noPatientsYet =>
      'Aucun patient pour l\'instant.\nAjoutez-en un en haut à droite.';

  @override
  String get noPatientsMatch =>
      'Aucun patient ne correspond à votre recherche.';

  @override
  String get newProcedure => 'Nouvel acte';

  @override
  String get procedureSaved => 'Acte enregistré';

  @override
  String get plannedForNextSession => 'Prévu pour la prochaine séance';

  @override
  String get voiceNoteSaved => 'Note vocale enregistrée';

  @override
  String get editPatientTitle => 'Modifier le patient';

  @override
  String get deletePatientTitle => 'Supprimer le patient';

  @override
  String deletePatientConfirm(String name) {
    return 'Supprimer $name et toutes les données associées ?';
  }

  @override
  String patientDeleteFailed(String error) {
    return 'Impossible de supprimer le patient : $error';
  }

  @override
  String get sharePdfTitle => 'Partager l\'historique des soins';

  @override
  String get sharePdfWarning =>
      'Le PDF contient des données de santé du patient. Envoyez-le uniquement au patient lui-même ou, avec son accord, à des personnes habilitées.';

  @override
  String get createPdf => 'Créer le PDF';

  @override
  String followUpAdded(String title) {
    return 'Suivi ajouté : $title';
  }

  @override
  String get markedAsDone => 'Acte marqué comme réalisé';

  @override
  String completeFailed(String error) {
    return 'Impossible de terminer : $error';
  }

  @override
  String followUpCompleteFailed(String error) {
    return 'Impossible de terminer le suivi : $error';
  }

  @override
  String get deleteFollowUpTitle => 'Supprimer le suivi';

  @override
  String deleteItemConfirm(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String followUpDeleteFailed(String error) {
    return 'Impossible de supprimer le suivi : $error';
  }

  @override
  String get addFollowUp => 'Ajouter un suivi';

  @override
  String get voiceNote => 'Note vocale';

  @override
  String get shareAsPdf => 'Partager en PDF';

  @override
  String plannedProcedures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Actes prévus ($count)',
      one: 'Acte prévu',
    );
    return '$_temp0';
  }

  @override
  String get markDone => 'Fait';

  @override
  String dataLoadFailed(String error) {
    return 'Impossible de charger les données : $error';
  }

  @override
  String get noRecordsYet =>
      'Aucun enregistrement pour l\'instant.\nAjoutez une note vocale ou un acte.';

  @override
  String get openFollowUps => 'Suivis en cours';

  @override
  String labReminderOn(String date) {
    return 'Rappel laboratoire : $date';
  }

  @override
  String get complete => 'Terminer';

  @override
  String get pendingVoiceNotes => 'Notes vocales en attente';

  @override
  String get procedureHistory => 'Historique des actes';

  @override
  String get noProceduresYet => 'Aucun acte pour l\'instant.';

  @override
  String get processedVoiceNotes => 'Notes vocales traitées';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String procedureCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actes',
      one: '1 acte',
    );
    return '$_temp0';
  }

  @override
  String get manageCreateIntro =>
      'Vous créez un nouveau cabinet et en devenez l\'administrateur. Vos autres cabinets sont conservés — vous pouvez passer de l\'un à l\'autre.';

  @override
  String get manageJoinIntro =>
      'Saisissez le code du cabinet. Vous aurez accès après validation par l\'administrateur.';

  @override
  String clinicCreated(String name, String code) {
    return '$name créé. Code : $code';
  }

  @override
  String get joinRequestSent =>
      'Demande envoyée. En attente de validation par l\'administrateur.';

  @override
  String approvedName(String name) {
    return '$name : demande validée';
  }

  @override
  String approveFailed(String error) {
    return 'Validation impossible : $error';
  }

  @override
  String get rejectRequestTitle => 'Refuser la demande';

  @override
  String rejectRequestConfirm(String name) {
    return 'Voulez-vous refuser la demande de $name ?';
  }

  @override
  String rejectedName(String name) {
    return '$name : demande refusée';
  }

  @override
  String rejectFailed(String error) {
    return 'Refus impossible : $error';
  }

  @override
  String noPendingRequests(String clinic) {
    return 'Aucune demande en attente pour $clinic.';
  }

  @override
  String wantsToJoinAs(String role) {
    return 'Souhaite rejoindre en tant que $role';
  }

  @override
  String get awaitingApprovalTitle => 'En attente de validation';

  @override
  String get awaitingApprovalBody =>
      'Votre demande attend la validation de l\'administrateur du cabinet. Une fois validée, vous pourrez continuer d\'ici.';

  @override
  String get refreshStatus => 'Actualiser le statut';

  @override
  String get createOrJoinOtherClinic => 'Créer / rejoindre un autre cabinet';

  @override
  String get cannotChangeOwnAdmin =>
      'Vous ne pouvez pas modifier votre propre rôle d\'administrateur';

  @override
  String roleFor(String name) {
    return 'Rôle : $name';
  }

  @override
  String roleUpdateFailed(String error) {
    return 'Impossible de modifier le rôle : $error';
  }

  @override
  String get cannotRemoveOwnAdmin =>
      'Vous ne pouvez pas retirer votre compte administrateur ici';

  @override
  String get removeMemberTitle => 'Retirer le membre';

  @override
  String removeMemberConfirm(String name) {
    return 'Retirer $name du cabinet ?';
  }

  @override
  String removeFailed(String error) {
    return 'Impossible de retirer : $error';
  }

  @override
  String get clinicMembersTitle => 'Membres du cabinet';

  @override
  String memberYou(String name) {
    return '$name (vous)';
  }

  @override
  String get changeRole => 'Changer le rôle';
}
