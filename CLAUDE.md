# LexRef — Claude Code Project Guide

## What This Project Is

LexRef is a Flutter mobile app for Indian advocates. It provides offline access to Indian statutory law (IPC, CrPC, CPC, Evidence Act), IndianKanoon case law search, a Groq-powered AI legal assistant, and Supabase-backed auth with bookmark/note sync.

**Target platform:** Android and iOS  
**Flutter:** 3.41.4 · **Dart:** 3.11.1 · **Project root:** `/Users/biju.chellappan/Work/others/legal_app/lexref/`

---

## Running the App

Always pass all four `--dart-define` flags — the app will silently use empty strings for missing keys and Supabase init will fail at runtime.

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=GROQ_API_KEY=gsk_your-groq-key \
  --dart-define=INDIAN_KANOON_TOKEN=your-indiankanoon-token
```

See `.env.example` for key names. Keys are read at compile time via `lib/core/config/env.dart` (`String.fromEnvironment`).

**Build debug APK:**
```bash
flutter build apk --debug
```

**Analyze:**
```bash
flutter analyze
# Expected: 0 errors, 0 warnings (some info-level deprecation hints are OK)
```

---

## Architecture

### State management
`flutter_riverpod` ^2.5.1. Providers are plain `Provider`, `FutureProvider`, `StreamProvider`, and `StateProvider` — **no `@riverpod` codegen is used anywhere in the app currently**. If you add a `@riverpod` annotation, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Navigation
`go_router` ^14.2.7 with a `StatefulShellRoute.indexedStack` for the 4-tab bottom nav. Router is in `lib/core/router/app_router.dart` and exposed as `routerProvider`.

**Tab → route mapping:**
| Tab | Index | Root path |
|-----|-------|-----------|
| Search / Home | 0 | `/home` (HomeScreen), `/home/search` (SearchScreen) |
| Acts | 1 | `/home/acts` |
| AI Chat | 2 | `/home/ai` |
| Bookmarks | 3 | `/home/bookmarks` |

Routes **outside** the shell (accessible from any tab):
- `/acts/:actId` → `SectionsListScreen`
- `/acts/:actId/section/:sectionId` → `SectionDetailScreen`
- `/cases/:caseId` → `CaseDetailScreen`
- `/notes` → `NotesScreen`
- `/notes/:id` → `NoteDetailScreen`
- `/profile` → `ProfileScreen`
- `/login`, `/register`, `/onboarding`, `/` (splash)

Auth redirect in the router: any route not in the public list (`/`, `/login`, `/register`, `/onboarding`) redirects to `/login` when `authStateProvider` has no session.

### Local database
`sqflite` ^2.4.2, singleton at `lib/shared/models/local/database_helper.dart`. Database file: `lexref.db`. All models use hand-written `fromMap`/`toMap` — no codegen.

**Tables:**
| Table | Key columns | Notes |
|-------|-------------|-------|
| `sections` | `id`, `act_id`, `section_no`, `content` | Seeded from JSON assets on first launch per act |
| `acts` | `id`, `short_name`, `year` | One row per act |
| `bookmarks` | `id`, `ref_type`, `ref_id`, `folder`, `is_synced` | `ref_type` = `'section'` or `'case'` |
| `notes` | `id`, `ref_type`, `ref_id`, `content`, `is_synced` | |
| `chat_messages` | `id`, `session_id`, `role`, `content` | Not synced to Supabase |
| `search_history` | `id`, `query`, `filter_type`, `searched_at` | Local only |

### Offline-first sync
`lib/features/bookmarks/data/sync_service.dart` — call `SyncService().syncAll()` on app resume or connectivity restore. It pushes all `is_synced = 0` rows to Supabase and marks them synced.

---

## Directory Structure

```
lib/
├── core/
│   ├── config/env.dart              # String.fromEnvironment wrappers
│   ├── network/
│   │   ├── api_client.dart          # Two Dio singletons: groq + indianKanoon
│   │   └── api_constants.dart       # Base URLs, model names, token limits
│   ├── router/app_router.dart       # GoRouter + routerProvider
│   ├── theme/
│   │   ├── app_colors.dart          # All color constants (light + dark + badge)
│   │   └── app_theme.dart           # lightTheme + darkTheme (Material 3)
│   └── utils/
│       ├── date_utils.dart          # formatDate(), timeAgo(), formatShortDate()
│       └── string_utils.dart        # truncate(), highlightSearchTerm()
│
├── features/
│   ├── acts/
│   │   ├── data/acts_repository.dart       # seedIfNeeded(), getSectionsByAct(), getSection()
│   │   ├── domain/act_models.dart          # ActModel, ChapterModel, SectionModel
│   │   └── presentation/
│   │       ├── acts_list_screen.dart        # 4 act cards grid
│   │       ├── sections_list_screen.dart    # SliverPersistentHeader for sticky chapters
│   │       └── section_detail_screen.dart   # TTS, bookmark, share, notes, AI deep-link
│   │
│   ├── ai_chat/
│   │   ├── data/
│   │   │   ├── chat_repository.dart         # sqflite CRUD for chat_messages
│   │   │   └── groq_service.dart            # POST /chat/completions (llama-3.1-8b-instant)
│   │   └── presentation/ai_chat_screen.dart # Bubbles, typing indicator, offline guard
│   │
│   ├── auth/
│   │   ├── data/auth_repository.dart        # Supabase signIn/signUp/signOut/getProfile
│   │   ├── domain/auth_providers.dart       # authStateProvider, profileProvider, themeModeProvider
│   │   └── presentation/
│   │       ├── splash_screen.dart           # 2s delay → onboarding/login/home
│   │       ├── onboarding_screen.dart       # 3-page PageView, writes secure_storage key
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart         # bar enrollment, state dropdown (32 states)
│   │       └── profile_screen.dart          # dark mode toggle, sign out
│   │
│   ├── bookmarks/
│   │   ├── data/
│   │   │   ├── bookmarks_repository.dart    # CRUD + getBookmarksByFolder() + syncToSupabase()
│   │   │   └── sync_service.dart            # SyncService.syncAll()
│   │   └── presentation/bookmarks_screen.dart  # TabController per folder, long-press options
│   │
│   ├── cases/
│   │   ├── data/cases_repository.dart       # IndianKanoon search + getCase()
│   │   ├── domain/case_models.dart          # CaseResult + stripHtml() + fromIndianKanoon()
│   │   └── presentation/
│   │       ├── cases_list_screen.dart
│   │       └── case_detail_screen.dart      # url_launcher to IndianKanoon
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── main_shell.dart              # StatefulNavigationShell + NavigationBar
│   │       └── home_screen.dart             # Greeting, stat cards, quick-access grid
│   │
│   ├── notes/
│   │   ├── data/notes_repository.dart       # CRUD + getNote(id) + syncToSupabase()
│   │   └── presentation/
│   │       ├── notes_screen.dart
│   │       └── note_detail_screen.dart      # 500ms autosave debounce
│   │
│   └── search/
│       ├── data/search_repository.dart      # searchLocal() LIKE query, searchCases(), history
│       └── presentation/search_screen.dart  # 400ms debounce, filter chips, mixed results
│
├── shared/
│   ├── models/local/
│   │   ├── database_helper.dart             # Singleton, creates all 6 tables + indexes
│   │   ├── local_act.dart
│   │   ├── local_bookmark.dart              # has copyWith(), isSynced
│   │   ├── local_chat_message.dart
│   │   ├── local_note.dart                  # has copyWith(), isSynced
│   │   └── local_section.dart               # relatedSections stored as JSON string
│   ├── providers/
│   │   └── connectivity_provider.dart       # isOnlineProvider (StreamProvider<bool>)
│   └── widgets/
│       ├── act_badge.dart                   # Color-coded chip: IPC/CrPC/CPC/Evidence
│       ├── case_card.dart                   # CaseResult display card
│       ├── court_badge.dart                 # SC/HC/Tribunal color chip
│       ├── empty_state.dart
│       ├── error_state.dart                 # with retry callback
│       ├── loading_shimmer.dart             # CardShimmer widget
│       ├── offline_banner.dart              # Watches isOnlineProvider, yellow warning bar
│       └── section_card.dart               # LocalSection display card
│
assets/
└── data/
    ├── ipc.json           # Indian Penal Code 1860 — 65+ sections with statutory text
    ├── crpc.json          # Code of Criminal Procedure 1973 — 48+ sections
    ├── cpc.json           # Code of Civil Procedure 1908 — 22+ sections + Orders
    └── evidence_act.json  # Indian Evidence Act 1872 — 35+ sections
