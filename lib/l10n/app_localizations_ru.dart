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

  @override
  String get scopeTooth => 'Зуб';

  @override
  String get scopeUpperJaw => 'Верхняя челюсть';

  @override
  String get scopeLowerJaw => 'Нижняя челюсть';

  @override
  String get scopeFullMouth => 'Вся полость рта';

  @override
  String scopeToothWithNumber(String teeth) {
    return 'Зуб: $teeth';
  }

  @override
  String get fieldScope => 'Область';

  @override
  String get fieldTooth => 'Зуб';

  @override
  String get fieldTitle => 'Название';

  @override
  String get fieldNote => 'Заметка';

  @override
  String get fieldCanalLength => 'Длина канала';

  @override
  String get fieldFile => 'Файл';

  @override
  String get fieldMedicament => 'Препарат';

  @override
  String get fieldDate => 'Дата';

  @override
  String photosAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count фото',
      one: 'Добавлено 1 фото',
    );
    return '$_temp0';
  }

  @override
  String photosRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалено $count фото',
      one: 'Удалено 1 фото',
    );
    return '$_temp0';
  }

  @override
  String get canalMain => 'Основной';

  @override
  String get handFile => 'Ручной файл';

  @override
  String get noMedicament => 'Без препарата';

  @override
  String get errNoteConflict =>
      'Эту процедуру тем временем изменил другой пользователь. Обновите список и попробуйте снова.';

  @override
  String get errNoClinicSelected => 'Клиника не выбрана — сначала войдите.';

  @override
  String get errNoPermissionDeletePatient =>
      'У вас нет прав на удаление этого пациента';

  @override
  String get errNoPermissionDeleteNote =>
      'У вас нет прав на удаление этой процедуры';

  @override
  String labFollowUpTitle(String title) {
    return 'Лаборатория: $title';
  }

  @override
  String labExpectedReturnOn(String date) {
    return 'Ожидаемый возврат из лаборатории: $date';
  }

  @override
  String labExpectedReturnFor(String date, String name) {
    return 'Ожидаемый возврат из лаборатории: $date · $name';
  }

  @override
  String get savingEllipsis => 'Сохранение…';

  @override
  String get procedureDate => 'Дата процедуры';

  @override
  String get select => 'Выбрать';

  @override
  String get expectedLabReturn => 'Ожидаемый возврат из лаборатории';

  @override
  String get followUpDate => 'Дата контроля';

  @override
  String get errSelectOrTypeProcedure =>
      'Выберите процедуру или введите название';

  @override
  String get errSelectScope => 'Выберите область';

  @override
  String get errSelectTooth => 'Выберите хотя бы один зуб';

  @override
  String get errSelectLabDate =>
      'Выберите ожидаемую дату возврата из лаборатории';

  @override
  String get errSelectFollowUpDate => 'Выберите дату контроля';

  @override
  String get errFollowUpNoteRequired => 'Введите текст напоминания';

  @override
  String get uploadingPhotos => 'Фото загружаются в облако…';

  @override
  String get savingProcedure => 'Процедура сохраняется…';

  @override
  String uploadingPhotoProgress(int current, int total) {
    return 'Загрузка фото ($current/$total)…';
  }

  @override
  String saveFailed(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get creatingLabReminder => 'Создаётся напоминание о лаборатории…';

  @override
  String get creatingFollowUpReminder => 'Создаётся напоминание о контроле…';

  @override
  String followUpTitle(String title) {
    return 'Контроль: $title';
  }

  @override
  String get reminderKindLab => 'лаборатория';

  @override
  String get reminderKindFollowUp => 'контроль';

  @override
  String reminderCreateFailed(String kinds) {
    return 'Процедура сохранена, но не удалось создать напоминания: $kinds. Добавьте их в разделе «Напоминания».';
  }

  @override
  String get planForNextSession => 'Запланировать на следующий визит';

  @override
  String saveTeethCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранить $count зуба',
      many: 'Сохранить $count зубов',
      few: 'Сохранить $count зуба',
      one: 'Сохранить $count зуб',
    );
    return '$_temp0';
  }

  @override
  String get pastRecordHint => 'Прошлая запись (перенос из бумажного журнала)';

  @override
  String get change => 'Изменить';

  @override
  String get procedureSection => 'Процедура';

  @override
  String get procedureSectionHint =>
      'Выберите хотя бы одну процедуру или введите название';

  @override
  String get procedureTitleLabel => 'Название процедуры';

  @override
  String get noteOptionalLabel => 'Заметка (необязательно)';

  @override
  String get noteHint => 'При необходимости напишите здесь…';

  @override
  String get addFollowUpSubtitle =>
      'Дата контроля после процедуры и напоминание';

  @override
  String get followUpNoteLabel => 'Текст напоминания';

  @override
  String get followUpNoteHint =>
      'напр. перкуссия и рентгенологический контроль';

  @override
  String get presetOneWeek => '1 неделя';

  @override
  String get presetOneMonth => '1 месяц';

  @override
  String get presetThreeMonths => '3 месяца';

  @override
  String get presetSixMonths => '6 месяцев';

  @override
  String get pickDate => 'Выбрать дату';

  @override
  String get remindWhenLabel => 'Когда напомнить?';

  @override
  String get remindOnDay => 'В день контроля';

  @override
  String get remindOneDayBefore => 'За 1 день';

  @override
  String get remindThreeDaysBefore => 'За 3 дня';

  @override
  String get remindOneWeekBefore => 'За 1 неделю';

  @override
  String followUpSummary(String date, String reminder) {
    return 'Контроль: $date · Напоминание: $reminder';
  }

  @override
  String get scopeToothRequired => 'Для этой процедуры нужно выбрать зуб';

  @override
  String get scopeRequired => 'Нужно выбрать область';

  @override
  String get scopeSuitable => 'Подходящая область для процедуры';

  @override
  String get canalSelectToothFirst =>
      'Сначала выберите зуб для параметров канала. При нескольких зубах каждый сохраняется отдельно.';

  @override
  String get canalPerToothTitle => 'Данные каналов для каждого зуба';

  @override
  String get canalPerToothHint =>
      'Нажмите на зуб и введите параметры. Каждый зуб сохраняется отдельной записью.';

  @override
  String toothNumber(String tooth) {
    return 'Зуб $tooth';
  }

  @override
  String get photoSection => 'Фото';

  @override
  String get photoPrivacyHint =>
      'Лицо пациента не должно быть видно. Только снимки процедуры / полости рта.';

  @override
  String get planningSection => 'Планирование';

  @override
  String get labCountsAsDone =>
      'Если отправлено в лабораторию, процедура считается выполненной';

  @override
  String get info => 'Информация';

  @override
  String get planInfoLabBlocked =>
      'Эта опция недоступна, пока отмечено «Отправлено в лабораторию»; процедура считается выполненной в этот визит.';

  @override
  String get planInfo =>
      'Процедура считается невыполненной сегодня. При следующем визите пациент будет отмечен вверху; после отметки «Выполнено» она добавится в историю процедур того дня.';

  @override
  String get sentToLab => 'Отправлено в лабораторию';

  @override
  String get sentToLabInfo =>
      'Отметьте, когда работа отправлена в лабораторию. Список напоминаний и уведомление напомнят за 1 день до ожидаемой даты возврата. При этом процедура считается выполненной, а «Запланировать на следующий визит» отключается.';

  @override
  String addExtraCanalForTooth(String tooth) {
    return 'Добавить дополнительный канал · Зуб $tooth';
  }

  @override
  String get addExtraCanal => 'Добавить дополнительный канал';

  @override
  String get extraCanalHint =>
      'Выберите канал, которого нет в типичном списке, или введите своё название.';

  @override
  String get allStandardCanalsAdded =>
      'Все стандартные коды уже добавлены. Используйте своё название.';

  @override
  String get customCanalName => 'Своё название канала';

  @override
  String get customCanalHint => 'напр. MB3, DB2…';

  @override
  String get editProcedureTitle => 'Редактировать процедуру';

  @override
  String editVersionHint(int version) {
    return 'v$version → сохраняется новая версия; старая остаётся';
  }

  @override
  String get errTitleRequired => 'Название процедуры обязательно';

  @override
  String get noChanges => 'Изменений нет';

  @override
  String get saveAsNewVersion => 'Сохранить как новую версию';

  @override
  String get quadrantUpperRight => 'Верхний правый';

  @override
  String get quadrantUpperLeft => 'Верхний левый';

  @override
  String get quadrantLowerRight => 'Нижний правый';

  @override
  String get quadrantLowerLeft => 'Нижний левый';

  @override
  String get toothNumberSection => 'Номер зуба';

  @override
  String get clearSelection => 'Очистить выбор';

  @override
  String get typeToSelectLabel => 'Ввести вручную (FDI)';

  @override
  String get typeToSelectHint => 'напр. 15  или  14-17  или  36,37';

  @override
  String get apply => 'Применить';

  @override
  String get toothSelectorHelp =>
      'Нажатие: выбрать · Долгое нажатие: увеличить квадрант · Свайп вниз или ОК: закрыть';

  @override
  String get jawUpper => 'ВЕРХ';

  @override
  String get jawLower => 'НИЗ';

  @override
  String get sideRight => 'Право';

  @override
  String get sideLeft => 'Лево';

  @override
  String get selectTeeth => 'Выберите зубы';

  @override
  String selectedTeeth(String teeth) {
    return 'Выбрано: $teeth';
  }

  @override
  String get swipeDownToClose => 'Можно также закрыть свайпом вниз';

  @override
  String canalParamsForTooth(String tooth) {
    return 'Параметры канала · Зуб $tooth';
  }

  @override
  String get canalParamsTitle => 'Параметры эндодонтического лечения';

  @override
  String get canalLengthMm => 'Длина канала (мм)';

  @override
  String get extra => 'Доп.';

  @override
  String get fileSystem => 'Система файлов';

  @override
  String get intracanalMedicament => 'Внутриканальный препарат';

  @override
  String toothCanalHint(String tooth, String canals) {
    return 'Зуб $tooth · типично: $canals — при необходимости добавьте другие';
  }

  @override
  String get newVersionSaved => 'Новая версия сохранена';

  @override
  String get deleteProcedureTitle => 'Удалить процедуру';

  @override
  String get deleteProcedureConfirm =>
      'Эта запись и все её предыдущие версии будут удалены безвозвратно.';

  @override
  String get procedureDeleted => 'Процедура удалена';

  @override
  String procedureDeleteFailed(String error) {
    return 'Не удалось удалить процедуру: $error';
  }

  @override
  String get labShort => 'Лаб.';

  @override
  String labReturnShort(String date) {
    return 'Лаб. → $date';
  }

  @override
  String get history => 'История';

  @override
  String get share => 'Поделиться';

  @override
  String get versionHistory => 'История версий';

  @override
  String historyLoadFailed(String error) {
    return 'Не удалось загрузить историю: $error';
  }

  @override
  String get noVersionsFound => 'Версии не найдены';

  @override
  String get currentVersion => 'Текущая';

  @override
  String get oldVersion => 'Старая версия';

  @override
  String get changesInVersion => 'Изменения в этой версии';

  @override
  String get firstRecord => 'Первая запись';

  @override
  String get micPermissionRequired => 'Нужен доступ к микрофону';

  @override
  String get micPermissionMissing => 'Нет доступа к микрофону';

  @override
  String get recordingEmpty => 'Запись пуста или не создана';

  @override
  String voiceUploadFailed(String error) {
    return 'Не удалось загрузить аудиозапись: $error';
  }

  @override
  String get quickVoiceNote => 'Быстрая голосовая заметка';

  @override
  String get voicePrivacyHint =>
      'Запись предназначена только для резюме процедуры врачом или ассистентом. Разговоры с пациентом не записываются.';

  @override
  String get recordingInProgress => 'Идёт запись…';

  @override
  String get uploadingVoice => 'Аудио загружается в облако…';

  @override
  String get voiceStartHint =>
      'Нажмите на микрофон и говорите, затем нажмите «Завершить и сохранить»';

  @override
  String get pleaseWait => 'Пожалуйста, подождите…';

  @override
  String get finishAndSave => 'Завершить и сохранить';

  @override
  String playFailed(String error) {
    return 'Не удалось воспроизвести: $error';
  }

  @override
  String get memoMarkedProcessed =>
      'Голосовая заметка отмечена как обработанная';

  @override
  String markFailed(String error) {
    return 'Не удалось отметить: $error';
  }

  @override
  String get deleteVoiceNoteTitle => 'Удалить голосовую заметку';

  @override
  String get deleteVoiceNoteConfirm =>
      'Эта голосовая заметка будет удалена безвозвратно.';

  @override
  String deleteFailed(String error) {
    return 'Не удалось удалить: $error';
  }

  @override
  String get processedVoiceNote => 'Обработанная голосовая заметка';

  @override
  String get pendingVoiceNote => 'Необработанная голосовая заметка';

  @override
  String durationLabel(String duration) {
    return 'Длительность: $duration';
  }

  @override
  String get stop => 'Стоп';

  @override
  String get listen => 'Прослушать';

  @override
  String get convertToNote => 'Превратить в запись';

  @override
  String get audioFileEmpty => 'Аудиофайл пуст';

  @override
  String photoOpenFailed(String error) {
    return 'Не удалось открыть фото: $error';
  }

  @override
  String photoCount(int count, int max) {
    return '$count / $max фото';
  }

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get fromGallery => 'Из галереи';

  @override
  String get shareThisPhoto => 'Поделиться этим фото';

  @override
  String shareAllPhotos(int count) {
    return 'Поделиться всеми фото ($count)';
  }

  @override
  String get procedurePhoto => 'Фото процедуры';

  @override
  String procedurePhotoIndex(int index, int count) {
    return 'Фото процедуры $index/$count';
  }

  @override
  String get shareTooltip => 'Поделиться (WhatsApp, e-mail…)';

  @override
  String get photoLoadFailed => 'Не удалось загрузить фото';

  @override
  String preparingPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Подготовка фото ($count)…',
      one: 'Подготовка фото…',
    );
    return '$_temp0';
  }

  @override
  String shareFailed(String error) {
    return 'Не удалось поделиться: $error';
  }

  @override
  String completedItem(String title) {
    return 'Выполнено: $title';
  }

  @override
  String actionFailed(String error) {
    return 'Не удалось выполнить действие: $error';
  }

  @override
  String deletedItem(String title) {
    return 'Удалено: $title';
  }

  @override
  String patientOpenFailed(String error) {
    return 'Не удалось открыть пациента: $error';
  }

  @override
  String get noOpenFollowUps => 'Нет открытых напоминаний.';

  @override
  String get sectionOverdue => 'Просрочено';

  @override
  String get sectionReminderDue => 'Скоро (время напоминания)';

  @override
  String get sectionUpcoming => 'Предстоящие';

  @override
  String get patientFallback => 'Пациент';

  @override
  String reminderOn(String date) {
    return 'Напоминание: $date';
  }

  @override
  String get goToPatient => 'К пациенту';

  @override
  String get errFollowUpTitleRequired => 'Введите название напоминания';

  @override
  String get followUpWhatLabel => 'Что нужно проконтролировать?';

  @override
  String get followUpWhatHint => 'напр. Осмотр, снятие швов, контроль боли…';

  @override
  String get whenLabel => 'Когда?';

  @override
  String notifFollowUpTitle(String name) {
    return 'Напоминание: $name';
  }

  @override
  String notifCheckupBody(String title, String date) {
    return '$title · Осмотр: $date';
  }

  @override
  String get notifChannelFollowUps => 'Напоминания';

  @override
  String get notifChannelFollowUpsDesc => 'Напоминания об осмотрах и контролях';

  @override
  String get notifChannelClinic => 'Уведомления клиники';

  @override
  String get notifChannelClinicDesc =>
      'Напоминания о заявках, контролях и задачах';

  @override
  String get todoAdded => 'Задача добавлена';

  @override
  String get noOpenTodos =>
      'Нет открытых задач.\nНажмите «Добавить», чтобы создать текстовую или голосовую заметку.';

  @override
  String get todosIntro =>
      'Общие заметки клиники — записи, обратные звонки, напоминания…';

  @override
  String get sectionUndated => 'Без даты';

  @override
  String get filterAll => 'Все';

  @override
  String get filterMine => 'Назначенные мне';

  @override
  String get filterTodayOverdue => 'Сегодня/просрочено';

  @override
  String get filterCompleted => 'Выполненные';

  @override
  String commentAddFailed(String error) {
    return 'Не удалось добавить комментарий: $error';
  }

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерея';

  @override
  String get cameraPermissionRequired => 'Требуется доступ к камере';

  @override
  String cameraOpenFailed(String error) {
    return 'Не удалось открыть камеру: $error';
  }

  @override
  String galleryOpenFailed(String error) {
    return 'Не удалось открыть галерею: $error';
  }

  @override
  String imageAddFailed(String error) {
    return 'Не удалось добавить изображение: $error';
  }

  @override
  String imageOpenFailed(String error) {
    return 'Не удалось открыть изображение: $error';
  }

  @override
  String get deleteImageTitle => 'Удалить изображение';

  @override
  String get deleteImageConfirm => 'Убрать это изображение из задачи?';

  @override
  String imageDeleteFailed(String error) {
    return 'Не удалось удалить изображение: $error';
  }

  @override
  String get todoDetailTitle => 'Подробности задачи';

  @override
  String get refresh => 'Обновить';

  @override
  String get markAsCompleted => 'Отметить как выполненную';

  @override
  String get wholeClinic => 'Вся клиника';

  @override
  String get clinicMemberFallback => 'Сотрудник клиники';

  @override
  String createdByOn(String name, String date) {
    return 'Создано: $name, $date';
  }

  @override
  String get images => 'Изображения';

  @override
  String get noImages => 'Изображения не добавлены';

  @override
  String commentsCount(int count) {
    return 'Комментарии ($count)';
  }

  @override
  String get noCommentsYet => 'Комментариев пока нет';

  @override
  String get addCommentHint => 'Добавить комментарий…';

  @override
  String get noHistory => 'История пуста';

  @override
  String get eventCreated => 'Задача создана';

  @override
  String get eventCompleted => 'Задача выполнена';

  @override
  String get eventCommentAdded => 'Комментарий добавлен';

  @override
  String get eventImageAdded => 'Изображение добавлено';

  @override
  String get eventImageDeleted => 'Изображение удалено';

  @override
  String get completedMessage => 'Выполнено';

  @override
  String get deleteTodoConfirm => 'Удалить эту задачу?';

  @override
  String get priorityNormal => 'Обычный';

  @override
  String get priorityImportant => 'Важный';

  @override
  String get priorityUrgent => 'Срочный';

  @override
  String get recurrenceNone => 'Не повторяется';

  @override
  String get recurrenceDaily => 'Каждый день';

  @override
  String get recurrenceWeekly => 'Каждую неделю';

  @override
  String get recurrenceMonthly => 'Каждый месяц';

  @override
  String get voiceTodo => 'Голосовая задача';

  @override
  String get todoFallback => 'Задача';

  @override
  String previewPlayFailed(String error) {
    return 'Не удалось воспроизвести: $error';
  }

  @override
  String get taskTime => 'Время задачи';

  @override
  String get errTextOrVoiceRequired => 'Напишите заметку или запишите аудио';

  @override
  String get errFinishRecordingFirst => 'Сначала завершите запись';

  @override
  String get addTodo => 'Добавить задачу';

  @override
  String get todoNoteHint =>
      'напр. Записать Ивана Петровича на завтра, перезвонить пациенту…';

  @override
  String get voiceOptional => 'Аудио (необязательно)';

  @override
  String get finish => 'Завершить';

  @override
  String voiceRecorded(String duration) {
    return 'Аудио записано · $duration';
  }

  @override
  String get reRecord => 'Записать заново';

  @override
  String get recordVoice => 'Записать аудио';

  @override
  String get tomorrow => 'Завтра';

  @override
  String targetDate(String date) {
    return 'Срок: $date';
  }

  @override
  String get priority => 'Приоритет';

  @override
  String get addTime => 'Добавить время';

  @override
  String get assignee => 'Ответственный';

  @override
  String get patientLinkOptional => 'Связанный пациент (необязательно)';

  @override
  String get noPatientSelected => 'Пациент не выбран';

  @override
  String get recurrence => 'Повтор';

  @override
  String get reminder => 'Напоминание';

  @override
  String get remindOnTime => 'Вовремя';

  @override
  String get remindOneHourBefore => 'За 1 час';

  @override
  String get errCommentEmpty => 'Комментарий не может быть пустым';

  @override
  String get recurringTask => 'Повторяющаяся задача';

  @override
  String get errInvalidFilePath => 'Недопустимый путь к файлу';
}
