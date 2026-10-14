/** Push metinleri; her cihaza device_tokens.dil dilinde gönderilir. */

export type Lang = 'tr' | 'en' | 'de' | 'ru' | 'fr' | 'es';

type Messages = {
  patientFallback: string;
  labItem: string;
  controlItem: string;
  labSummaryTitle: string;
  controlSummaryTitle: string;
  labSummaryBody: (n: number) => string;
  controlSummaryBody: (n: number) => string;
  todosAssignedTitle: string;
  todosTitle: string;
  todoFallback: string;
  todosSummaryBody: (n: number) => string;
  joinRequestTitle: string;
  joinRequestBody: (name: string) => string;
  someone: string;
};

const messages: Record<Lang, Messages> = {
  tr: {
    patientFallback: 'Hasta',
    labItem: 'Lab takibi',
    controlItem: 'Kontrol',
    labSummaryTitle: 'Günün lab takipleri',
    controlSummaryTitle: 'Günün kontrolleri',
    labSummaryBody: (n) => `${n} lab takibi bugün`,
    controlSummaryBody: (n) => `${n} kontrol bugün`,
    todosAssignedTitle: 'Size atanan görevler',
    todosTitle: 'Günün yapılacakları',
    todoFallback: 'Açık görev',
    todosSummaryBody: (n) => `${n} açık görev zamanı geldi`,
    joinRequestTitle: 'Yeni katılım isteği',
    joinRequestBody: (name) => `${name} kliniğe katılmak istiyor`,
    someone: 'Bir kullanıcı',
  },
  en: {
    patientFallback: 'Patient',
    labItem: 'Lab follow-up',
    controlItem: 'Check-up',
    labSummaryTitle: "Today's lab follow-ups",
    controlSummaryTitle: "Today's check-ups",
    labSummaryBody: (n) => `${n} lab follow-ups today`,
    controlSummaryBody: (n) => `${n} check-ups today`,
    todosAssignedTitle: 'Tasks assigned to you',
    todosTitle: "Today's to-dos",
    todoFallback: 'Open task',
    todosSummaryBody: (n) => `${n} open tasks are due`,
    joinRequestTitle: 'New join request',
    joinRequestBody: (name) => `${name} wants to join the clinic`,
    someone: 'A user',
  },
  de: {
    patientFallback: 'Patient',
    labItem: 'Labor-Wiedervorlage',
    controlItem: 'Kontrolle',
    labSummaryTitle: 'Labor-Wiedervorlagen heute',
    controlSummaryTitle: 'Kontrollen heute',
    labSummaryBody: (n) => `${n} Labor-Wiedervorlagen heute`,
    controlSummaryBody: (n) => `${n} Kontrollen heute`,
    todosAssignedTitle: 'Ihnen zugewiesene Aufgaben',
    todosTitle: 'Aufgaben für heute',
    todoFallback: 'Offene Aufgabe',
    todosSummaryBody: (n) => `${n} offene Aufgaben sind fällig`,
    joinRequestTitle: 'Neue Beitrittsanfrage',
    joinRequestBody: (name) => `${name} möchte der Praxis beitreten`,
    someone: 'Ein Benutzer',
  },
  ru: {
    patientFallback: 'Пациент',
    labItem: 'Лаборатория',
    controlItem: 'Контрольный осмотр',
    labSummaryTitle: 'Лабораторные работы на сегодня',
    controlSummaryTitle: 'Осмотры на сегодня',
    labSummaryBody: (n) => `Лабораторных работ сегодня: ${n}`,
    controlSummaryBody: (n) => `Осмотров сегодня: ${n}`,
    todosAssignedTitle: 'Ваши задачи',
    todosTitle: 'Задачи на сегодня',
    todoFallback: 'Открытая задача',
    todosSummaryBody: (n) => `Пора выполнить задачи: ${n}`,
    joinRequestTitle: 'Новый запрос на вступление',
    joinRequestBody: (name) => `${name} хочет присоединиться к клинике`,
    someone: 'Пользователь',
  },
  fr: {
    patientFallback: 'Patient',
    labItem: 'Suivi labo',
    controlItem: 'Contrôle',
    labSummaryTitle: 'Suivis labo du jour',
    controlSummaryTitle: 'Contrôles du jour',
    labSummaryBody: (n) => `${n} suivis labo aujourd'hui`,
    controlSummaryBody: (n) => `${n} contrôles aujourd'hui`,
    todosAssignedTitle: 'Tâches qui vous sont attribuées',
    todosTitle: 'Tâches du jour',
    todoFallback: 'Tâche ouverte',
    todosSummaryBody: (n) => `${n} tâches ouvertes arrivent à échéance`,
    joinRequestTitle: "Nouvelle demande d'adhésion",
    joinRequestBody: (name) => `${name} souhaite rejoindre le cabinet`,
    someone: 'Un utilisateur',
  },
  es: {
    patientFallback: 'Paciente',
    labItem: 'Seguimiento de laboratorio',
    controlItem: 'Revisión',
    labSummaryTitle: 'Seguimientos de laboratorio de hoy',
    controlSummaryTitle: 'Revisiones de hoy',
    labSummaryBody: (n) => `${n} seguimientos de laboratorio hoy`,
    controlSummaryBody: (n) => `${n} revisiones hoy`,
    todosAssignedTitle: 'Tareas asignadas a ti',
    todosTitle: 'Tareas de hoy',
    todoFallback: 'Tarea abierta',
    todosSummaryBody: (n) => `${n} tareas abiertas han vencido`,
    joinRequestTitle: 'Nueva solicitud para unirse',
    joinRequestBody: (name) => `${name} quiere unirse a la clínica`,
    someone: 'Un usuario',
  },
};

export function toLang(value: unknown): Lang {
  return typeof value === 'string' && value in messages
    ? (value as Lang)
    : 'en';
}

export function t(lang: Lang): Messages {
  return messages[lang];
}

export type LangToken = { token: string; dil: string | null };

/** Token'ları cihaz diline göre gruplar. */
export function groupByLang(rows: LangToken[]): Map<Lang, string[]> {
  const groups = new Map<Lang, string[]>();
  for (const r of rows) {
    const lang = toLang(r.dil);
    groups.set(lang, [...(groups.get(lang) ?? []), r.token]);
  }
  return groups;
}
