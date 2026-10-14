// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get emailRequired => 'Укажите эл. почту';

  @override
  String get emailInvalid => 'Введите корректный адрес эл. почты';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordMinLength => 'Не менее 6 символов';

  @override
  String get fullNameLabel => 'Имя и фамилия';

  @override
  String get fullNameRequired => 'Укажите имя и фамилию';

  @override
  String get retry => 'Повторить';

  @override
  String get signOut => 'Выйти';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отмена';

  @override
  String get settingsAndAccount => 'Настройки и аккаунт';

  @override
  String linkOpenFailed(String url) {
    return 'Не удалось открыть ссылку: $url';
  }

  @override
  String clinicCodeCopied(String code) {
    return 'Код клиники скопирован: $code';
  }

  @override
  String get userFallback => 'Пользователь';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get roleDoctor => 'Врач';

  @override
  String get roleAssistant => 'Ассистент';

  @override
  String get joinStatusPending => 'Ожидает подтверждения';

  @override
  String get joinStatusApproved => 'Подтверждено';

  @override
  String get joinStatusRejected => 'Отклонено';

  @override
  String get loginSubtitle => 'Вход';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginCreateAccount => 'Создать аккаунт / Присоединиться к клинике';

  @override
  String get loginFailed => 'Не удалось войти';

  @override
  String get clinicRequiredTitle => 'Нужна клиника';

  @override
  String get serverUnreachableTitle => 'Не удалось подключиться к серверу';

  @override
  String get serverUnreachableBody =>
      'Проверьте подключение к интернету и повторите попытку.';

  @override
  String get signupTitle => 'Регистрация';

  @override
  String get createClinic => 'Создать клинику';

  @override
  String get joinClinic => 'Присоединиться к клинике';

  @override
  String get signupCreateIntro =>
      'Вы создаёте новую клинику и становитесь её администратором и врачом. Ассистентов приглашаете по коду клиники.';

  @override
  String get clinicNameLabel => 'Название клиники';

  @override
  String get clinicNameRequired => 'Укажите название клиники';

  @override
  String get alreadyHaveAccount => 'У меня уже есть аккаунт';

  @override
  String get signupJoinIntro =>
      'Отправьте запрос на вступление с кодом клиники, полученным от администратора. Доступ откроется после его подтверждения.';

  @override
  String get clinicCodeLabel => 'Код клиники';

  @override
  String get clinicCodeHint => 'напр. A3K9PX';

  @override
  String get clinicCodeRequired => 'Укажите код';

  @override
  String get myRole => 'Моя роль';

  @override
  String get joinButton => 'Присоединиться';

  @override
  String get resetCodeSent =>
      'Если адрес зарегистрирован, на него отправлен код';

  @override
  String get passwordUpdated => 'Пароль обновлён';

  @override
  String get resetIntroEmail =>
      'Введите адрес эл. почты вашего аккаунта — мы отправим код для сброса пароля.';

  @override
  String get resetIntroCode => 'Введите код из письма и новый пароль.';

  @override
  String get resetCodeLabel => 'Код';

  @override
  String get resetCodeInvalid => 'Введите код из письма';

  @override
  String get newPasswordLabel => 'Новый пароль';

  @override
  String get newPasswordRepeatLabel => 'Новый пароль (ещё раз)';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get updatePasswordButton => 'Обновить пароль';

  @override
  String get sendCodeButton => 'Отправить код';

  @override
  String get resetRequestNewCode => 'Запросить новый код / изменить адрес';

  @override
  String get legalConsentText =>
      'Я ознакомился(-ась) с уведомлением о конфиденциальности, политикой конфиденциальности и условиями использования и обязуюсь обрабатывать данные пациентов только в целях диагностики и лечения в соответствии с законодательством о защите данных.';

  @override
  String get legalConsentRequired => 'Для продолжения необходимо ваше согласие';

  @override
  String get privacyNotice => 'Уведомление о конфиденциальности';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAccountSection => 'Аккаунт';

  @override
  String get settingsLegalSection => 'Правовая информация';

  @override
  String supportEmail(String email) {
    return 'Поддержка: $email';
  }

  @override
  String get languageLabel => 'Язык';

  @override
  String get languageSystem => 'Язык телефона';

  @override
  String get settingsDangerZone => 'Опасная зона';

  @override
  String get deleteMyAccount => 'Удалить мой аккаунт';

  @override
  String get deleteMyAccountSubtitle => 'Аккаунт будет удалён безвозвратно';

  @override
  String accountInfoFailed(String error) {
    return 'Не удалось получить данные аккаунта: $error';
  }

  @override
  String get transferAdminTitle => 'Сначала передайте права администратора';

  @override
  String transferAdminBody(String clinics) {
    return 'Вы единственный администратор этих клиник, в которых есть другие участники:\n\n$clinics\n\nНазначьте администратором другого участника на экране «Участники» и повторите попытку.';
  }

  @override
  String get accountDeleted => 'Аккаунт удалён';

  @override
  String accountDeleteFailed(String error) {
    return 'Не удалось удалить аккаунт: $error';
  }

  @override
  String serverError(int status) {
    return 'Ошибка сервера ($status)';
  }

  @override
  String get deleteAccountTitle => 'Удалить аккаунт навсегда';

  @override
  String get deleteAccountWarning =>
      'Ваш аккаунт и данные для входа будут удалены. Это действие нельзя отменить.';

  @override
  String get deleteAccountClinicsWarning =>
      'Вы единственный участник клиник ниже. Они будут удалены вместе со всеми картами пациентов, процедурами, фотографиями и аудиозаписями:';

  @override
  String get deleteAccountMembershipOnly =>
      'Записи в клиниках, где вы состоите, останутся в клинике; прекратится только ваше участие.';

  @override
  String deleteAccountTypeToConfirm(String word) {
    return 'Для подтверждения введите «$word»:';
  }

  @override
  String get deleteAccountConfirmWord => 'УДАЛИТЬ';

  @override
  String get deleteAccountButton => 'Удалить аккаунт';

  @override
  String get errInvalidCredentials => 'Неверная эл. почта или пароль';

  @override
  String get errAlreadyRegistered =>
      'Этот адрес уже зарегистрирован. Войдите в аккаунт.';

  @override
  String get errPasswordTooShort =>
      'Пароль должен содержать не менее 6 символов';

  @override
  String get errTooManyAttempts =>
      'Слишком много попыток. Подождите немного и повторите.';

  @override
  String get errAlreadyMember => 'Вы уже состоите в этой клинике';

  @override
  String get errClinicCodeNotFound => 'Код клиники не найден';

  @override
  String get errOnlyAdminCanApprove =>
      'Подтвердить может только администратор клиники';

  @override
  String get errResetCodeInvalid =>
      'Код неверный или устарел. Запросите новый код.';

  @override
  String get errSamePassword => 'Новый пароль должен отличаться от старого';

  @override
  String get errSignupIncomplete =>
      'Не удалось завершить регистрацию. Проверьте подтверждение эл. почты.';

  @override
  String get errSessionRequired => 'Войдите в аккаунт';

  @override
  String get errClinicCreateFailed => 'Не удалось создать клинику';

  @override
  String get errRoleInvalid => 'Роль должна быть «врач» или «ассистент»';

  @override
  String get errJoinRequestFailed => 'Не удалось создать запрос на вступление';

  @override
  String get errNotMember => 'Вы не состоите в этой клинике';

  @override
  String get add => 'Добавить';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get close => 'Закрыть';

  @override
  String get view => 'Открыть';

  @override
  String get copy => 'Копировать';

  @override
  String get approve => 'Подтвердить';

  @override
  String get reject => 'Отклонить';

  @override
  String get remove => 'Исключить';

  @override
  String get phoneLabel => 'Телефон';

  @override
  String get phoneOptionalLabel => 'Телефон (необязательно)';

  @override
  String get noPhone => 'Нет телефона';

  @override
  String loadFailed(String error) {
    return 'Не удалось загрузить: $error';
  }

  @override
  String get clinicFallback => 'Клиника';

  @override
  String get recalls => 'Плановые осмотры';

  @override
  String get todos => 'Задачи';

  @override
  String get followUps => 'Напоминания';

  @override
  String get reports => 'Отчёты';

  @override
  String get clinics => 'Клиники';

  @override
  String get newPatient => 'Новый пациент';

  @override
  String get addPatient => 'Добавить пациента';

  @override
  String get patientAdded => 'Пациент добавлен';

  @override
  String patientAddFailed(String error) {
    return 'Не удалось добавить пациента: $error';
  }

  @override
  String get signOutTitle => 'Выход';

  @override
  String get signOutConfirm => 'Выйти из аккаунта?';

  @override
  String get myClinics => 'Мои клиники';

  @override
  String get copyCode => 'Копировать код';

  @override
  String get activeClinicCode => 'Код текущей клиники';

  @override
  String get clinicCodeShareHint =>
      'Поделитесь кодом: присоединившийся ждёт вашего подтверждения и не становится участником сразу.';

  @override
  String get joinRequests => 'Запросы на вступление';

  @override
  String joinRequestsCount(int count) {
    return 'Запросы на вступление ($count)';
  }

  @override
  String get members => 'Участники';

  @override
  String get appearance => 'Оформление';

  @override
  String get treatmentTemplates => 'Шаблоны процедур';

  @override
  String get addOrJoinClinic => 'Добавить другую клинику / присоединиться';

  @override
  String followUpsDue(int count) {
    return 'Напоминаний к выполнению: $count';
  }

  @override
  String get followUpsOffline =>
      'Нет подключения к интернету или сервер недоступен. Не удалось загрузить напоминания.';

  @override
  String followUpsLoadFailed(String error) {
    return 'Не удалось загрузить напоминания: $error';
  }

  @override
  String get searchPatientsHint => 'Поиск пациентов (имя или телефон)…';

  @override
  String get sortByName => 'А–Я';

  @override
  String get sortByLastVisit => 'Последняя процедура';

  @override
  String get selectPatientHint =>
      'Выберите пациента, чтобы увидеть подробности';

  @override
  String get themeLabel => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get colorPalette => 'Цветовая палитра';

  @override
  String get paletteClinic => 'Клинический синий';

  @override
  String get paletteClinicDesc => 'Спокойный серо-синий';

  @override
  String get paletteOcean => 'Океан';

  @override
  String get paletteOceanDesc => 'Глубокий бирюзовый, свежий и лёгкий';

  @override
  String get paletteSage => 'Шалфей';

  @override
  String get paletteSageDesc => 'Приглушённый зелёный, мягкий медицинский';

  @override
  String get paletteGraphite => 'Графит';

  @override
  String get paletteGraphiteDesc =>
      'Нейтральный графит с ледяно-голубым акцентом';

  @override
  String get paletteClassic => 'Классический зелёный';

  @override
  String get paletteClassicDesc => 'Яркий зелёный акцент';

  @override
  String get patientsLoadFailed => 'Не удалось загрузить пациентов.';

  @override
  String get noPatientsYet =>
      'Пациентов пока нет.\nДобавьте их кнопкой справа вверху.';

  @override
  String get noPatientsMatch => 'По вашему запросу пациенты не найдены.';

  @override
  String get newProcedure => 'Новая процедура';

  @override
  String get procedureSaved => 'Процедура сохранена';

  @override
  String get plannedForNextSession => 'Запланировано на следующий приём';

  @override
  String get voiceNoteSaved => 'Голосовая заметка сохранена';

  @override
  String get editPatientTitle => 'Изменить данные пациента';

  @override
  String get deletePatientTitle => 'Удалить пациента';

  @override
  String deletePatientConfirm(String name) {
    return 'Удалить $name и все связанные записи?';
  }

  @override
  String patientDeleteFailed(String error) {
    return 'Не удалось удалить пациента: $error';
  }

  @override
  String get sharePdfTitle => 'Поделиться историей лечения';

  @override
  String get sharePdfWarning =>
      'PDF содержит медицинские данные пациента. Отправляйте его только самому пациенту или, с его согласия, уполномоченным лицам.';

  @override
  String get createPdf => 'Создать PDF';

  @override
  String followUpAdded(String title) {
    return 'Напоминание добавлено: $title';
  }

  @override
  String get markedAsDone => 'Процедура отмечена как выполненная';

  @override
  String completeFailed(String error) {
    return 'Не удалось завершить: $error';
  }

  @override
  String followUpCompleteFailed(String error) {
    return 'Не удалось завершить напоминание: $error';
  }

  @override
  String get deleteFollowUpTitle => 'Удалить напоминание';

  @override
  String deleteItemConfirm(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String followUpDeleteFailed(String error) {
    return 'Не удалось удалить напоминание: $error';
  }

  @override
  String get addFollowUp => 'Добавить напоминание';

  @override
  String get voiceNote => 'Голосовая заметка';

  @override
  String get shareAsPdf => 'Поделиться в PDF';

  @override
  String plannedProcedures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Запланированные процедуры ($count)',
      one: 'Запланированная процедура',
    );
    return '$_temp0';
  }

  @override
  String get markDone => 'Выполнено';

  @override
  String dataLoadFailed(String error) {
    return 'Не удалось загрузить данные: $error';
  }

  @override
  String get noRecordsYet =>
      'Записей пока нет.\nДобавьте голосовую заметку или процедуру.';

  @override
  String get openFollowUps => 'Открытые напоминания';

  @override
  String labReminderOn(String date) {
    return 'Напоминание о лаборатории: $date';
  }

  @override
  String get complete => 'Завершить';

  @override
  String get pendingVoiceNotes => 'Необработанные голосовые заметки';

  @override
  String get procedureHistory => 'История процедур';

  @override
  String get noProceduresYet => 'Процедур пока нет.';

  @override
  String get processedVoiceNotes => 'Обработанные голосовые заметки';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String procedureCount(int count) {
    return 'Процедур: $count';
  }

  @override
  String get manageCreateIntro =>
      'Вы создаёте новую клинику и становитесь её администратором. Другие ваши клиники сохраняются — между ними можно переключаться.';

  @override
  String get manageJoinIntro =>
      'Введите код клиники. Доступ откроется после подтверждения администратором.';

  @override
  String clinicCreated(String name, String code) {
    return 'Клиника $name создана. Код: $code';
  }

  @override
  String get joinRequestSent =>
      'Запрос отправлен. Ожидается подтверждение администратора.';

  @override
  String approvedName(String name) {
    return '$name: подтверждено';
  }

  @override
  String approveFailed(String error) {
    return 'Не удалось подтвердить: $error';
  }

  @override
  String get rejectRequestTitle => 'Отклонить запрос';

  @override
  String rejectRequestConfirm(String name) {
    return 'Отклонить запрос от $name?';
  }

  @override
  String rejectedName(String name) {
    return '$name: отклонено';
  }

  @override
  String rejectFailed(String error) {
    return 'Не удалось отклонить: $error';
  }

  @override
  String noPendingRequests(String clinic) {
    return 'Нет ожидающих запросов для «$clinic».';
  }

  @override
  String wantsToJoinAs(String role) {
    return 'Хочет присоединиться. Роль: $role';
  }

  @override
  String get awaitingApprovalTitle => 'Ожидание подтверждения';

  @override
  String get awaitingApprovalBody =>
      'Ваш запрос ожидает подтверждения администратора клиники. После подтверждения вы сможете продолжить отсюда.';

  @override
  String get refreshStatus => 'Обновить статус';

  @override
  String get createOrJoinOtherClinic =>
      'Создать другую клинику / присоединиться';

  @override
  String get cannotChangeOwnAdmin =>
      'Нельзя изменить собственную роль администратора';

  @override
  String roleFor(String name) {
    return 'Роль: $name';
  }

  @override
  String roleUpdateFailed(String error) {
    return 'Не удалось изменить роль: $error';
  }

  @override
  String get cannotRemoveOwnAdmin =>
      'Здесь нельзя исключить аккаунт администратора';

  @override
  String get removeMemberTitle => 'Исключить участника';

  @override
  String removeMemberConfirm(String name) {
    return 'Исключить $name из клиники?';
  }

  @override
  String removeFailed(String error) {
    return 'Не удалось исключить: $error';
  }

  @override
  String get clinicMembersTitle => 'Участники клиники';

  @override
  String memberYou(String name) {
    return '$name (вы)';
  }

  @override
  String get changeRole => 'Изменить роль';
}
