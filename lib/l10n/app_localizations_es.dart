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
}
