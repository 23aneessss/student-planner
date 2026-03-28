════════════════════════════════════════════════════════════════
  PLANORA — Flutter Student Planner · Full Engineering Specification
  Tagline: "Plan. Focus. Progress."
════════════════════════════════════════════════════════════════

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 0. MISSION STATEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Build PLANORA, a production-quality Flutter student planner app
targeting Android & iOS. Architecture is offline-first with
optional JWT-authenticated cloud sync. Every screen must be
pixel-perfect and compile without errors or warnings. No
pseudocode. No placeholders. No TODO comments in shipped code.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. DESIGN SYSTEM — PALETTE & TOKENS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// lib/theme/tokens.dart

/* Raw hex constants */
const Color kCanvas      = Color(0xFFFAFAFF); // near-white surfaces
const Color kLavender    = Color(0xFFC8B3FD); // CTA, primary brand accent
const Color kNavy        = Color(0xFF273469); // mid-section gradient anchor
const Color kCoral       = Color(0xFFEE6C4D); // destructive / highlights
const Color kDark        = Color(0xFF293241); // darkest bg, bottom nav bg
const Color kError       = Color(0xFFEF4444);
const Color kSuccess     = Color(0xFF22C55E);
const Color kWarning     = Color(0xFFF59E0B);

/* Semantic mapping */
colorScheme:
  primary      → kLavender        (buttons, active tabs, selection)
  onPrimary    → kDark            (text ON lavender buttons)
  secondary    → kCoral           (danger actions, badges, streaks)
  onSecondary  → kCanvas
  surface      → kCanvas
  onSurface    → kDark
  background   → kDark            (scaffold bg — gradient applied per-screen)
  error        → kError

/* Gradient — used on every screen as BoxDecoration */
LinearGradient kBgGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.38, 1.0],
  colors: [
    Color(0xFF6B7FD4),  // light periwinkle top
    kNavy,              // mid blue
    kDark,              // dark navy bottom
  ],
);

/* Typography — Inter + Plus Jakarta Sans */
textTheme:
  displayLarge   → PlusJakartaSans 32 w700  (app title "PLANORA")
  titleLarge     → Inter 22 w700            (screen headings)
  titleMedium    → Inter 18 w600            (section titles)
  bodyLarge      → Inter 16 w400            (body copy)
  bodyMedium     → Inter 14 w400            (captions, placeholders)
  labelLarge     → Inter 16 w600            (button labels)

/* Component tokens */
kInputRadius    → BorderRadius.circular(30)  // pill inputs
kCardRadius     → BorderRadius.circular(16)
kButtonRadius   → BorderRadius.circular(30)
kInputBg        → Colors.white.withOpacity(0.92)
kInputHintColor → Color(0xFFB0B8D0)
kElevation      → 0  (flat design, no Material elevation shadows)

/* Spacing scale (multiples of 4) */
xs:4 sm:8 md:16 lg:24 xl:32 xxl:48

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 2. VISUAL LANGUAGE — MANDATORY UI RULES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REFERENCE UI (sign-in / sign-up screens provided as images):
- Background: kBgGradient applied to entire screen via Stack's
  BoxDecoration. DO NOT override per-widget backgrounds.
- Cloud decorations: positioned white SVG/PNG clouds at fixed
  corner coordinates. Load from assets/images/cloud.png.
  Positions: topRight, bottomLeft, bottomRight (each screen may
  vary one corner). Opacity 1.0, size ~180–220 wide.
- Page title: "Sign in to PLANORA !" — "Sign in to" in white
  w700, "PLANORA" in kLavender w700, "!" in white w700.
  Use RichText + TextSpan to achieve the mixed color.
- Inputs: white pill containers, hint text in kInputHintColor,
  contentPadding: horizontal 24, vertical 18. No border visible
  in default state; subtle kLavender border on focus.
- CTA button: kLavender fill, kDark text, pill shape, trailing
  → Icon, width: double.infinity, height: 56.
  On hover/press: scale to 0.97 via GestureDetector + AnimatedScale.
- Secondary link button: "Forget password ?" / "Create yours now !"
  underlined, right-aligned, white color, bodyMedium size.