```

---

## Key Conventions

### API clients
Two Dio instances in `ApiClient` — never create new Dio instances ad hoc:
- `ApiClient.groq` — `Authorization: Bearer <GROQ_API_KEY>`, base `https://api.groq.com/openai/v1`
- `ApiClient.indianKanoon` — `Authorization: Token <INDIAN_KANOON_TOKEN>`, base `https://api.indiankanoon.org`

### Theme colors
Always use `AppColors.*` constants — never hardcode hex values. Key colors:
- `AppColors.primary` = `#1B4FD8` (deep blue)
- `AppColors.background` = `#F4F2ED` (warm off-white)
- Dark mode surfaces: `AppColors.darkBackground` / `AppColors.darkSurface`

### Fonts
- Body text: `GoogleFonts.dmSans()`
- Headings / display: `GoogleFonts.dmSerifDisplay()`
- Monospace (code): `GoogleFonts.dmMono()`

### Section seeding
Acts data is seeded lazily: `ActsRepository().seedIfNeeded(actId)` checks if the `sections` table has rows for that act. If empty, it reads the JSON asset and inserts all sections. Call this before any section query, not at app startup.

### Section provider key
`_sectionProvider` uses a composite `actId__sectionId` string as the family key — the `__` separator is intentional to avoid clashes.

