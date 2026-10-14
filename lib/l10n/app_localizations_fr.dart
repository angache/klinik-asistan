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

  @override
  String get scopeTooth => 'Dent';

  @override
  String get scopeUpperJaw => 'Maxillaire';

  @override
  String get scopeLowerJaw => 'Mandibule';

  @override
  String get scopeFullMouth => 'Bouche entière';

  @override
  String scopeToothWithNumber(String teeth) {
    return 'Dent : $teeth';
  }

  @override
  String get fieldScope => 'Zone';

  @override
  String get fieldTooth => 'Dent';

  @override
  String get fieldTitle => 'Titre';

  @override
  String get fieldNote => 'Note';

  @override
  String get fieldCanalLength => 'Longueur canalaire';

  @override
  String get fieldFile => 'Lime';

  @override
  String get fieldMedicament => 'Médication';

  @override
  String get fieldDate => 'Date';

  @override
  String photosAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos ajoutées',
      one: '1 photo ajoutée',
    );
    return '$_temp0';
  }

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos supprimées',
      one: '1 photo supprimée',
    );
    return '$_temp0';
  }

  @override
  String get canalMain => 'Principal';

  @override
  String get handFile => 'Lime manuelle';

  @override
  String get noMedicament => 'Sans médication';

  @override
  String get errNoteConflict =>
      'Cet acte a été modifié par quelqu\'un d\'autre entre-temps. Actualisez la liste et réessayez.';

  @override
  String get errNoClinicSelected =>
      'Aucun cabinet sélectionné — connectez-vous d\'abord.';

  @override
  String get errNoPermissionDeletePatient =>
      'Vous n\'avez pas l\'autorisation de supprimer ce patient';

  @override
  String get errNoPermissionDeleteNote =>
      'Vous n\'avez pas l\'autorisation de supprimer cet acte';

  @override
  String labFollowUpTitle(String title) {
    return 'Labo : $title';
  }

  @override
  String labExpectedReturnOn(String date) {
    return 'Retour labo prévu : $date';
  }

  @override
  String labExpectedReturnFor(String date, String name) {
    return 'Retour labo prévu : $date · $name';
  }

  @override
  String get savingEllipsis => 'Enregistrement…';

  @override
  String get procedureDate => 'Date de l\'acte';

  @override
  String get select => 'Choisir';

  @override
  String get expectedLabReturn => 'Retour labo prévu';

  @override
  String get followUpDate => 'Date de contrôle';

  @override
  String get errSelectOrTypeProcedure =>
      'Choisissez un acte ou saisissez un titre';

  @override
  String get errSelectScope => 'Choisissez une zone';

  @override
  String get errSelectTooth => 'Choisissez au moins une dent';

  @override
  String get errSelectLabDate => 'Choisissez la date de retour labo prévue';

  @override
  String get errSelectFollowUpDate => 'Choisissez la date de contrôle';

  @override
  String get errFollowUpNoteRequired => 'Saisissez une note de suivi';

  @override
  String get uploadingPhotos => 'Envoi des photos vers le cloud…';

  @override
  String get savingProcedure => 'Enregistrement de l\'acte…';

  @override
  String uploadingPhotoProgress(int current, int total) {
    return 'Envoi de la photo ($current/$total)…';
  }

  @override
  String saveFailed(String error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get creatingLabReminder => 'Création du rappel labo…';

  @override
  String get creatingFollowUpReminder => 'Création du rappel de contrôle…';

  @override
  String followUpTitle(String title) {
    return 'Contrôle : $title';
  }

  @override
  String get reminderKindLab => 'labo';

  @override
  String get reminderKindFollowUp => 'contrôle';

  @override
  String reminderCreateFailed(String kinds) {
    return 'Acte enregistré, mais ces rappels n\'ont pas pu être créés : $kinds. Ajoutez-les depuis l\'écran Suivis.';
  }

  @override
  String get planForNextSession => 'Prévoir pour la prochaine séance';

  @override
  String saveTeethCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enregistrer $count dents',
      one: 'Enregistrer 1 dent',
    );
    return '$_temp0';
  }

  @override
  String get pastRecordHint =>
      'Ancien enregistrement (repris du cahier papier)';

  @override
  String get change => 'Modifier';

  @override
  String get procedureSection => 'Acte';

  @override
  String get procedureSectionHint =>
      'Choisissez au moins un acte ou saisissez un titre';

  @override
  String get procedureTitleLabel => 'Titre de l\'acte';

  @override
  String get noteOptionalLabel => 'Note (facultative)';

  @override
  String get noteHint => 'Écrivez ici si nécessaire…';

  @override
  String get addFollowUpSubtitle => 'Date de contrôle après l\'acte et rappel';

  @override
  String get followUpNoteLabel => 'Note de suivi';

  @override
  String get followUpNoteHint => 'ex. percussion et contrôle radiographique';

  @override
  String get presetOneWeek => '1 semaine';

  @override
  String get presetOneMonth => '1 mois';

  @override
  String get presetThreeMonths => '3 mois';

  @override
  String get presetSixMonths => '6 mois';

  @override
  String get pickDate => 'Choisir une date';

  @override
  String get remindWhenLabel => 'Quand faut-il vous rappeler ?';

  @override
  String get remindOnDay => 'Le jour du contrôle';

  @override
  String get remindOneDayBefore => '1 jour avant';

  @override
  String get remindThreeDaysBefore => '3 jours avant';

  @override
  String get remindOneWeekBefore => '1 semaine avant';

  @override
  String followUpSummary(String date, String reminder) {
    return 'Contrôle : $date · Rappel : $reminder';
  }

  @override
  String get scopeToothRequired =>
      'Le choix d\'une dent est obligatoire pour cet acte';

  @override
  String get scopeRequired => 'Le choix d\'une zone est obligatoire';

  @override
  String get scopeSuitable => 'Zone adaptée à l\'acte';

  @override
  String get canalSelectToothFirst =>
      'Choisissez d\'abord une dent pour saisir les paramètres canalaires. Avec plusieurs dents, chaque dent est enregistrée séparément.';

  @override
  String get canalPerToothTitle => 'Détails canalaires par dent';

  @override
  String get canalPerToothHint =>
      'Touchez une dent et saisissez ses paramètres. Chaque dent est enregistrée comme une note distincte.';

  @override
  String toothNumber(String tooth) {
    return 'Dent $tooth';
  }

  @override
  String get photoSection => 'Photo';

  @override
  String get photoPrivacyHint =>
      'Le visage du patient ne doit pas apparaître. Uniquement des images de l\'acte / intrabuccales.';

  @override
  String get planningSection => 'Planification';

  @override
  String get labCountsAsDone =>
      'Si envoyé au labo, l\'acte est considéré comme réalisé';

  @override
  String get info => 'Info';

  @override
  String get planInfoLabBlocked =>
      'Cette option est indisponible lorsque « Envoyé au labo » est coché ; l\'acte est considéré comme réalisé lors de cette séance.';

  @override
  String get planInfo =>
      'L\'acte est considéré comme non réalisé aujourd\'hui. Le patient est signalé en haut lors de sa prochaine visite ; une fois marqué « Fait », il est ajouté à l\'historique des actes de ce jour.';

  @override
  String get sentToLab => 'Envoyé au labo';

  @override
  String get sentToLabInfo =>
      'Cochez lorsque le travail est envoyé au laboratoire. La liste des suivis et une notification vous le rappellent 1 jour avant la date de retour prévue. L\'acte est alors considéré comme réalisé et « Prévoir pour la prochaine séance » est désactivé.';

  @override
  String addExtraCanalForTooth(String tooth) {
    return 'Ajouter un canal supplémentaire · Dent $tooth';
  }

  @override
  String get addExtraCanal => 'Ajouter un canal supplémentaire';

  @override
  String get extraCanalHint =>
      'Choisissez un canal absent de la liste habituelle ou saisissez un nom personnalisé.';

  @override
  String get allStandardCanalsAdded =>
      'Tous les codes standard sont déjà ajoutés. Utilisez un nom personnalisé.';

  @override
  String get customCanalName => 'Nom de canal personnalisé';

  @override
  String get customCanalHint => 'ex. MB3, DB2…';

  @override
  String get editProcedureTitle => 'Modifier l\'acte';

  @override
  String editVersionHint(int version) {
    return 'v$version → enregistré comme nouvelle version ; l\'ancienne est conservée';
  }

  @override
  String get errTitleRequired => 'Le titre de l\'acte est obligatoire';

  @override
  String get noChanges => 'Aucune modification';

  @override
  String get saveAsNewVersion => 'Enregistrer comme nouvelle version';

  @override
  String get quadrantUpperRight => 'Haut droit';

  @override
  String get quadrantUpperLeft => 'Haut gauche';

  @override
  String get quadrantLowerRight => 'Bas droit';

  @override
  String get quadrantLowerLeft => 'Bas gauche';

  @override
  String get toothNumberSection => 'Numéro de dent';

  @override
  String get clearSelection => 'Effacer la sélection';

  @override
  String get typeToSelectLabel => 'Saisir pour choisir (FDI)';

  @override
  String get typeToSelectHint => 'ex. 15  ou  14-17  ou  36,37';

  @override
  String get apply => 'Appliquer';

  @override
  String get toothSelectorHelp =>
      'Toucher : choisir · Appui long : agrandir le quadrant · Glisser vers le bas ou OK : fermer';

  @override
  String get jawUpper => 'HAUT';

  @override
  String get jawLower => 'BAS';

  @override
  String get sideRight => 'Droite';

  @override
  String get sideLeft => 'Gauche';

  @override
  String get selectTeeth => 'Choisissez des dents';

  @override
  String selectedTeeth(String teeth) {
    return 'Sélection : $teeth';
  }

  @override
  String get swipeDownToClose =>
      'Vous pouvez aussi glisser vers le bas pour fermer';

  @override
  String canalParamsForTooth(String tooth) {
    return 'Paramètres canalaires · Dent $tooth';
  }

  @override
  String get canalParamsTitle => 'Paramètres du traitement canalaire';

  @override
  String get canalLengthMm => 'Longueur canalaire (mm)';

  @override
  String get extra => 'Supplément';

  @override
  String get fileSystem => 'Système de limes';

  @override
  String get intracanalMedicament => 'Médication intracanalaire';

  @override
  String toothCanalHint(String tooth, String canals) {
    return 'Dent $tooth · habituel : $canals — ajoutez-en si nécessaire';
  }

  @override
  String get newVersionSaved => 'Nouvelle version enregistrée';

  @override
  String get deleteProcedureTitle => 'Supprimer l\'acte';

  @override
  String get deleteProcedureConfirm =>
      'Cette note et ses éventuelles versions précédentes seront définitivement supprimées.';

  @override
  String get procedureDeleted => 'Acte supprimé';

  @override
  String procedureDeleteFailed(String error) {
    return 'Impossible de supprimer l\'acte : $error';
  }

  @override
  String get labShort => 'Labo';

  @override
  String labReturnShort(String date) {
    return 'Labo → $date';
  }

  @override
  String get history => 'Historique';

  @override
  String get share => 'Partager';

  @override
  String get versionHistory => 'Historique des versions';

  @override
  String historyLoadFailed(String error) {
    return 'Impossible de charger l\'historique : $error';
  }

  @override
  String get noVersionsFound => 'Aucune version trouvée';

  @override
  String get currentVersion => 'Actuelle';

  @override
  String get oldVersion => 'Ancienne version';

  @override
  String get changesInVersion => 'Modifications dans cette version';

  @override
  String get firstRecord => 'Premier enregistrement';

  @override
  String get micPermissionRequired => 'L\'autorisation du micro est requise';

  @override
  String get micPermissionMissing => 'Pas d\'autorisation du micro';

  @override
  String get recordingEmpty =>
      'L\'enregistrement est vide ou n\'a pas pu être créé';

  @override
  String voiceUploadFailed(String error) {
    return 'Impossible d\'envoyer l\'enregistrement vocal : $error';
  }

  @override
  String get quickVoiceNote => 'Note vocale rapide';

  @override
  String get voicePrivacyHint =>
      'L\'audio sert uniquement au résumé de l\'acte par le praticien ou l\'assistant(e). Les conversations avec le patient ne sont pas enregistrées.';

  @override
  String get recordingInProgress => 'Enregistrement en cours…';

  @override
  String get uploadingVoice => 'Envoi de l\'audio vers le cloud…';

  @override
  String get voiceStartHint =>
      'Touchez le micro et parlez, puis touchez « Terminer et enregistrer »';

  @override
  String get pleaseWait => 'Veuillez patienter…';

  @override
  String get finishAndSave => 'Terminer et enregistrer';

  @override
  String playFailed(String error) {
    return 'Lecture impossible : $error';
  }

  @override
  String get memoMarkedProcessed => 'Note vocale marquée comme traitée';

  @override
  String markFailed(String error) {
    return 'Impossible de marquer : $error';
  }

  @override
  String get deleteVoiceNoteTitle => 'Supprimer la note vocale';

  @override
  String get deleteVoiceNoteConfirm =>
      'Cette note vocale sera définitivement supprimée.';

  @override
  String deleteFailed(String error) {
    return 'Suppression impossible : $error';
  }

  @override
  String get processedVoiceNote => 'Note vocale traitée';

  @override
  String get pendingVoiceNote => 'Note vocale en attente';

  @override
  String durationLabel(String duration) {
    return 'Durée : $duration';
  }

  @override
  String get stop => 'Arrêter';

  @override
  String get listen => 'Écouter';

  @override
  String get convertToNote => 'Convertir en note';

  @override
  String get audioFileEmpty => 'Le fichier audio est vide';

  @override
  String photoOpenFailed(String error) {
    return 'Impossible d\'ouvrir la photo : $error';
  }

  @override
  String photoCount(int count, int max) {
    return '$count / $max photos';
  }

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get fromGallery => 'Depuis la galerie';

  @override
  String get shareThisPhoto => 'Partager cette photo';

  @override
  String shareAllPhotos(int count) {
    return 'Partager toutes les photos ($count)';
  }

  @override
  String get procedurePhoto => 'Photo de l\'acte';

  @override
  String procedurePhotoIndex(int index, int count) {
    return 'Photo de l\'acte $index/$count';
  }

  @override
  String get shareTooltip => 'Partager (WhatsApp, e-mail…)';

  @override
  String get photoLoadFailed => 'Impossible de charger la photo';

  @override
  String preparingPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Préparation de $count photos…',
      one: 'Préparation de la photo…',
    );
    return '$_temp0';
  }

  @override
  String shareFailed(String error) {
    return 'Partage impossible : $error';
  }

  @override
  String completedItem(String title) {
    return 'Terminé : $title';
  }

  @override
  String actionFailed(String error) {
    return 'Échec de l\'action : $error';
  }

  @override
  String deletedItem(String title) {
    return 'Supprimé : $title';
  }

  @override
  String patientOpenFailed(String error) {
    return 'Impossible d\'ouvrir le patient : $error';
  }

  @override
  String get noOpenFollowUps => 'Aucun suivi ouvert.';

  @override
  String get sectionOverdue => 'En retard';

  @override
  String get sectionReminderDue => 'À venir (rappel échu)';

  @override
  String get sectionUpcoming => 'À venir';

  @override
  String get patientFallback => 'Patient';

  @override
  String reminderOn(String date) {
    return 'Rappel : $date';
  }

  @override
  String get goToPatient => 'Aller au patient';

  @override
  String get errFollowUpTitleRequired => 'Saisissez un titre de suivi';

  @override
  String get followUpWhatLabel => 'Que faut-il suivre ?';

  @override
  String get followUpWhatHint =>
      'ex. Contrôle, retrait des points, contrôle de la douleur…';

  @override
  String get whenLabel => 'Quand ?';

  @override
  String notifFollowUpTitle(String name) {
    return 'Suivi : $name';
  }

  @override
  String notifCheckupBody(String title, String date) {
    return '$title · Contrôle : $date';
  }

  @override
  String get notifChannelFollowUps => 'Suivis';

  @override
  String get notifChannelFollowUpsDesc => 'Rappels de contrôle et de suivi';

  @override
  String get notifChannelClinic => 'Notifications du cabinet';

  @override
  String get notifChannelClinicDesc =>
      'Rappels d\'adhésion, de suivi et de tâches';

  @override
  String get todoAdded => 'Tâche ajoutée';

  @override
  String get noOpenTodos =>
      'Aucune tâche ouverte.\nAppuyez sur Ajouter pour créer une note écrite ou vocale.';

  @override
  String get todosIntro =>
      'Notes générales du cabinet — rendez-vous, rappels, relances…';

  @override
  String get sectionUndated => 'Sans date';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterMine => 'Qui me sont attribuées';

  @override
  String get filterTodayOverdue => 'Aujourd\'hui/en retard';

  @override
  String get filterCompleted => 'Terminées';

  @override
  String commentAddFailed(String error) {
    return 'Impossible d\'ajouter le commentaire : $error';
  }

  @override
  String get camera => 'Appareil photo';

  @override
  String get gallery => 'Galerie';

  @override
  String get cameraPermissionRequired =>
      'L\'autorisation de l\'appareil photo est requise';

  @override
  String cameraOpenFailed(String error) {
    return 'Impossible d\'ouvrir l\'appareil photo : $error';
  }

  @override
  String galleryOpenFailed(String error) {
    return 'Impossible d\'ouvrir la galerie : $error';
  }

  @override
  String imageAddFailed(String error) {
    return 'Impossible d\'ajouter l\'image : $error';
  }

  @override
  String imageOpenFailed(String error) {
    return 'Impossible d\'ouvrir l\'image : $error';
  }

  @override
  String get deleteImageTitle => 'Supprimer l\'image';

  @override
  String get deleteImageConfirm => 'Retirer cette image de la tâche ?';

  @override
  String imageDeleteFailed(String error) {
    return 'Impossible de supprimer l\'image : $error';
  }

  @override
  String get todoDetailTitle => 'Détails de la tâche';

  @override
  String get refresh => 'Actualiser';

  @override
  String get markAsCompleted => 'Marquer comme terminée';

  @override
  String get wholeClinic => 'Tout le cabinet';

  @override
  String get clinicMemberFallback => 'Membre du cabinet';

  @override
  String createdByOn(String name, String date) {
    return 'Créée par $name le $date';
  }

  @override
  String get images => 'Images';

  @override
  String get noImages => 'Aucune image ajoutée';

  @override
  String commentsCount(int count) {
    return 'Commentaires ($count)';
  }

  @override
  String get noCommentsYet => 'Pas encore de commentaire';

  @override
  String get addCommentHint => 'Ajouter un commentaire…';

  @override
  String get noHistory => 'Aucun historique';

  @override
  String get eventCreated => 'Tâche créée';

  @override
  String get eventCompleted => 'Tâche terminée';

  @override
  String get eventCommentAdded => 'Commentaire ajouté';

  @override
  String get eventImageAdded => 'Image ajoutée';

  @override
  String get eventImageDeleted => 'Image supprimée';

  @override
  String get completedMessage => 'Terminé';

  @override
  String get deleteTodoConfirm => 'Supprimer cette tâche ?';

  @override
  String get priorityNormal => 'Normale';

  @override
  String get priorityImportant => 'Importante';

  @override
  String get priorityUrgent => 'Urgente';

  @override
  String get recurrenceNone => 'Pas de répétition';

  @override
  String get recurrenceDaily => 'Tous les jours';

  @override
  String get recurrenceWeekly => 'Toutes les semaines';

  @override
  String get recurrenceMonthly => 'Tous les mois';

  @override
  String get voiceTodo => 'Tâche vocale';

  @override
  String get todoFallback => 'Tâche';

  @override
  String previewPlayFailed(String error) {
    return 'Impossible de lire l\'aperçu : $error';
  }

  @override
  String get taskTime => 'Heure de la tâche';

  @override
  String get errTextOrVoiceRequired =>
      'Écrivez une note ou enregistrez un audio';

  @override
  String get errFinishRecordingFirst => 'Terminez d\'abord l\'enregistrement';

  @override
  String get addTodo => 'Ajouter une tâche';

  @override
  String get todoNoteHint =>
      'ex. Donner un rendez-vous à M. Martin demain, rappeler le patient…';

  @override
  String get voiceOptional => 'Audio (facultatif)';

  @override
  String get finish => 'Terminer';

  @override
  String voiceRecorded(String duration) {
    return 'Audio enregistré · $duration';
  }

  @override
  String get reRecord => 'Réenregistrer';

  @override
  String get recordVoice => 'Enregistrer un audio';

  @override
  String get tomorrow => 'Demain';

  @override
  String targetDate(String date) {
    return 'Échéance : $date';
  }

  @override
  String get priority => 'Priorité';

  @override
  String get addTime => 'Ajouter une heure';

  @override
  String get assignee => 'Responsable';

  @override
  String get patientLinkOptional => 'Patient associé (facultatif)';

  @override
  String get noPatientSelected => 'Aucun patient sélectionné';

  @override
  String get recurrence => 'Répétition';

  @override
  String get reminder => 'Rappel';

  @override
  String get remindOnTime => 'À l\'heure';

  @override
  String get remindOneHourBefore => '1 heure avant';

  @override
  String get errCommentEmpty => 'Le commentaire ne peut pas être vide';

  @override
  String get recurringTask => 'Tâche récurrente';

  @override
  String get errInvalidFilePath => 'Chemin de fichier invalide';

  @override
  String get periodThisWeek => 'Cette semaine';

  @override
  String get periodLastWeek => 'Semaine dernière';

  @override
  String get periodThisMonth => 'Ce mois-ci';

  @override
  String get periodLastMonth => 'Mois dernier';

  @override
  String get reportPeriod => 'Période du rapport';

  @override
  String comparedWith(String range) {
    return 'Comparaison : $range';
  }

  @override
  String get topProcedures => 'Actes les plus réalisés';

  @override
  String get noProceduresInPeriod => 'Aucun acte enregistré sur cette période.';

  @override
  String get byCategory => 'Par catégorie';

  @override
  String get dailyActivity => 'Activité par jour';

  @override
  String get followUpStatus => 'État des suivis';

  @override
  String get patientsToRecall => 'Patients à rappeler';

  @override
  String daysPlus(int days) {
    return '$days+ jours';
  }

  @override
  String get noRecallsDue => 'Aucun patient n\'est à revoir pour un contrôle.';

  @override
  String recallsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count patients attendent un contrôle',
      one: '1 patient attend un contrôle',
    );
    return '$_temp0';
  }

  @override
  String oldRecallsCount(int count) {
    return '+ $count anciens patients (contrôle dépassé depuis plus de 12 mois)';
  }

  @override
  String get openList => 'Ouvrir la liste';

  @override
  String get statProceduresDone => 'Actes réalisés';

  @override
  String get statProceduresHint =>
      'Les actes sur plusieurs dents sont comptés par dent';

  @override
  String get statPatientsTreated => 'Patients traités';

  @override
  String get statVisits => 'Visites de patients';

  @override
  String get statVisitsHint =>
      'Les visites d\'un même patient à des jours différents sont comptées séparément';

  @override
  String get statNewPatients => 'Nouveaux patients';

  @override
  String get statTotalPatients => 'Total des patients';

  @override
  String get statPendingPlanned => 'Actes planifiés en attente';

  @override
  String get sameAsPrevious => 'Identique à la période précédente';

  @override
  String weekOf(String label) {
    return 'Semaine du $label';
  }

  @override
  String busiestDay(String day, String procedures) {
    return 'Jour le plus chargé : $day ($procedures)';
  }

  @override
  String overdueCount(int count) {
    return '$count en retard';
  }

  @override
  String get labPending => 'Travaux en attente au laboratoire';

  @override
  String get controlPending => 'Contrôles en attente';

  @override
  String get openTasks => 'Tâches ouvertes';

  @override
  String completedInPeriod(int lab, int control, int task) {
    return 'Terminés sur la période — labo : $lab, contrôles : $control, tâches : $task';
  }

  @override
  String stalledHint(int days) {
    return 'Patients ayant des actes planifiés, sans visite depuis $days jours et sans contrôle à venir.';
  }

  @override
  String get noPatientsToRecall => 'Aucun patient à rappeler.';

  @override
  String lastProcedure(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'il y a $days jours',
      one: 'il y a 1 jour',
      zero: 'aujourd\'hui',
    );
    return 'Dernier acte : $date ($_temp0)';
  }

  @override
  String plannedList(String items) {
    return 'Planifié : $items';
  }

  @override
  String callPhone(String phone) {
    return 'Appeler : $phone';
  }

  @override
  String firstNPatients(int count) {
    return 'Affichage des $count premiers patients.';
  }

  @override
  String get moreAfterLogging =>
      'Les suivants apparaissent à mesure que vous enregistrez les résultats d\'appel.';

  @override
  String get call => 'Appeler';

  @override
  String get recallResultAppointment => 'Rendez-vous pris';

  @override
  String get recallResultUnreachable => 'Injoignable';

  @override
  String get recallResultDeclined => 'Refuse';

  @override
  String get recallAppointmentHint =>
      'Choisissez une date de contrôle ; un suivi est créé';

  @override
  String get recallUnreachableHint => 'Revient dans la liste dans 7 jours';

  @override
  String get recallDeclinedHint => 'Masqué de la liste jusqu\'au prochain acte';

  @override
  String get openPatientCard => 'Ouvrir la fiche patient';

  @override
  String recallLogged(String name, String result) {
    return '$name : enregistré comme « $result »';
  }

  @override
  String get undo => 'Annuler';

  @override
  String undoFailed(String error) {
    return 'Impossible d\'annuler : $error';
  }

  @override
  String recallDateHelp(String name) {
    return '$name · date du contrôle';
  }

  @override
  String get periodicCheckup => 'Contrôle périodique';

  @override
  String checkupReason(String procedure, String date) {
    return 'Motif du contrôle : $procedure ($date)';
  }

  @override
  String checkupScheduled(String name, String date) {
    return '$name : contrôle prévu le $date';
  }

  @override
  String appointmentSaveFailed(String error) {
    return 'Impossible d\'enregistrer le rendez-vous : $error';
  }

  @override
  String get recallCurrent => 'Actuels';

  @override
  String get recallOld => 'Anciens patients';

  @override
  String get recallOldHint =>
      'Patients dont la date de contrôle est dépassée depuis plus de 12 mois. Ils sont listés à part car ils ne sont pas venus depuis longtemps.';

  @override
  String get recallCurrentHint =>
      'Patients dont le délai de contrôle après un acte est écoulé. Les délais se règlent dans l\'écran Modèles d\'actes. Les patients ayant un rendez-vous, un acte planifié ou un suivi à venir n\'apparaissent pas.';

  @override
  String get noOldRecalls => 'Aucun ancien patient en attente de contrôle.';

  @override
  String checkupDue(String date) {
    return 'Contrôle : $date';
  }

  @override
  String checkupOverdue(String date, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months mois de retard',
      one: '1 mois de retard',
    );
    return 'Contrôle : $date ($_temp0)';
  }

  @override
  String lastCall(String result) {
    return 'Dernier appel : $result';
  }

  @override
  String get noMissingDefaults => 'Aucun acte par défaut manquant';

  @override
  String defaultsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actes par défaut ajoutés',
      one: '1 acte par défaut ajouté',
    );
    return '$_temp0';
  }

  @override
  String addFailed(String error) {
    return 'Impossible d\'ajouter : $error';
  }

  @override
  String updateFailed(String error) {
    return 'Impossible de mettre à jour : $error';
  }

  @override
  String deleteTemplateConfirm(String name) {
    return 'Retirer « $name » de la liste ?\nLes dossiers patients passés ne sont pas affectés.';
  }

  @override
  String get seedMissingTooltip => 'Restaurer les actes par défaut manquants';

  @override
  String get hideInactive => 'Masquer les inactifs';

  @override
  String get showInactive => 'Afficher les inactifs';

  @override
  String get addProcedure => 'Ajouter un acte';

  @override
  String get templatesIntro =>
      'Liste des actes du cabinet. Ils apparaissent dans le formulaire de nouvel acte. Les dossiers passés ne changent pas.';

  @override
  String get templatesEditRestricted =>
      'Seuls les praticiens ou administrateurs peuvent modifier.';

  @override
  String get tagCanal => 'Endodontie';

  @override
  String get tagToothRequired => 'Dent obligatoire';

  @override
  String get tagJawOk => 'Mâchoire/bouche OK';

  @override
  String get tagLabTracking => 'Suivi labo';

  @override
  String tagCheckupMonths(int months) {
    return 'Contrôle : $months mois';
  }

  @override
  String get tagInactive => 'Inactif';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get activate => 'Activer';

  @override
  String get noTemplatesYet => 'Aucun acte pour l\'instant.';

  @override
  String get category => 'Catégorie';

  @override
  String get procedureName => 'Nom de l\'acte';

  @override
  String get nameRequired => 'Le nom est obligatoire';

  @override
  String get canalProcedure => 'Acte d\'endodontie';

  @override
  String get canalProcedureHint =>
      'Affiche les champs longueur de canal / limes';

  @override
  String get toothRequired => 'Sélection de dent obligatoire';

  @override
  String get toothRequiredHint =>
      'Si désactivé, maxillaire/mandibule ou bouche entière sont possibles';

  @override
  String get labTracking => 'Suivi labo';

  @override
  String get labTrackingHint =>
      'Affiche « Envoyé au labo » et la date de retour dans le formulaire';

  @override
  String get periodicCheckupHelper =>
      'Après cet acte, le patient est ajouté à la liste des rappels';

  @override
  String get none => 'Aucun';

  @override
  String monthsAfter(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months mois après',
      one: '1 mois après',
    );
    return '$_temp0';
  }

  @override
  String get active => 'Actif';

  @override
  String get catDiagnosis => 'Diagnostic et planification';

  @override
  String get catTreatment => 'Soins';

  @override
  String get catProsthetics => 'Prothèse';

  @override
  String get catGeneral => 'Général';

  @override
  String pdfDocTitle(String name) {
    return 'Historique des soins - $name';
  }

  @override
  String pdfHeader(String name) {
    return '$name · Historique des soins';
  }

  @override
  String get pdfConfidential =>
      'Confidentiel : contient des données personnelles sensibles (données de santé).';

  @override
  String pdfPage(int page, int total) {
    return 'Page $page / $total';
  }

  @override
  String get pdfSubtitle => 'Historique des soins du patient';

  @override
  String get pdfRegistered => 'Date d\'inscription';

  @override
  String get pdfReportDate => 'Date du rapport';

  @override
  String pdfPreparedBy(String name) {
    return 'Préparé par : $name';
  }

  @override
  String pdfDoneProcedures(int count) {
    return 'Actes réalisés ($count)';
  }

  @override
  String get pdfNoProcedures => 'Aucun acte enregistré.';

  @override
  String pdfPlannedProcedures(int count) {
    return 'Actes planifiés ($count)';
  }

  @override
  String get pdfColAdded => 'Ajouté';

  @override
  String get pdfColDetails => 'Détails';

  @override
  String pdfLabReturn(String date) {
    return 'Labo · retour $date';
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
  String get preparingPdf => 'Préparation du PDF…';

  @override
  String get pdfFilePrefix => 'historique_soins';

  @override
  String pdfCreateFailed(String error) {
    return 'Impossible de créer le PDF : $error';
  }

  @override
  String get pdfTreatmentHistory => 'Historique des soins';

  @override
  String get errRequestNotFound => 'Demande introuvable';

  @override
  String get errRequestAlreadyAnswered =>
      'Cette demande a déjà reçu une réponse';

  @override
  String get errAssigneeOtherClinic =>
      'Le responsable doit appartenir au même cabinet que la tâche';

  @override
  String get errPatientOtherClinic =>
      'Le patient doit appartenir au même cabinet que la tâche';

  @override
  String get errNoReportPermission =>
      'Vous n\'êtes pas autorisé à consulter les rapports de ce cabinet';

  @override
  String get errInvalidDateRange => 'Période non valide';

  @override
  String get errNoListPermission =>
      'Vous n\'êtes pas autorisé à consulter cette liste du cabinet';

  @override
  String get errNothingToSave => 'Rien à enregistrer';

  @override
  String get errNoteNotFound => 'Enregistrement introuvable';

  @override
  String get errNoPermission =>
      'Vous n\'êtes pas autorisé à effectuer cette action';

  @override
  String get errOffline => 'Pas de connexion Internet. Veuillez réessayer.';

  @override
  String get tplTreatmentPlanning => 'Plan de traitement';

  @override
  String get tplInitialExam => 'Premier examen / Diagnostic';

  @override
  String get tplCanalStart => 'Traitement canalaire – début';

  @override
  String get tplCanalFinish => 'Traitement canalaire – fin';

  @override
  String get tplCanalRetreatment => 'Retraitement canalaire';

  @override
  String get tplCompositeFilling => 'Obturation composite';

  @override
  String get tplPulpCapping => 'Coiffage pulpaire';

  @override
  String get tplExtraction => 'Extraction dentaire';

  @override
  String get tplComplicatedExtraction => 'Extraction complexe';

  @override
  String get tplSurgicalExtraction => 'Extraction chirurgicale';

  @override
  String get tplAlveolitis => 'Traitement d\'alvéolite (pansement)';

  @override
  String get tplCurettage => 'Curetage';

  @override
  String get tplWhitening => 'Blanchiment';

  @override
  String get tplToothPreparation => 'Préparation dentaire';

  @override
  String get tplImpression => 'Empreinte';

  @override
  String get tplFrameworkTryIn => 'Essayage de l\'armature';

  @override
  String get tplBisqueTryIn => 'Essayage biscuit';

  @override
  String get tplTempCementation => 'Scellement provisoire';

  @override
  String get tplPermCementation => 'Scellement définitif';

  @override
  String get tplNightGuardImpression => 'Empreinte gouttière nocturne';

  @override
  String get tplScaling => 'Détartrage (nettoyage)';

  @override
  String get tplCheckup => 'Contrôle';

  @override
  String get errClinicInfoMissing => 'Informations du cabinet manquantes';
}