- Google SSO button: white container, pill shape, Google logo SVG
  (assets/icons/google.svg), "Sign in with Google" in kDark w600.
  Flanked by thin horizontal divider lines with equal flex.
- Footer line: "Don't have an account ? Create yours now !"
  plain text + bold underlined link, centered, white, bottom 40.
- NO bottom nav on auth screens.

SIGN-UP additions (all same rules +):
- Extra fields: Full name, Scholar year (DropdownButtonFormField
  styled as pill), Confirm password.
- Scholar year options: "1st Year", "2nd Year", "3rd Year",
  "4th Year", "5th Year", "Master 1", "Master 2", "PhD".
- Scroll: SingleChildScrollView wrapping the form column so
  keyboard doesn't clip content.

ALL SUBSEQUENT SCREENS inherit:
- kBgGradient backdrop.
- Cloud accent (at least one cloud corner per screen).
- Pill inputs wherever text entry appears.
- kLavender as the primary interactive color.
- kCoral for destructive / priority-high / streak indicators.
- Cards use kCanvas with 0.12 opacity over the gradient
  (Color(0xFFFAFAFF).withOpacity(0.12)) + kCardRadius + no
  shadow (BoxDecoration only).
- AppBar: transparent, no elevation, leading Back icon in white,
  title in white w700.
- Bottom NavigationBar: kDark background, selected item in
  kLavender, unselected in white.withOpacity(0.5).
- Status bar: light icons (SystemChrome.setSystemUIOverlayStyle).

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 3. ARCHITECTURE & PACKAGE STACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Flutter stable channel (null-safety enforced).

pubspec.yaml dependencies (exact, no "any"):
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  hooks_riverpod: ^2.5.1
  flutter_hooks: ^0.20.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  drift: ^2.18.0
  drift_flutter: ^0.2.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.3
  dio: ^5.4.3+1
  flutter_secure_storage: ^9.0.0
  flutter_local_notifications: ^17.1.2
  go_router: ^13.2.1
  intl: ^0.19.0
  table_calendar: ^3.1.2
  fl_chart: ^0.68.0
  lottie: ^3.1.2
  google_sign_in: ^6.2.1
  flutter_svg: ^2.0.10+1
  shared_preferences: ^2.2.3
  uuid: ^4.4.0
  connectivity_plus: ^6.0.3

dev_dependencies:
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10
  mocktail: ^1.0.4
  flutter_test: sdk
  integration_test: sdk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 4. COMPLETE FILE TREE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

