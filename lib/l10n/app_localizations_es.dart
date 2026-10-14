// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailRequired => 'El correo es obligatorio';

  @override
  String get emailInvalid => 'Introduce un correo válido';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String get fullNameLabel => 'Nombre y apellidos';

  @override
  String get fullNameRequired => 'El nombre es obligatorio';

  @override
  String get retry => 'Reintentar';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get settingsAndAccount => 'Ajustes y cuenta';

  @override
  String linkOpenFailed(String url) {
    return 'No se pudo abrir el enlace: $url';
  }

  @override
  String clinicCodeCopied(String code) {
    return 'Código de la clínica copiado: $code';
  }

  @override
  String get userFallback => 'Usuario';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleDoctor => 'Odontólogo';

  @override
  String get roleAssistant => 'Asistente';

  @override
  String get joinStatusPending => 'Pendiente de aprobación';

  @override
  String get joinStatusApproved => 'Aprobada';

  @override
  String get joinStatusRejected => 'Rechazada';

  @override
  String get loginSubtitle => 'Inicia sesión';

  @override
  String get forgotPassword => 'He olvidado mi contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginCreateAccount => 'Crear cuenta / Unirse a una clínica';

  @override
  String get loginFailed => 'No se pudo iniciar sesión';

  @override
  String get clinicRequiredTitle => 'Se necesita una clínica';

  @override
  String get serverUnreachableTitle => 'No se pudo conectar con el servidor';

  @override
  String get serverUnreachableBody =>
      'Comprueba tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get signupTitle => 'Registrarse';

  @override
  String get createClinic => 'Crear clínica';

  @override
  String get joinClinic => 'Unirse a una clínica';

  @override
  String get signupCreateIntro =>
      'Creas una clínica nueva y pasas a ser su administrador y odontólogo. Invitas a los asistentes con el código de la clínica.';

  @override
  String get clinicNameLabel => 'Nombre de la clínica';

  @override
  String get clinicNameRequired => 'El nombre de la clínica es obligatorio';

  @override
  String get alreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get signupJoinIntro =>
      'Envía una solicitud con el código de la clínica que te dio el administrador. Tendrás acceso cuando la apruebe.';

  @override
  String get clinicCodeLabel => 'Código de la clínica';

  @override
  String get clinicCodeHint => 'p. ej. A3K9PX';

  @override
  String get clinicCodeRequired => 'El código es obligatorio';

  @override
  String get myRole => 'Mi rol';

  @override
  String get joinButton => 'Unirme';

  @override
  String get resetCodeSent =>
      'Si la dirección está registrada, te hemos enviado un código por correo';

  @override
  String get passwordUpdated => 'Tu contraseña se ha actualizado';

  @override
  String get resetIntroEmail =>
      'Introduce el correo de tu cuenta y te enviaremos un código para restablecer la contraseña.';

  @override
  String get resetIntroCode =>
      'Introduce el código del correo y tu nueva contraseña.';

  @override
  String get resetCodeLabel => 'Código';

  @override
  String get resetCodeInvalid => 'Introduce el código del correo';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get newPasswordRepeatLabel => 'Nueva contraseña (repetir)';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get updatePasswordButton => 'Actualizar contraseña';

  @override
  String get sendCodeButton => 'Enviar código';

  @override
  String get resetRequestNewCode => 'Pedir un código nuevo / cambiar correo';

  @override
  String get legalConsentText =>
      'He leído el aviso de privacidad, la política de privacidad y las condiciones de uso, y me comprometo a tratar los datos de los pacientes únicamente con fines de diagnóstico y tratamiento, conforme a la normativa de protección de datos.';

  @override
  String get legalConsentRequired => 'Debes aceptar para continuar';

  @override
  String get privacyNotice => 'Aviso de privacidad';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Condiciones de uso';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAccountSection => 'Cuenta';

  @override
  String get settingsLegalSection => 'Información legal';

  @override
  String supportEmail(String email) {
    return 'Soporte: $email';
  }

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSystem => 'Idioma del teléfono';

  @override
  String get settingsDangerZone => 'Zona de peligro';

  @override
  String get deleteMyAccount => 'Eliminar mi cuenta';

  @override
  String get deleteMyAccountSubtitle =>
      'Tu cuenta se eliminará de forma permanente';

  @override
  String accountInfoFailed(String error) {
    return 'No se pudo obtener la información de la cuenta: $error';
  }

  @override
  String get transferAdminTitle => 'Primero transfiere el rol de administrador';

  @override
  String transferAdminBody(String clinics) {
    return 'Eres el único administrador de estas clínicas, que tienen otros miembros:\n\n$clinics\n\nNombra administrador a otro miembro desde la pantalla Miembros y vuelve a intentarlo.';
  }

  @override
  String get accountDeleted => 'Tu cuenta se ha eliminado';

  @override
  String accountDeleteFailed(String error) {
    return 'No se pudo eliminar la cuenta: $error';
  }

  @override
  String serverError(int status) {
    return 'Error del servidor ($status)';
  }

  @override
  String get deleteAccountTitle => 'Eliminar la cuenta definitivamente';

  @override
  String get deleteAccountWarning =>
      'Se eliminarán tu cuenta y tus datos de acceso. Esta acción no se puede deshacer.';

  @override
  String get deleteAccountClinicsWarning =>
      'Eres el único miembro de las clínicas siguientes. Se eliminarán junto con todas las fichas de pacientes, tratamientos, fotos y grabaciones de voz:';

  @override
  String get deleteAccountMembershipOnly =>
      'Los datos de las clínicas de las que eres miembro se quedan en la clínica; solo termina tu membresía.';

  @override
  String deleteAccountTypeToConfirm(String word) {
    return 'Escribe \"$word\" para confirmar:';
  }

  @override
  String get deleteAccountConfirmWord => 'ELIMINAR';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String get errInvalidCredentials => 'Correo o contraseña incorrectos';

  @override
  String get errAlreadyRegistered =>
      'Este correo ya está registrado. Inicia sesión.';

  @override
  String get errPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get errTooManyAttempts =>
      'Demasiados intentos. Espera un momento y vuelve a intentarlo.';

  @override
  String get errAlreadyMember => 'Ya eres miembro de esta clínica';

  @override
  String get errClinicCodeNotFound => 'No se encontró el código de la clínica';

  @override
  String get errOnlyAdminCanApprove =>
      'Solo el administrador de la clínica puede aprobar';

  @override
  String get errResetCodeInvalid =>
      'El código es incorrecto o ha caducado. Pide uno nuevo.';

  @override
  String get errSamePassword =>
      'La nueva contraseña debe ser distinta de la anterior';

  @override
  String get errSignupIncomplete =>
      'No se pudo completar el registro. Comprueba la verificación del correo.';

  @override
  String get errSessionRequired => 'Inicia sesión';

  @override
  String get errClinicCreateFailed => 'No se pudo crear la clínica';

  @override
  String get errRoleInvalid => 'El rol debe ser odontólogo o asistente';

  @override
  String get errJoinRequestFailed => 'No se pudo crear la solicitud';

  @override
  String get errNotMember => 'No eres miembro de esta clínica';

  @override
  String get add => 'Añadir';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get close => 'Cerrar';

  @override
  String get view => 'Ver';

  @override
  String get copy => 'Copiar';

  @override
  String get approve => 'Aprobar';

  @override
  String get reject => 'Rechazar';

  @override
  String get remove => 'Quitar';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get phoneOptionalLabel => 'Teléfono (opcional)';

  @override
  String get noPhone => 'Sin teléfono';

  @override
  String loadFailed(String error) {
    return 'No se pudo cargar: $error';
  }

  @override
  String get clinicFallback => 'Clínica';

  @override
  String get recalls => 'Revisiones';

  @override
  String get todos => 'Tareas';

  @override
  String get followUps => 'Seguimientos';

  @override
  String get reports => 'Informes';

  @override
  String get clinics => 'Clínicas';

  @override
  String get newPatient => 'Nuevo paciente';

  @override
  String get addPatient => 'Añadir paciente';

  @override
  String get patientAdded => 'Paciente añadido';

  @override
  String patientAddFailed(String error) {
    return 'No se pudo añadir el paciente: $error';
  }

  @override
  String get signOutTitle => 'Cerrar sesión';

  @override
  String get signOutConfirm => '¿Quieres cerrar la sesión de tu cuenta?';

  @override
  String get myClinics => 'Mis clínicas';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get activeClinicCode => 'Código de la clínica activa';

  @override
  String get clinicCodeShareHint =>
      'Comparte el código; quien se una esperará tu aprobación y no será miembro de inmediato.';

  @override
  String get joinRequests => 'Solicitudes de acceso';

  @override
  String joinRequestsCount(int count) {
    return 'Solicitudes de acceso ($count)';
  }

  @override
  String get members => 'Miembros';

  @override
  String get appearance => 'Apariencia';

  @override
  String get treatmentTemplates => 'Plantillas de tratamientos';

  @override
  String get addOrJoinClinic => 'Añadir / unirse a otra clínica';

  @override
  String followUpsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ha llegado la fecha de $count seguimientos',
      one: 'Ha llegado la fecha de 1 seguimiento',
    );
    return '$_temp0';
  }

  @override
  String get followUpsOffline =>
      'Sin conexión a Internet o no se puede acceder al servidor. No se pudieron cargar los seguimientos.';

  @override
  String followUpsLoadFailed(String error) {
    return 'No se pudieron cargar los seguimientos: $error';
  }

  @override
  String get searchPatientsHint => 'Buscar pacientes (nombre o teléfono)…';

  @override
  String get sortByName => 'A–Z';

  @override
  String get sortByLastVisit => 'Último tratamiento';

  @override
  String get selectPatientHint => 'Selecciona un paciente para ver el detalle';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get colorPalette => 'Paleta de colores';

  @override
  String get paletteClinic => 'Azul clínico';

  @override
  String get paletteClinicDesc => 'Azul pizarra, sereno y clínico';

  @override
  String get paletteOcean => 'Océano';

  @override
  String get paletteOceanDesc => 'Cian profundo, fresco y luminoso';

  @override
  String get paletteSage => 'Salvia';

  @override
  String get paletteSageDesc => 'Verde suave, ambiente médico tranquilo';

  @override
  String get paletteGraphite => 'Grafito';

  @override
  String get paletteGraphiteDesc => 'Grafito neutro con acento azul hielo';

  @override
  String get paletteClassic => 'Verde clásico';

  @override
  String get paletteClassicDesc => 'Acento verde vivo';

  @override
  String get patientsLoadFailed => 'No se pudieron cargar los pacientes.';

  @override
  String get noPatientsYet =>
      'Aún no hay pacientes.\nAñádelos arriba a la derecha.';

  @override
  String get noPatientsMatch => 'Ningún paciente coincide con la búsqueda.';

  @override
  String get newProcedure => 'Nuevo tratamiento';

  @override
  String get procedureSaved => 'Tratamiento guardado';

  @override
  String get plannedForNextSession => 'Planificado para la próxima sesión';

  @override
  String get voiceNoteSaved => 'Nota de voz guardada';

  @override
  String get editPatientTitle => 'Editar paciente';

  @override
  String get deletePatientTitle => 'Eliminar paciente';

  @override
  String deletePatientConfirm(String name) {
    return '¿Eliminar a $name y todos sus registros?';
  }

  @override
  String patientDeleteFailed(String error) {
    return 'No se pudo eliminar el paciente: $error';
  }

  @override
  String get sharePdfTitle => 'Compartir historial de tratamientos';

  @override
  String get sharePdfWarning =>
      'El PDF contiene datos de salud del paciente. Envíalo solo al propio paciente o, con su consentimiento, a personas autorizadas.';

  @override
  String get createPdf => 'Crear PDF';

  @override
  String followUpAdded(String title) {
    return 'Seguimiento añadido: $title';
  }

  @override
  String get markedAsDone => 'Tratamiento marcado como realizado';

  @override
  String completeFailed(String error) {
    return 'No se pudo completar: $error';
  }

  @override
  String followUpCompleteFailed(String error) {
    return 'No se pudo completar el seguimiento: $error';
  }

  @override
  String get deleteFollowUpTitle => 'Eliminar seguimiento';

  @override
  String deleteItemConfirm(String name) {
    return '¿Eliminar «$name»?';
  }

  @override
  String followUpDeleteFailed(String error) {
    return 'No se pudo eliminar el seguimiento: $error';
  }

  @override
  String get addFollowUp => 'Añadir seguimiento';

  @override
  String get voiceNote => 'Nota de voz';

  @override
  String get shareAsPdf => 'Compartir como PDF';

  @override
  String plannedProcedures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tratamientos planificados ($count)',
      one: 'Tratamiento planificado',
    );
    return '$_temp0';
  }

  @override
  String get markDone => 'Hecho';

  @override
  String dataLoadFailed(String error) {
    return 'No se pudieron cargar los datos: $error';
  }

  @override
  String get noRecordsYet =>
      'Aún no hay registros.\nAñade una nota de voz o un tratamiento.';

  @override
  String get openFollowUps => 'Seguimientos abiertos';

  @override
  String labReminderOn(String date) {
    return 'Recordatorio de laboratorio: $date';
  }

  @override
  String get complete => 'Completar';

  @override
  String get pendingVoiceNotes => 'Notas de voz pendientes';

  @override
  String get procedureHistory => 'Historial de tratamientos';

  @override
  String get noProceduresYet => 'Aún no hay tratamientos.';

  @override
  String get processedVoiceNotes => 'Notas de voz procesadas';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String procedureCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tratamientos',
      one: '1 tratamiento',
    );
    return '$_temp0';
  }

  @override
  String get manageCreateIntro =>
      'Creas una clínica nueva y pasas a ser su administrador. Tus otras clínicas se conservan; puedes cambiar entre ellas.';

  @override
  String get manageJoinIntro =>
      'Introduce el código de la clínica. Tendrás acceso cuando el administrador lo apruebe.';

  @override
  String clinicCreated(String name, String code) {
    return '$name creada. Código: $code';
  }

  @override
  String get joinRequestSent =>
      'Solicitud enviada. Pendiente de aprobación del administrador.';

  @override
  String approvedName(String name) {
    return '$name: solicitud aprobada';
  }

  @override
  String approveFailed(String error) {
    return 'No se pudo aprobar: $error';
  }

  @override
  String get rejectRequestTitle => 'Rechazar solicitud';

  @override
  String rejectRequestConfirm(String name) {
    return '¿Quieres rechazar la solicitud de $name?';
  }

  @override
  String rejectedName(String name) {
    return '$name: solicitud rechazada';
  }

  @override
  String rejectFailed(String error) {
    return 'No se pudo rechazar: $error';
  }

  @override
  String noPendingRequests(String clinic) {
    return 'No hay solicitudes pendientes para $clinic.';
  }

  @override
  String wantsToJoinAs(String role) {
    return 'Quiere unirse como $role';
  }

  @override
  String get awaitingApprovalTitle => 'Pendiente de aprobación';

  @override
  String get awaitingApprovalBody =>
      'Tu solicitud está pendiente de aprobación por el administrador de la clínica. Cuando se apruebe, podrás continuar desde aquí.';

  @override
  String get refreshStatus => 'Actualizar estado';

  @override
  String get createOrJoinOtherClinic => 'Crear / unirse a otra clínica';

  @override
  String get cannotChangeOwnAdmin =>
      'No puedes cambiar tu propio rol de administrador';

  @override
  String roleFor(String name) {
    return 'Rol: $name';
  }

  @override
  String roleUpdateFailed(String error) {
    return 'No se pudo cambiar el rol: $error';
  }

  @override
  String get cannotRemoveOwnAdmin =>
      'No puedes quitar tu cuenta de administrador desde aquí';

  @override
  String get removeMemberTitle => 'Quitar miembro';

  @override
  String removeMemberConfirm(String name) {
    return '¿Quitar a $name de la clínica?';
  }

  @override
  String removeFailed(String error) {
    return 'No se pudo quitar: $error';
  }

  @override
  String get clinicMembersTitle => 'Miembros de la clínica';

  @override
  String memberYou(String name) {
    return '$name (tú)';
  }

  @override
  String get changeRole => 'Cambiar rol';

  @override
  String get scopeTooth => 'Diente';

  @override
  String get scopeUpperJaw => 'Maxilar superior';

  @override
  String get scopeLowerJaw => 'Maxilar inferior';

  @override
  String get scopeFullMouth => 'Boca completa';

  @override
  String scopeToothWithNumber(String teeth) {
    return 'Diente: $teeth';
  }

  @override
  String get fieldScope => 'Zona';

  @override
  String get fieldTooth => 'Diente';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldNote => 'Nota';

  @override
  String get fieldCanalLength => 'Longitud del conducto';

  @override
  String get fieldFile => 'Lima';

  @override
  String get fieldMedicament => 'Medicación';

  @override
  String get fieldDate => 'Fecha';

  @override
  String photosAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos añadidas',
      one: '1 foto añadida',
    );
    return '$_temp0';
  }

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos eliminadas',
      one: '1 foto eliminada',
    );
    return '$_temp0';
  }

  @override
  String get canalMain => 'Principal';

  @override
  String get handFile => 'Lima manual';

  @override
  String get noMedicament => 'Sin medicación';

  @override
  String get errNoteConflict =>
      'Otra persona editó este tratamiento mientras tanto. Actualiza la lista e inténtalo de nuevo.';

  @override
  String get errNoClinicSelected =>
      'No hay ninguna clínica seleccionada: inicia sesión primero.';

  @override
  String get errNoPermissionDeletePatient =>
      'No tienes permiso para eliminar este paciente';

  @override
  String get errNoPermissionDeleteNote =>
      'No tienes permiso para eliminar este tratamiento';

  @override
  String labFollowUpTitle(String title) {
    return 'Laboratorio: $title';
  }

  @override
  String labExpectedReturnOn(String date) {
    return 'Regreso del laboratorio previsto: $date';
  }

  @override
  String labExpectedReturnFor(String date, String name) {
    return 'Regreso del laboratorio previsto: $date · $name';
  }

  @override
  String get savingEllipsis => 'Guardando…';

  @override
  String get procedureDate => 'Fecha del tratamiento';

  @override
  String get select => 'Seleccionar';

  @override
  String get expectedLabReturn => 'Regreso del laboratorio previsto';

  @override
  String get followUpDate => 'Fecha de control';

  @override
  String get errSelectOrTypeProcedure =>
      'Selecciona un tratamiento o escribe un título';

  @override
  String get errSelectScope => 'Selecciona una zona';

  @override
  String get errSelectTooth => 'Selecciona al menos un diente';

  @override
  String get errSelectLabDate =>
      'Selecciona la fecha prevista de regreso del laboratorio';

  @override
  String get errSelectFollowUpDate => 'Selecciona la fecha de control';

  @override
  String get errFollowUpNoteRequired => 'Escribe una nota de seguimiento';

  @override
  String get uploadingPhotos => 'Subiendo fotos a la nube…';

  @override
  String get savingProcedure => 'Guardando tratamiento…';

  @override
  String uploadingPhotoProgress(int current, int total) {
    return 'Subiendo foto ($current/$total)…';
  }

  @override
  String saveFailed(String error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String get creatingLabReminder => 'Creando recordatorio de laboratorio…';

  @override
  String get creatingFollowUpReminder => 'Creando recordatorio de control…';

  @override
  String followUpTitle(String title) {
    return 'Control: $title';
  }

  @override
  String get reminderKindLab => 'laboratorio';

  @override
  String get reminderKindFollowUp => 'control';

  @override
  String reminderCreateFailed(String kinds) {
    return 'Tratamiento guardado, pero no se pudieron crear estos recordatorios: $kinds. Añádelos desde la pantalla de Seguimientos.';
  }

  @override
  String get planForNextSession => 'Planificar para la próxima sesión';

  @override
  String saveTeethCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Guardar $count dientes',
      one: 'Guardar 1 diente',
    );
    return '$_temp0';
  }

  @override
  String get pastRecordHint => 'Registro anterior (traspasado del cuaderno)';

  @override
  String get change => 'Cambiar';

  @override
  String get procedureSection => 'Tratamiento';

  @override
  String get procedureSectionHint =>
      'Selecciona al menos un tratamiento o escribe un título';

  @override
  String get procedureTitleLabel => 'Título del tratamiento';

  @override
  String get noteOptionalLabel => 'Nota (opcional)';

  @override
  String get noteHint => 'Escribe aquí si es necesario…';

  @override
  String get addFollowUpSubtitle =>
      'Fecha de control tras el tratamiento y recordatorio';

  @override
  String get followUpNoteLabel => 'Nota de seguimiento';

  @override
  String get followUpNoteHint => 'p. ej. Percusión y control radiográfico';

  @override
  String get presetOneWeek => '1 semana';

  @override
  String get presetOneMonth => '1 mes';

  @override
  String get presetThreeMonths => '3 meses';

  @override
  String get presetSixMonths => '6 meses';

  @override
  String get pickDate => 'Elegir fecha';

  @override
  String get remindWhenLabel => '¿Cuándo avisar?';

  @override
  String get remindOnDay => 'El día del control';

  @override
  String get remindOneDayBefore => '1 día antes';

  @override
  String get remindThreeDaysBefore => '3 días antes';

  @override
  String get remindOneWeekBefore => '1 semana antes';

  @override
  String followUpSummary(String date, String reminder) {
    return 'Control: $date · Aviso: $reminder';
  }

  @override
  String get scopeToothRequired =>
      'Este tratamiento requiere seleccionar un diente';

  @override
  String get scopeRequired => 'Es obligatorio seleccionar una zona';

  @override
  String get scopeSuitable => 'Zona adecuada para el tratamiento';

  @override
  String get canalSelectToothFirst =>
      'Selecciona primero un diente para los parámetros del conducto. Con varios dientes, cada uno se guarda por separado.';

  @override
  String get canalPerToothTitle => 'Datos del conducto por diente';

  @override
  String get canalPerToothHint =>
      'Toca un diente e introduce sus parámetros. Cada diente se guarda como una nota independiente.';

  @override
  String toothNumber(String tooth) {
    return 'Diente $tooth';
  }

  @override
  String get photoSection => 'Foto';

  @override
  String get photoPrivacyHint =>
      'Que no se vea la cara del paciente. Solo imágenes del tratamiento / intraorales.';

  @override
  String get planningSection => 'Planificación';

  @override
  String get labCountsAsDone =>
      'Si se envió al laboratorio, el tratamiento cuenta como realizado';

  @override
  String get info => 'Información';

  @override
  String get planInfoLabBlocked =>
      'Esta opción no está disponible mientras «Enviado al laboratorio» esté marcado; el tratamiento se considera realizado en esta sesión.';

  @override
  String get planInfo =>
      'El tratamiento se considera no realizado hoy. En la próxima visita, el paciente aparecerá destacado arriba; al marcarlo como «Hecho» se añadirá al historial de tratamientos de ese día.';

  @override
  String get sentToLab => 'Enviado al laboratorio';

  @override
  String get sentToLabInfo =>
      'Márcalo cuando el trabajo se envíe al laboratorio. La lista de seguimientos y una notificación te avisarán 1 día antes de la fecha prevista de regreso. Con esta opción el tratamiento cuenta como realizado y «Planificar para la próxima sesión» se desactiva.';

  @override
  String addExtraCanalForTooth(String tooth) {
    return 'Añadir conducto adicional · Diente $tooth';
  }

  @override
  String get addExtraCanal => 'Añadir conducto adicional';

  @override
  String get extraCanalHint =>
      'Elige un conducto que no esté en la lista habitual o escribe un nombre personalizado.';

  @override
  String get allStandardCanalsAdded =>
      'Ya se añadieron todos los códigos estándar. Usa un nombre personalizado.';

  @override
  String get customCanalName => 'Nombre de conducto personalizado';

  @override
  String get customCanalHint => 'p. ej. MB3, DB2…';

  @override
  String get editProcedureTitle => 'Editar tratamiento';

  @override
  String editVersionHint(int version) {
    return 'v$version → se guarda como nueva versión; la anterior se conserva';
  }

  @override
  String get errTitleRequired => 'El título del tratamiento es obligatorio';

  @override
  String get noChanges => 'Sin cambios';

  @override
  String get saveAsNewVersion => 'Guardar como nueva versión';

  @override
  String get quadrantUpperRight => 'Superior derecho';

  @override
  String get quadrantUpperLeft => 'Superior izquierdo';

  @override
  String get quadrantLowerRight => 'Inferior derecho';

  @override
  String get quadrantLowerLeft => 'Inferior izquierdo';

  @override
  String get toothNumberSection => 'Número de diente';

  @override
  String get clearSelection => 'Borrar selección';

  @override
  String get typeToSelectLabel => 'Escribir para seleccionar (FDI)';

  @override
  String get typeToSelectHint => 'p. ej. 15  o  14-17  o  36,37';

  @override
  String get apply => 'Aplicar';

  @override
  String get toothSelectorHelp =>
      'Tocar: seleccionar · Mantener pulsado: ampliar cuadrante · Deslizar hacia abajo o Aceptar: cerrar';

  @override
  String get jawUpper => 'SUPERIOR';

  @override
  String get jawLower => 'INFERIOR';

  @override
  String get sideRight => 'Derecha';

  @override
  String get sideLeft => 'Izquierda';

  @override
  String get selectTeeth => 'Selecciona dientes';

  @override
  String selectedTeeth(String teeth) {
    return 'Seleccionados: $teeth';
  }

  @override
  String get swipeDownToClose =>
      'También puedes deslizar hacia abajo para cerrar';

  @override
  String canalParamsForTooth(String tooth) {
    return 'Parámetros del conducto · Diente $tooth';
  }

  @override
  String get canalParamsTitle => 'Parámetros de endodoncia';

  @override
  String get canalLengthMm => 'Longitud del conducto (mm)';

  @override
  String get extra => 'Adicional';

  @override
  String get fileSystem => 'Sistema de limas';

  @override
  String get intracanalMedicament => 'Medicación intraconducto';

  @override
  String toothCanalHint(String tooth, String canals) {
    return 'Diente $tooth · habitual: $canals — añade más si es necesario';
  }

  @override
  String get newVersionSaved => 'Nueva versión guardada';

  @override
  String get deleteProcedureTitle => 'Eliminar tratamiento';

  @override
  String get deleteProcedureConfirm =>
      'Esta nota y sus versiones anteriores se eliminarán de forma permanente.';

  @override
  String get procedureDeleted => 'Tratamiento eliminado';

  @override
  String procedureDeleteFailed(String error) {
    return 'No se pudo eliminar el tratamiento: $error';
  }

  @override
  String get labShort => 'Lab.';

  @override
  String labReturnShort(String date) {
    return 'Lab. → $date';
  }

  @override
  String get history => 'Historial';

  @override
  String get share => 'Compartir';

  @override
  String get versionHistory => 'Historial de versiones';

  @override
  String historyLoadFailed(String error) {
    return 'No se pudo cargar el historial: $error';
  }

  @override
  String get noVersionsFound => 'No se encontraron versiones';

  @override
  String get currentVersion => 'Actual';

  @override
  String get oldVersion => 'Versión anterior';

  @override
  String get changesInVersion => 'Cambios en esta versión';

  @override
  String get firstRecord => 'Primer registro';

  @override
  String get micPermissionRequired => 'Se necesita permiso del micrófono';

  @override
  String get micPermissionMissing => 'Sin permiso del micrófono';

  @override
  String get recordingEmpty => 'La grabación está vacía o no se pudo crear';

  @override
  String voiceUploadFailed(String error) {
    return 'No se pudo subir la grabación de voz: $error';
  }

  @override
  String get quickVoiceNote => 'Nota de voz rápida';

  @override
  String get voicePrivacyHint =>
      'El audio es solo para el resumen del tratamiento por parte del doctor o asistente. No se graban conversaciones con el paciente.';

  @override
  String get recordingInProgress => 'Grabando…';

  @override
  String get uploadingVoice => 'Subiendo audio a la nube…';

  @override
  String get voiceStartHint =>
      'Toca el micrófono y habla; luego toca «Terminar y guardar»';

  @override
  String get pleaseWait => 'Espera, por favor…';

  @override
  String get finishAndSave => 'Terminar y guardar';

  @override
  String playFailed(String error) {
    return 'No se pudo reproducir: $error';
  }

  @override
  String get memoMarkedProcessed => 'Nota de voz marcada como procesada';

  @override
  String markFailed(String error) {
    return 'No se pudo marcar: $error';
  }

  @override
  String get deleteVoiceNoteTitle => 'Eliminar nota de voz';

  @override
  String get deleteVoiceNoteConfirm =>
      'Esta nota de voz se eliminará de forma permanente.';

  @override
  String deleteFailed(String error) {
    return 'No se pudo eliminar: $error';
  }

  @override
  String get processedVoiceNote => 'Nota de voz procesada';

  @override
  String get pendingVoiceNote => 'Nota de voz pendiente';

  @override
  String durationLabel(String duration) {
    return 'Duración: $duration';
  }

  @override
  String get stop => 'Detener';

  @override
  String get listen => 'Escuchar';

  @override
  String get convertToNote => 'Convertir en nota';

  @override
  String get audioFileEmpty => 'El archivo de audio está vacío';

  @override
  String photoOpenFailed(String error) {
    return 'No se pudo abrir la foto: $error';
  }

  @override
  String photoCount(int count, int max) {
    return '$count / $max fotos';
  }

  @override
  String get takePhoto => 'Hacer foto';

  @override
  String get fromGallery => 'Desde la galería';

  @override
  String get shareThisPhoto => 'Compartir esta foto';

  @override
  String shareAllPhotos(int count) {
    return 'Compartir todas las fotos ($count)';
  }

  @override
  String get procedurePhoto => 'Foto del tratamiento';

  @override
  String procedurePhotoIndex(int index, int count) {
    return 'Foto del tratamiento $index/$count';
  }

  @override
  String get shareTooltip => 'Compartir (WhatsApp, correo…)';

  @override
  String get photoLoadFailed => 'No se pudo cargar la foto';

  @override
  String preparingPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Preparando $count fotos…',
      one: 'Preparando foto…',
    );
    return '$_temp0';
  }

  @override
  String shareFailed(String error) {
    return 'No se pudo compartir: $error';
  }

  @override
  String completedItem(String title) {
    return 'Completado: $title';
  }

  @override
  String actionFailed(String error) {
    return 'La acción falló: $error';
  }

  @override
  String deletedItem(String title) {
    return 'Eliminado: $title';
  }

  @override
  String patientOpenFailed(String error) {
    return 'No se pudo abrir el paciente: $error';
  }

  @override
  String get noOpenFollowUps => 'No hay seguimientos abiertos.';

  @override
  String get sectionOverdue => 'Atrasados';

  @override
  String get sectionReminderDue => 'Próximos (aviso pendiente)';

  @override
  String get sectionUpcoming => 'Próximos';

  @override
  String get patientFallback => 'Paciente';

  @override
  String reminderOn(String date) {
    return 'Recordatorio: $date';
  }

  @override
  String get goToPatient => 'Ir al paciente';

  @override
  String get errFollowUpTitleRequired =>
      'Escriba un título para el seguimiento';

  @override
  String get followUpWhatLabel => '¿Qué hay que seguir?';

  @override
  String get followUpWhatHint =>
      'p. ej. Control, retirada de puntos, control del dolor…';

  @override
  String get whenLabel => '¿Cuándo?';

  @override
  String notifFollowUpTitle(String name) {
    return 'Seguimiento: $name';
  }

  @override
  String notifCheckupBody(String title, String date) {
    return '$title · Control: $date';
  }

  @override
  String get notifChannelFollowUps => 'Seguimientos';

  @override
  String get notifChannelFollowUpsDesc =>
      'Recordatorios de controles y seguimientos';

  @override
  String get notifChannelClinic => 'Notificaciones de la clínica';

  @override
  String get notifChannelClinicDesc =>
      'Recordatorios de solicitudes, seguimientos y tareas';

  @override
  String get todoAdded => 'Tarea añadida';

  @override
  String get noOpenTodos =>
      'No hay tareas abiertas.\nPulse Añadir para crear una nota de texto o de voz.';

  @override
  String get todosIntro =>
      'Notas generales de la clínica — citas, llamadas pendientes, recordatorios…';

  @override
  String get sectionUndated => 'Sin fecha';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterMine => 'Asignadas a mí';

  @override
  String get filterTodayOverdue => 'Hoy/atrasadas';

  @override
  String get filterCompleted => 'Completadas';

  @override
  String commentAddFailed(String error) {
    return 'No se pudo añadir el comentario: $error';
  }

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get cameraPermissionRequired => 'Se necesita permiso de cámara';

  @override
  String cameraOpenFailed(String error) {
    return 'No se pudo abrir la cámara: $error';
  }

  @override
  String galleryOpenFailed(String error) {
    return 'No se pudo abrir la galería: $error';
  }

  @override
  String imageAddFailed(String error) {
    return 'No se pudo añadir la imagen: $error';
  }

  @override
  String imageOpenFailed(String error) {
    return 'No se pudo abrir la imagen: $error';
  }

  @override
  String get deleteImageTitle => 'Eliminar imagen';

  @override
  String get deleteImageConfirm => '¿Quitar esta imagen de la tarea?';

  @override
  String imageDeleteFailed(String error) {
    return 'No se pudo eliminar la imagen: $error';
  }

  @override
  String get todoDetailTitle => 'Detalles de la tarea';

  @override
  String get refresh => 'Actualizar';

  @override
  String get markAsCompleted => 'Marcar como completada';

  @override
  String get wholeClinic => 'Toda la clínica';

  @override
  String get clinicMemberFallback => 'Miembro de la clínica';

  @override
  String createdByOn(String name, String date) {
    return 'Creada por $name el $date';
  }

  @override
  String get images => 'Imágenes';

  @override
  String get noImages => 'No se han añadido imágenes';

  @override
  String commentsCount(int count) {
    return 'Comentarios ($count)';
  }

  @override
  String get noCommentsYet => 'Aún no hay comentarios';

  @override
  String get addCommentHint => 'Añadir un comentario…';

  @override
  String get noHistory => 'Sin historial';

  @override
  String get eventCreated => 'Tarea creada';

  @override
  String get eventCompleted => 'Tarea completada';

  @override
  String get eventCommentAdded => 'Comentario añadido';

  @override
  String get eventImageAdded => 'Imagen añadida';

  @override
  String get eventImageDeleted => 'Imagen eliminada';

  @override
  String get completedMessage => 'Completado';

  @override
  String get deleteTodoConfirm => '¿Eliminar esta tarea?';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityImportant => 'Importante';

  @override
  String get priorityUrgent => 'Urgente';

  @override
  String get recurrenceNone => 'No se repite';

  @override
  String get recurrenceDaily => 'Cada día';

  @override
  String get recurrenceWeekly => 'Cada semana';

  @override
  String get recurrenceMonthly => 'Cada mes';

  @override
  String get voiceTodo => 'Tarea de voz';

  @override
  String get todoFallback => 'Tarea';

  @override
  String previewPlayFailed(String error) {
    return 'No se pudo reproducir la vista previa: $error';
  }

  @override
  String get taskTime => 'Hora de la tarea';

  @override
  String get errTextOrVoiceRequired => 'Escriba una nota o grabe audio';

  @override
  String get errFinishRecordingFirst => 'Termine primero la grabación';

  @override
  String get addTodo => 'Añadir tarea';

  @override
  String get todoNoteHint =>
      'p. ej. Dar cita mañana al Sr. García, devolver la llamada al paciente…';

  @override
  String get voiceOptional => 'Audio (opcional)';

  @override
  String get finish => 'Terminar';

  @override
  String voiceRecorded(String duration) {
    return 'Audio grabado · $duration';
  }

  @override
  String get reRecord => 'Volver a grabar';

  @override
  String get recordVoice => 'Grabar audio';

  @override
  String get tomorrow => 'Mañana';

  @override
  String targetDate(String date) {
    return 'Objetivo: $date';
  }

  @override
  String get priority => 'Prioridad';

  @override
  String get addTime => 'Añadir hora';

  @override
  String get assignee => 'Responsable';

  @override
  String get patientLinkOptional => 'Paciente vinculado (opcional)';

  @override
  String get noPatientSelected => 'Ningún paciente seleccionado';

  @override
  String get recurrence => 'Repetición';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get remindOnTime => 'A la hora';

  @override
  String get remindOneHourBefore => '1 hora antes';

  @override
  String get errCommentEmpty => 'El comentario no puede estar vacío';

  @override
  String get recurringTask => 'Tarea recurrente';

  @override
  String get errInvalidFilePath => 'Ruta de archivo no válida';

  @override
  String get periodThisWeek => 'Esta semana';

  @override
  String get periodLastWeek => 'Semana pasada';

  @override
  String get periodThisMonth => 'Este mes';

  @override
  String get periodLastMonth => 'Mes pasado';

  @override
  String get reportPeriod => 'Periodo del informe';

  @override
  String comparedWith(String range) {
    return 'Comparación: $range';
  }

  @override
  String get topProcedures => 'Tratamientos más realizados';

  @override
  String get noProceduresInPeriod =>
      'No hay tratamientos registrados en este periodo.';

  @override
  String get byCategory => 'Por categoría';

  @override
  String get dailyActivity => 'Actividad por día';

  @override
  String get followUpStatus => 'Estado de los seguimientos';

  @override
  String get patientsToRecall => 'Pacientes a los que llamar';

  @override
  String daysPlus(int days) {
    return '$days+ días';
  }

  @override
  String get noRecallsDue => 'No hay pacientes con control pendiente.';

  @override
  String recallsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pacientes tienen un control pendiente',
      one: '1 paciente tiene un control pendiente',
    );
    return '$_temp0';
  }

  @override
  String oldRecallsCount(int count) {
    return '+ $count pacientes antiguos (control vencido hace más de 12 meses)';
  }

  @override
  String get openList => 'Abrir lista';

  @override
  String get statProceduresDone => 'Tratamientos realizados';

  @override
  String get statProceduresHint =>
      'Los tratamientos en varios dientes se cuentan por diente';

  @override
  String get statPatientsTreated => 'Pacientes tratados';

  @override
  String get statVisits => 'Visitas de pacientes';

  @override
  String get statVisitsHint =>
      'Las visitas del mismo paciente en días distintos se cuentan por separado';

  @override
  String get statNewPatients => 'Pacientes nuevos';

  @override
  String get statTotalPatients => 'Total de pacientes';

  @override
  String get statPendingPlanned => 'Tratamientos planificados pendientes';

  @override
  String get sameAsPrevious => 'Igual que el periodo anterior';

  @override
  String weekOf(String label) {
    return 'Semana del $label';
  }

  @override
  String busiestDay(String day, String procedures) {
    return 'Día con más actividad: $day ($procedures)';
  }

  @override
  String overdueCount(int count) {
    return '$count atrasados';
  }

  @override
  String get labPending => 'Trabajos pendientes en el laboratorio';

  @override
  String get controlPending => 'Controles pendientes';

  @override
  String get openTasks => 'Tareas abiertas';

  @override
  String completedInPeriod(int lab, int control, int task) {
    return 'Completados en el periodo — laboratorio: $lab, controles: $control, tareas: $task';
  }

  @override
  String stalledHint(int days) {
    return 'Pacientes con tratamientos planificados que no vienen desde hace $days días y no tienen un control futuro.';
  }

  @override
  String get noPatientsToRecall => 'No hay pacientes a los que llamar.';

  @override
  String lastProcedure(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'hace $days días',
      one: 'hace 1 día',
      zero: 'hoy',
    );
    return 'Último tratamiento: $date ($_temp0)';
  }

  @override
  String plannedList(String items) {
    return 'Planificado: $items';
  }

  @override
  String callPhone(String phone) {
    return 'Llamar: $phone';
  }

  @override
  String firstNPatients(int count) {
    return 'Se muestran los primeros $count pacientes.';
  }

  @override
  String get moreAfterLogging =>
      'Aparecerán más a medida que registre los resultados de las llamadas.';

  @override
  String get call => 'Llamar';

  @override
  String get recallResultAppointment => 'Cita dada';

  @override
  String get recallResultUnreachable => 'No localizado';

  @override
  String get recallResultDeclined => 'No desea';

  @override
  String get recallAppointmentHint =>
      'Elija la fecha del control; se crea un seguimiento';

  @override
  String get recallUnreachableHint => 'Vuelve a la lista en 7 días';

  @override
  String get recallDeclinedHint =>
      'No aparece en la lista hasta un nuevo tratamiento';

  @override
  String get openPatientCard => 'Abrir ficha del paciente';

  @override
  String recallLogged(String name, String result) {
    return '$name: guardado como «$result»';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String undoFailed(String error) {
    return 'No se pudo deshacer: $error';
  }

  @override
  String recallDateHelp(String name) {
    return '$name · fecha del control';
  }

  @override
  String get periodicCheckup => 'Control periódico';

  @override
  String checkupReason(String procedure, String date) {
    return 'Motivo del control: $procedure ($date)';
  }

  @override
  String checkupScheduled(String name, String date) {
    return '$name: control programado para el $date';
  }

  @override
  String appointmentSaveFailed(String error) {
    return 'No se pudo guardar la cita: $error';
  }

  @override
  String get recallCurrent => 'Actuales';

  @override
  String get recallOld => 'Pacientes antiguos';

  @override
  String get recallOldHint =>
      'Pacientes cuya fecha de control venció hace más de 12 meses. Se muestran aparte porque hace mucho que no vienen.';

  @override
  String get recallCurrentHint =>
      'Pacientes cuyo plazo de control tras un tratamiento ha vencido. Los plazos se configuran en la pantalla Plantillas de tratamientos. No aparecen los pacientes con cita, tratamiento planificado o seguimiento futuro.';

  @override
  String get noOldRecalls => 'No hay pacientes antiguos pendientes de control.';

  @override
  String checkupDue(String date) {
    return 'Control: $date';
  }

  @override
  String checkupOverdue(String date, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses de retraso',
      one: '1 mes de retraso',
    );
    return 'Control: $date ($_temp0)';
  }

  @override
  String lastCall(String result) {
    return 'Última llamada: $result';
  }

  @override
  String get noMissingDefaults => 'No faltan tratamientos predeterminados';

  @override
  String defaultsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se añadieron $count tratamientos predeterminados',
      one: 'Se añadió 1 tratamiento predeterminado',
    );
    return '$_temp0';
  }

  @override
  String addFailed(String error) {
    return 'No se pudo añadir: $error';
  }

  @override
  String updateFailed(String error) {
    return 'No se pudo actualizar: $error';
  }

  @override
  String deleteTemplateConfirm(String name) {
    return '¿Quitar «$name» de la lista?\nLos registros anteriores de pacientes no se ven afectados.';
  }

  @override
  String get seedMissingTooltip =>
      'Restaurar tratamientos predeterminados que faltan';

  @override
  String get hideInactive => 'Ocultar inactivos';

  @override
  String get showInactive => 'Mostrar inactivos';

  @override
  String get addProcedure => 'Añadir tratamiento';

  @override
  String get templatesIntro =>
      'Lista de tratamientos de la clínica. Aparecen en el formulario de nuevo tratamiento. Los registros anteriores no cambian.';

  @override
  String get templatesEditRestricted =>
      'Solo los médicos o administradores pueden editar.';

  @override
  String get tagCanal => 'Endodoncia';

  @override
  String get tagToothRequired => 'Diente obligatorio';

  @override
  String get tagJawOk => 'Maxilar/boca OK';

  @override
  String get tagLabTracking => 'Seguimiento de laboratorio';

  @override
  String tagCheckupMonths(int months) {
    return 'Control: $months meses';
  }

  @override
  String get tagInactive => 'Inactivo';

  @override
  String get deactivate => 'Desactivar';

  @override
  String get activate => 'Activar';

  @override
  String get noTemplatesYet => 'Aún no hay tratamientos.';

  @override
  String get category => 'Categoría';

  @override
  String get procedureName => 'Nombre del tratamiento';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get canalProcedure => 'Tratamiento de endodoncia';

  @override
  String get canalProcedureHint =>
      'Muestra los campos de longitud de conducto / limas';

  @override
  String get toothRequired => 'Selección de diente obligatoria';

  @override
  String get toothRequiredHint =>
      'Si está desactivado, se puede elegir maxilar superior/inferior o boca completa';

  @override
  String get labTracking => 'Seguimiento de laboratorio';

  @override
  String get labTrackingHint =>
      'Muestra «Enviado al laboratorio» y la fecha de regreso en el formulario';

  @override
  String get periodicCheckupHelper =>
      'Tras este tratamiento el paciente pasa a la lista de revisiones';

  @override
  String get none => 'Ninguno';

  @override
  String monthsAfter(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses después',
      one: '1 mes después',
    );
    return '$_temp0';
  }

  @override
  String get active => 'Activo';

  @override
  String get catDiagnosis => 'Diagnóstico y planificación';

  @override
  String get catTreatment => 'Tratamiento';

  @override
  String get catProsthetics => 'Prótesis';

  @override
  String get catGeneral => 'General';

  @override
  String pdfDocTitle(String name) {
    return 'Historial de tratamiento - $name';
  }

  @override
  String pdfHeader(String name) {
    return '$name · Historial de tratamiento';
  }

  @override
  String get pdfConfidential =>
      'Confidencial: contiene datos personales de categoría especial (datos de salud).';

  @override
  String pdfPage(int page, int total) {
    return 'Página $page / $total';
  }

  @override
  String get pdfSubtitle => 'Historial de tratamiento del paciente';

  @override
  String get pdfRegistered => 'Fecha de alta';

  @override
  String get pdfReportDate => 'Fecha del informe';

  @override
  String pdfPreparedBy(String name) {
    return 'Preparado por: $name';
  }

  @override
  String pdfDoneProcedures(int count) {
    return 'Tratamientos realizados ($count)';
  }

  @override
  String get pdfNoProcedures => 'No hay tratamientos registrados.';

  @override
  String pdfPlannedProcedures(int count) {
    return 'Tratamientos planificados ($count)';
  }

  @override
  String get pdfColAdded => 'Añadido';

  @override
  String get pdfColDetails => 'Detalles';

  @override
  String pdfLabReturn(String date) {
    return 'Laboratorio · regreso $date';
  }

  @override
  String photoCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get preparingPdf => 'Preparando PDF…';

  @override
  String get pdfFilePrefix => 'historial_tratamiento';

  @override
  String pdfCreateFailed(String error) {
    return 'No se pudo crear el PDF: $error';
  }

  @override
  String get pdfTreatmentHistory => 'Historial de tratamiento';

  @override
  String get errRequestNotFound => 'No se encontró la solicitud';

  @override
  String get errRequestAlreadyAnswered => 'Esta solicitud ya fue respondida';

  @override
  String get errAssigneeOtherClinic =>
      'El responsable debe pertenecer a la misma clínica que la tarea';

  @override
  String get errPatientOtherClinic =>
      'El paciente debe pertenecer a la misma clínica que la tarea';

  @override
  String get errNoReportPermission =>
      'No tienes permiso para ver los informes de esta clínica';

  @override
  String get errInvalidDateRange => 'Rango de fechas no válido';

  @override
  String get errNoListPermission =>
      'No tienes permiso para ver esta lista de la clínica';

  @override
  String get errNothingToSave => 'No hay nada que guardar';

  @override
  String get errNoteNotFound => 'No se encontró el registro';

  @override
  String get errNoPermission => 'No tienes permiso para esta acción';

  @override
  String get errOffline => 'Sin conexión a internet. Inténtalo de nuevo.';

  @override
  String get tplTreatmentPlanning => 'Planificación del tratamiento';

  @override
  String get tplInitialExam => 'Primera consulta / Diagnóstico';

  @override
  String get tplCanalStart => 'Endodoncia – inicio';

  @override
  String get tplCanalFinish => 'Endodoncia – finalización';

  @override
  String get tplCanalRetreatment => 'Reendodoncia';

  @override
  String get tplCompositeFilling => 'Obturación de composite';

  @override
  String get tplPulpCapping => 'Recubrimiento pulpar';

  @override
  String get tplExtraction => 'Extracción dental';

  @override
  String get tplComplicatedExtraction => 'Extracción complicada';

  @override
  String get tplSurgicalExtraction => 'Extracción quirúrgica';

  @override
  String get tplAlveolitis => 'Tratamiento de alveolitis (curación)';

  @override
  String get tplCurettage => 'Curetaje';

  @override
  String get tplWhitening => 'Blanqueamiento';

  @override
  String get tplToothPreparation => 'Tallado dental';

  @override
  String get tplImpression => 'Impresión';

  @override
  String get tplFrameworkTryIn => 'Prueba de estructura';

  @override
  String get tplBisqueTryIn => 'Prueba de bizcocho';

  @override
  String get tplTempCementation => 'Cementado provisional';

  @override
  String get tplPermCementation => 'Cementado definitivo';

  @override
  String get tplNightGuardImpression => 'Impresión de férula nocturna';

  @override
  String get tplScaling => 'Tartrectomía (limpieza)';

  @override
  String get tplCheckup => 'Revisión';

  @override
  String get errClinicInfoMissing => 'Faltan los datos de la clínica';
}