### Sharing
Use `Share.share(text)` from `package:share_plus/share_plus.dart`. Do **not** use `SharePlus.instance.share(ShareParams(...))` — that API is from share_plus v10+ and this project pins v9.

### Connectivity
Always import `isOnlineProvider` from `lib/shared/providers/connectivity_provider.dart` to guard network calls. The `OfflineBanner` widget handles the UI automatically — just add it at the top of any screen that has network features.

### Search history
`SearchRepository().getRecentSearches()` returns `List<String>` (query strings only), not `List<Map>`.

---

## External APIs

### Groq (AI Chat)
- Endpoint: `POST /chat/completions`
- Model: `llama-3.1-8b-instant`
- Max tokens: 1024, Temperature: 0.3, stream: false
- System prompt is defined in `lib/features/ai_chat/data/groq_service.dart`

### IndianKanoon (Case Law)
- Search: `GET /search/?formInput=<query>&pagenum=0`
- Document: `GET /doc/<docId>/`
- Returns HTML-heavy responses — `CaseResult.stripHtml()` is the public static cleaner

### Supabase
- Auth: `Supabase.instance.client.auth` — email/password only
- Profile table: `profiles` with columns `id`, `full_name`, `email`, `bar_enrollment_no`, `state`, `court`
- Bookmarks/notes sync: upsert to `bookmarks` and `notes` tables with `user_id` FK
- Not using real-time subscriptions — one-time fetches only

---

## Known Issues / Gotchas

- **`pdf` and `printing` packages are removed.** They were in the original spec but not implemented. Adding them back will cause a Gradle build failure on machines where Android SDK Platform 30 cannot be downloaded — the `printing` plugin hardcodes `compileSdkVersion 30`. If PDF export is needed later, override `compileSdkVersion` via the root `build.gradle.kts` `subprojects` block using `plugins {}` configuration.

- **`withOpacity()` deprecation.** Flutter 3.41 deprecates `withOpacity()` in favour of `withValues(alpha: ...)`. The 25 `info` hints in `flutter analyze` are all this deprecation. They are non-breaking — fix them when touching those files, don't fix them in bulk.

- **`@riverpod` codegen is not currently wired.** `riverpod_generator` is in `dev_dependencies` but no file uses `@riverpod` yet. All providers are written manually. If you add codegen providers, run `build_runner` and commit the generated `.g.dart` files.

- **No `google_fonts` cache warming.** First launch over slow connection may show fallback fonts briefly. This is acceptable for the current version.

---

## Supabase SQL Schema

Run this in the Supabase SQL editor before first launch:

```sql
-- Profiles (extended user data)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  email TEXT,
  bar_enrollment_no TEXT,
  state TEXT,
  court TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Bookmarks
CREATE TABLE bookmarks (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  ref_type TEXT NOT NULL,
  ref_id TEXT NOT NULL,
  ref_title TEXT NOT NULL,
  ref_act TEXT,
  folder TEXT DEFAULT 'General',
  saved_at TIMESTAMPTZ NOT NULL
);
ALTER TABLE bookmarks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own bookmarks" ON bookmarks USING (auth.uid() = user_id);

-- Notes
CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  ref_type TEXT NOT NULL,
  ref_id TEXT NOT NULL,
  content TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own notes" ON notes USING (auth.uid() = user_id);
```

---

## Testing Checklist

1. **Offline acts:** Disable network → open Acts → IPC → verify section list and full section text load from sqflite.
2. **Search:** Type "murder" → sections 299, 300, 302 appear in results.
3. **AI chat:** With valid `GROQ_API_KEY`, ask "Explain Section 302 IPC" → response renders as markdown.
4. **Bookmarks:** Bookmark IPC S.302 → close app → reopen → bookmark persists. Enable network → verify Supabase row appears.
5. **Notes:** Add note on a section → appears in Notes screen → tap to edit → changes autosave after 500ms.
6. **Dark mode:** Profile → toggle dark mode → all screens switch without hot-restart.
7. **Offline banner:** Disable WiFi → yellow banner appears on search and bookmarks screens; AI input disables.