planora/
├── assets/
│   ├── images/cloud.png
│   ├── icons/google.svg
│   └── lottie/pomodoro_fire.json
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── theme/
│   │   └── tokens.dart
│   ├── core/
│   │   ├── constants.dart
│   │   ├── extensions.dart        (BuildContext helpers, DateTimeX)
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   └── validators.dart
│   │   └── widgets/
│   │       ├── planora_button.dart        (PrimaryButton, GoogleButton)
│   │       ├── planora_input.dart         (PlanoraTextField, PlanoraDropdown)
│   │       ├── cloud_decoration.dart      (positioned cloud widget)
│   │       ├── gradient_scaffold.dart     (wraps Scaffold + gradient)
│   │       └── empty_state.dart
│   ├── data/
│   │   ├── local/
│   │   │   ├── database.dart              (AppDatabase — Drift)
│   │   │   ├── tables/
│   │   │   │   ├── tasks_table.dart
│   │   │   │   ├── courses_table.dart
│   │   │   │   ├── sessions_table.dart
│   │   │   │   ├── grades_table.dart
│   │   │   │   └── outbox_table.dart
│   │   │   └── daos/
│   │   │       ├── tasks_dao.dart
│   │   │       ├── courses_dao.dart
│   │   │       ├── sessions_dao.dart
│   │   │       ├── grades_dao.dart
│   │   │       └── outbox_dao.dart
│   │   └── remote/
│   │       ├── api_client.dart            (Dio + interceptors + refresh)
│   │       ├── auth_remote.dart
│   │       └── sync_remote.dart
│   ├── domain/
│   │   ├── models/
│   │   │   ├── task.dart                  (Freezed)
│   │   │   ├── course.dart
│   │   │   ├── session.dart
│   │   │   ├── grade.dart
│   │   │   ├── outbox_event.dart
│   │   │   └── user_profile.dart
│   │   └── repositories/
│   │       ├── auth_repository.dart
│   │       ├── tasks_repository.dart
│   │       ├── courses_repository.dart
│   │       ├── sessions_repository.dart
│   │       ├── grades_repository.dart
│   │       └── sync_repository.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── tasks_provider.dart
│   │   ├── courses_provider.dart
│   │   ├── pomodoro_provider.dart
│   │   ├── sync_provider.dart
│   │   ├── stats_provider.dart
│   │   └── notifications_provider.dart
│   ├── router/
│   │   └── router.dart                    (GoRouter config)
│   └── features/
│       ├── onboarding/
│       │   └── onboarding_screen.dart
│       ├── auth/
│       │   ├── sign_in_screen.dart
│       │   └── sign_up_screen.dart
│       ├── home/
│       │   ├── home_screen.dart
│       │   └── widgets/today_summary_card.dart
│       ├── tasks/
│       │   ├── tasks_screen.dart
│       │   ├── task_detail_screen.dart
│       │   └── widgets/
│       │       ├── task_card.dart
│       │       └── task_filter_bar.dart
│       ├── calendar/
│       │   └── calendar_screen.dart
│       ├── pomodoro/
│       │   ├── pomodoro_screen.dart
│       │   └── widgets/pomodoro_ring.dart
│       ├── stats/
│       │   └── stats_screen.dart
│       ├── grades/
│       │   └── grades_screen.dart
│       └── profile/
│           └── profile_screen.dart
├── test/
│   ├── unit/
│   │   ├── task_repository_test.dart
│   │   ├── sync_engine_test.dart
│   │   └── pomodoro_provider_test.dart
│   ├── widget/
│   │   ├── sign_in_screen_test.dart
│   │   └── task_card_test.dart
│   └── mocks/
│       ├── mock_api_client.dart
│       └── mock_database.dart
└── .github/
    └── workflows/
        └── ci.yml

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 5. DATA LAYER — DRIFT SCHEMA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tasks table (tasks):
  id          TEXT  PK (UUIDv4)
  title       TEXT  NOT NULL
  description TEXT  NULLABLE
  courseId    TEXT  NULLABLE  FK→courses
  status      TEXT  NOT NULL  DEFAULT 'todo'
            -- enum: todo | in_progress | done | cancelled
  priority    INTEGER NOT NULL DEFAULT 1
            -- 0=low 1=medium 2=high 3=urgent
  tags        TEXT  NULLABLE  -- JSON array string
  dueDate     INTEGER NULLABLE (millisSinceEpoch)
  remindAt    INTEGER NULLABLE
  recurring   TEXT  NULLABLE  -- JSON: {freq:'weekly',days:[1,3]}
  updatedAt   INTEGER NOT NULL
  deletedAt   INTEGER NULLABLE  -- soft delete / tombstone

Courses table (courses):
  id          TEXT  PK
  name        TEXT  NOT NULL
  colorHex    TEXT  NOT NULL  -- e.g. "#C8B3FD"
  instructor  TEXT  NULLABLE
  schedule    TEXT  NOT NULL  -- JSON: [{day:1,start:"08:00",end:"09:30"}]
  semester    TEXT  NOT NULL
  updatedAt   INTEGER NOT NULL
  deletedAt   INTEGER NULLABLE

Sessions (pomodoro_sessions):
  id          TEXT  PK
  taskId      TEXT  NULLABLE FK→tasks
  courseId    TEXT  NULLABLE FK→courses
  durationSec INTEGER NOT NULL
  startedAt   INTEGER NOT NULL
  endedAt     INTEGER NULLABLE
  notes       TEXT  NULLABLE
  updatedAt   INTEGER NOT NULL
  deletedAt   INTEGER NULLABLE

Grades:
  id          TEXT  PK
  courseId    TEXT  NOT NULL FK→courses
  title       TEXT  NOT NULL
  score       REAL  NOT NULL
  maxScore    REAL  NOT NULL  DEFAULT 100
  weight      REAL  NOT NULL  DEFAULT 1.0
  type        TEXT  NOT NULL  -- exam|quiz|assignment|project
  gradedAt    INTEGER NOT NULL
  updatedAt   INTEGER NOT NULL
  deletedAt   INTEGER NULLABLE

Outbox (outbox_events):
  id          TEXT  PK
  entityType  TEXT  NOT NULL  -- task|course|session|grade
  entityId    TEXT  NOT NULL
  operation   TEXT  NOT NULL  -- create|update|delete
  payload     TEXT  NOT NULL  -- JSON snapshot
  createdAt   INTEGER NOT NULL
  attempts    INTEGER NOT NULL DEFAULT 0

All DAOs must expose:
  watchAll()     → Stream<List<Entity>>   (for Riverpod .watch)
  getById()      → Future<Entity?>
  upsert()       → Future<void>           (INSERT OR REPLACE)
  softDelete()   → Future<void>           (sets deletedAt, updatedAt)
  pendingOutbox()→ Future<List<OutboxEvent>>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 6. SYNC ENGINE — OUTBOX + PULL-SINCE (LWW)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Conflict resolution: Last-Write-Wins by updatedAt (Unix ms).
Deletion: tombstones via deletedAt column.

PUSH flow (SyncRepository.pushOutbox):
  1. Fetch all rows from outbox WHERE attempts < 5.
  2. For each event: POST /api/v1/sync/push {entityType, entityId,
     operation, payload}.
  3. On 2xx: delete from outbox.
  4. On 4xx non-retryable: log + delete (bad client data).
  5. On 5xx / network error: increment attempts, keep row.

PULL flow (SyncRepository.pullSince):
  1. GET /api/v1/sync/pull?since={lastSyncMs}&entities=task,course,
     session,grade
  2. Server returns {items:[{entityType, id, payload, updatedAt,
     deletedAt}]}
  3. For each item:
     a. If deletedAt != null → softDelete locally (skip if local
        updatedAt > server deletedAt).
     b. Else if server.updatedAt > local.updatedAt → upsert.
     c. Store lastSyncMs = max server updatedAt in SharedPreferences.

SyncNotifier (Riverpod AsyncNotifier):
  - Trigger push+pull on: app foreground, Wi-Fi reconnect
    (connectivity_plus), manual pull-to-refresh.
  - Expose SyncState: idle | syncing | error(message) | done.
  - Display a subtle top banner in kLavender when syncing.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 7. AUTH LAYER — JWT + SECURE STORE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Dio client (ApiClient):
  baseUrl: const String.fromEnvironment('API_BASE_URL',
           defaultValue: 'https://api.planora.app')
  connectTimeout: 10s / receiveTimeout: 15s
  Interceptors:
    1. AuthInterceptor: inject Bearer token from SecureStorage on
       every request.
    2. RefreshInterceptor: on 401 → POST /auth/refresh with
       refreshToken → store new accessToken → retry original.
    3. LogInterceptor: only in debug builds.

AuthRepository methods:
  signInWithEmail(email, password) → Future<UserProfile>
  signUpWithEmail(email, password, fullName, scholarYear)
                                   → Future<UserProfile>
  signInWithGoogle()               → Future<UserProfile>
  signOut()                        → Future<void>
  isAuthenticated()                → bool (sync, reads from memory)

AuthNotifier (Riverpod AsyncNotifier<AuthState>):
  AuthState: unauthenticated | loading | authenticated(user) | error
  On build: attempt to restore session from SecureStorage.
  Expose: signIn(), signUp(), signInGoogle(), signOut().

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 8. ROUTING — GOROUTER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Routes:
  /onboarding     → OnboardingScreen   (shown once, persisted in prefs)
  /sign-in        → SignInScreen
  /sign-up        → SignUpScreen
  /               → HomeScreen         (ShellRoute with bottom nav)
  /tasks          → TasksScreen
  /tasks/:id      → TaskDetailScreen
  /calendar       → CalendarScreen
  /pomodoro       → PomodoroScreen
  /stats          → StatsScreen
  /grades         → GradesScreen
  /profile        → ProfileScreen

Redirects:
  - If onboarding not done → /onboarding (all routes)
  - If not authenticated   → /sign-in    (all protected routes)
  - If authenticated       → /           (redirect from /sign-in)

Bottom nav items (in shell):
  Home · Tasks · Calendar · Pomodoro · Stats
  (Grades and Profile accessible from Home cards / Profile icon)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 9. SCREEN SPECIFICATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[A] ONBOARDING SCREEN
  - 3-page PageView with smooth transitions.
  - Each page: full gradient scaffold + cloud + centered Lottie
    animation + title + subtitle.
  - Pages: "Plan your semester" / "Stay focused" / "Track progress"
  - Bottom: page dots in kLavender + "Get started" PrimaryButton.
  - "Sign in" text link for returning users.
  - Store completion in SharedPreferences key "onboarding_done".

[B] SIGN-IN SCREEN  ← MATCH PROVIDED DESIGN EXACTLY
  - GradientScaffold (no AppBar, no bottom nav).
  - Clouds: topRight + bottomLeft + bottomRight.
  - Top 40% empty space for clouds.
  - RichText title "Sign in to PLANORA !" (see §2).
  - PlanoraTextField for email/username.
  - PlanoraTextField for password (obscured, toggle icon).
  - "Forget password ?" right-aligned link.
  - PrimaryButton "Login →".
  - GoogleButton "Sign in with Google" flanked by dividers.
  - Footer "Don't have an account ? Create yours now !" linking /sign-up.
  - Form validation: show inline error text below each field
    (red, bodyMedium) on submit.

[C] SIGN-UP SCREEN  ← MATCH PROVIDED DESIGN EXACTLY
  - Same as sign-in +.
  - 5 fields: email/username, full name, scholar year (dropdown),
    password, confirm password.
  - Scholar year dropdown: pill shape, kInputBg, white chevron icon.
  - PrimaryButton "Sign up →".
  - GoogleButton "Sign up with Google".
  - Footer "Already have an account ? Sign in now !" linking /sign-in.

[D] HOME SCREEN
  - Greeting: "Good morning, {firstName} 👋" in white w700 22.
  - Date subtitle: "Monday, 28 March" in kLavender bodyMedium.
  - "Today's summary" card: tasks due today count, sessions logged,
    streak days — three stat chips in a row (kCanvas 12% opacity).
  - "Upcoming tasks" horizontal scroll list (TaskCard widgets).
  - "Today's schedule" timeline list from courses.schedule.
  - FAB: kLavender, "+" icon, → opens AddTaskBottomSheet.

[E] TASKS SCREEN
  - Top: TaskFilterBar (status chips: All | Todo | In Progress | Done)
    + sort dropdown (due date | priority | course).
  - Search field (PlanoraTextField) with search icon.
  - ListView of TaskCard widgets grouped by due date.
  - TaskCard: course color left border, title, due date chip,
    priority badge (color: low=kCanvas 30% / medium=kLavender /
    high=kCoral / urgent=kError), checkbox to toggle done.
  - Swipe left: delete (kCoral background, trash icon).
  - Swipe right: mark done (kSuccess background, check icon).
  - FAB: add task.

[F] TASK DETAIL SCREEN
  - Full edit form: title, description, course picker, due date/time
    (DatePicker + TimePicker), reminder toggle, priority slider,
    tags chips input, recurring options.
  - Bottom action bar: "Save" PrimaryButton + "Delete" text button
    in kCoral.

[G] CALENDAR SCREEN
  - TableCalendar widget styled:
    selectedDayDecoration: kLavender circle.
    todayDecoration: kCoral circle.
    weekendTextStyle: kCoral.
    defaultTextStyle: white.
    headerStyle: title white, arrows kLavender.
    calendarFormat: toggleable month/week.
  - Below calendar: day's task list (same TaskCard).
  - Long-press day: quick-add task for that date.

[H] POMODORO SCREEN
  - Custom PomodoroRing widget:
    Outer ring: thin white 10% stroke (full circle).
    Progress ring: kLavender stroke, animated with arc sweep.
    Center: countdown timer text "24:58" in white w700 48,
    beneath: session label "Focus Session" in kLavender 14.
  - Below ring: three pill control buttons:
    [Start] kLavender fill  [Pause] kCanvas 20% fill  [Reset] transparent kCoral border.
  - Settings row: Focus / Short break / Long break pill tabs.
  - Session log card: today's sessions count + total minutes.
  - Lottie fire animation (assets/lottie/pomodoro_fire.json) plays
    while timer is running, pauses otherwise.
  - local_notifications: fires "Time's up!" when timer completes
    (works when app is backgrounded).
  - Auto-save each completed session to pomodoro_sessions table.

[I] STATS SCREEN
  - Weekly bar chart (fl_chart BarChart): sessions per day, bars in
    kLavender with kCoral accent for today.
  - Streak card: current streak days in kCoral, max streak in kLavender.
  - Focus time card: total hours this week + percentage vs last week.
  - Tasks completed donut chart: done vs pending (kLavender / kNavy).
  - All charts: transparent background, white labels, no grid lines
    (only horizontal guide lines at 25% opacity).

[J] GRADES SCREEN
  - Course picker tabs (horizontal scroll, pill tabs).
  - Per course: grade list (assignment name, score/100, type badge,
    date). Weighted GPA line at top.
  - Add grade FAB: bottom sheet with course, title, score, max,
    weight, type, date fields.
  - GPA calculation: sum(score/maxScore * weight) / sum(weight) × 20
    (Algerian 20-point scale; make scale configurable via profile).

[K] PROFILE SCREEN
  - Avatar circle (kLavender border, initials fallback).
  - Display name, email, scholar year.
  - Settings sections: Notifications (toggle), Sync (toggle + last
    sync timestamp), Grade scale (20 / 100 / 4.0 GPA), Theme,
    Import/Export.
  - Import: pick CSV or ICS file, parse, bulk upsert.
  - Export: generate tasks.csv + calendar.ics, share via Share sheet.
  - Danger zone: "Delete all data" + "Sign out" buttons in kCoral.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 10. REUSABLE CORE WIDGETS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GradientScaffold({required Widget child, bool showBackButton}):
  Returns Scaffold with Stack: BoxDecoration(gradient:kBgGradient)
  + CloudDecoration (positioned images) + SafeArea(child: child).
  Handles status bar style automatically.

PlanoraTextField({label, hint, controller, validator, obscure,
  prefixIcon, suffixIcon, keyboardType}):
  TextFormField styled with kInputBg fill, kInputRadius,
  no border by default, kLavender focused border 1.5px,
  Inter 16 text, kDark text color.

PlanoraDropdown<T>({label, hint, items, value, onChanged}):
  Same visual as PlanoraTextField. Uses DropdownButtonFormField
  with white dropdown menu background, kDark text.

PrimaryButton({required String label, required VoidCallback? onPressed,
  bool loading, IconData? trailingIcon}):
  FilledButton, kLavender background, kDark text, kButtonRadius,
  height 56, full width. Shows CircularProgressIndicator(kDark)
  when loading=true. Scales to 0.97 on press.

GoogleButton({required VoidCallback? onPressed, required String label}):
  OutlinedButton, white fill, kDark text, kButtonRadius, height 56,
  full width. Leading: SvgPicture.asset('assets/icons/google.svg', 20).

CloudDecoration({CloudPosition position}):
  Positioned(top/right/bottom/left per enum) Image.asset cloud.png,
  width 200, not interactive.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 11. NOTIFICATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Use flutter_local_notifications v17.
  - Request permission on first launch (iOS + Android 13+).
  - Android: create channel id="planora_tasks" name="Task Reminders"
    importance=max.
  - Schedule task reminders: zonedSchedule with TZDateTime at
    task.remindAt. Cancel on task delete/completion.
  - Pomodoro end: show immediately when timer reaches 0.
    notification id based on session uuid hash.
  - Tap payload: deep-link via GoRouter to /tasks/:id.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 12. TEMPLATES SYSTEM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Templates are pre-built task sets stored as JSON assets.
  assets/templates/exam_week.json
  assets/templates/project_sprint.json
  assets/templates/weekly_review.json

Schema: { name, description, tasks:[{title,priority,dueOffset(days),
  tags, recurrence}] }

User can apply a template from Home screen "Templates" card:
  → bottom sheet lists templates → preview → "Apply" bulk-creates
  tasks with dueDate = now + dueOffset days.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 13. IMPORT / EXPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CSV export: id,title,courseId,status,priority,dueDate,tags
ICS export: VEVENT per task (DTSTART=dueDate, SUMMARY=title,
  DESCRIPTION=description, UID=id@planora).

CSV import: parse columns, validate, upsert tasks.
ICS import: parse VEVENT blocks, map to task rows, upsert.

Use file_picker to open files. Share results via Share.shareXFiles.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 14. TESTING REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unit tests (test/unit/):
  task_repository_test.dart:
    - upsert saves to in-memory Drift db.
    - softDelete sets deletedAt, keeps row.
    - watchAll stream emits updated list.
  sync_engine_test.dart:
    - pushOutbox calls POST, deletes on 2xx.
    - pullSince: server newer → local upserted.
    - pullSince: local newer → server ignored (LWW).
    - deletedAt: local row soft-deleted correctly.
  pomodoro_provider_test.dart:
    - timer counts down.
    - pause stops countdown.
    - completion fires notification + saves session.

Widget tests (test/widget/):
  sign_in_screen_test.dart:
    - empty submit shows validation errors.
    - valid credentials triggers authNotifier.signIn().
    - loading state shows PrimaryButton spinner.
  task_card_test.dart:
    - displays title, due date, priority badge.
    - checkbox tap calls tasks provider toggle.
    - swipe left triggers delete confirmation.

Mocks (test/mocks/):
  MockApiClient extends Mock implements ApiClient.
  In-memory Drift: use NativeDatabase.memory().
  Provide mocks via ProviderContainer overrides.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 15. CI — GITHUB ACTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.github/workflows/ci.yml jobs (run on push + PR to main):

  setup:
    - uses: subosito/flutter-action@v2 (channel: stable)
    - run: flutter pub get

  build_runner:
    - needs: setup
    - run: flutter pub run build_runner build --delete-conflicting-outputs

  analyze:
    - needs: build_runner
    - run: flutter analyze --fatal-infos

  test:
    - needs: build_runner
    - run: flutter test --coverage
    - uses: codecov/codecov-action (upload lcov.info)

  build_android:
    - needs: [analyze, test]
    - run: flutter build apk --release
           --dart-define=API_BASE_URL=${{ secrets.API_BASE_URL }}

  build_ios:
    - needs: [analyze, test]
    - runs-on: macos-latest
    - run: flutter build ios --release --no-codesign

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 16. ACCESSIBILITY & PERFORMANCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Accessibility:
  - All interactive elements: Semantics(label:..., button:true).
  - Minimum tap target 48×48 dp.
  - Color contrast: kCanvas on kDark ≥ 4.5:1; white on kNavy ≥ 3:1.
  - Support dynamic text scale up to 1.3× without overflow.
  - ExcludeSemantics on decorative clouds.

Performance:
  - All lists: ListView.builder (never ListView with children:[]).
  - Images: cached_network_image for avatars.
  - Heavy computations (GPA, stats aggregation) in compute().
  - Drift queries: always use .watch() streams, never poll.
  - Riverpod: use .select() to narrow rebuilds to exact fields.
  - Pomodoro timer: use Ticker from TickerProviderStateMixin,
    not Timer.periodic, to respect vsync.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 17. CODE GENERATION & OUTPUT RULES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Every generated file MUST:
  1. Start with the path comment: // lib/path/to/file.dart
  2. Include all necessary imports (no unused imports).
  3. Have all Freezed/JsonSerializable/Drift annotations where needed.
  4. Compile with `flutter analyze` zero warnings.
  5. Be complete — no "..." ellipsis, no TODO, no pseudocode.

Generation order (respect code dependencies):
  1. tokens.dart
  2. Freezed domain models (dart run build_runner before use)
  3. Drift tables + database.dart + DAOs
  4. ApiClient + AuthRepository + SyncRepository
  5. Riverpod providers
  6. router.dart
  7. Core widgets (GradientScaffold, PlanoraTextField, PrimaryButton)
  8. Screens (auth first, then protected)
  9. Tests
  10. CI YAML

Output format for each file:
  FILE: lib/path/to/file.dart
  ─────────────────────────────
  [full file content]

Then a checklist:
  ✅ Compiles   ✅ No pseudocode   ✅ Design tokens applied
  ✅ Tests pass  ✅ Sync engine correct  ✅ UI matches reference

════════════════════════════════════════════════════════════════
  END OF SPEC — Begin generation at tokens.dart
════════════════════════════════════════════════════════════════
