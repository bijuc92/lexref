# Code Review Skill

Perform a thorough code review of the current branch changes. Compare against `main` using `git diff main...HEAD`. Review every changed file and produce a structured report.

## How to run

```bash
git diff main...HEAD --name-only   # files changed
git diff main...HEAD               # full diff
```

If a PR number is given (e.g. `/code-review 42`), fetch it with `gh pr diff 42` instead.

---

## Review Checklist

### 1. Correctness
- Logic errors, off-by-one, null dereferences, unhandled edge cases
- Async gaps: `mounted` checked after every `await` before using `context` or `ref`
- State mutations that bypass `setState` / Riverpod notifiers

### 2. Error Handling (project pattern)
- Repository methods must return `Result<T>` (`Ok` / `Err`) — never throw to callers
- Use the most specific `Failure` subclass: `NetworkFailure`, `AuthFailure`, `DatabaseFailure`, `NotFoundFailure`, `UnknownFailure`
- Screens consume results with `switch (result) { case Ok ... case Err ... }` — no raw `.data` access without checking
- `DioException` caught and mapped to `NetworkFailure` or `UnknownFailure` — not swallowed silently

### 3. Architecture
- No business logic in widgets — it belongs in repositories or providers
- No raw `Dio` instances created ad hoc — use `ApiClient.groq` or `ApiClient.indianKanoon`
- No hardcoded hex colours — use `AppColors.*` constants
- No raw string navigation paths — use `context.push*` / `context.go*` helpers from `typed_routes.dart`
- New routes added to both `app_router.dart` AND `typed_routes.dart`

### 4. State Management (Riverpod)
- `@riverpod` codegen used for complex/shared providers; plain `FutureProvider`/`StateProvider` acceptable for feature-local providers
- After adding/changing a `@riverpod` annotation: `.g.dart` file must be regenerated and committed
- `keepAlive: true` only when the provider genuinely needs to survive disposal (auth, subscription)
- `ref.read` in event handlers, `ref.watch` in `build` — not swapped

### 5. Local Database (sqflite)
- `fromMap` / `toMap` — snake_case keys, int booleans (`is_synced` as 0/1)
- No `fromJson` on sqflite models (only `fromMap`)
- New tables or columns need a migration in `DatabaseHelper` `_onCreate` / `_onUpgrade`

### 6. Subscription & Gating
- Features behind paywall checked via `isSubscribedProvider` before API calls
- Daily usage counters incremented via `UsageRepository` only after the action succeeds
- `syncAll()` must remain gated — do not remove the Pro check
- `context.pushPaywall(reason: '...')` used for paywall navigation, not raw `push('/paywall')`

### 7. Navigation & Routing
- Shell-tab navigation uses `go*` helpers; detail screens use `push*` helpers
- `/paywall` route is shell-external (accessible from any tab) — keep it outside `StatefulShellRoute`

### 8. Fonts & UI
- Body: `GoogleFonts.dmSans()`
- Headings/display: `GoogleFonts.libreBaskerville()`
- Monospace: `GoogleFonts.dmMono()`
- `withOpacity()` is deprecated — flag any new usages (use `.withValues(alpha: ...)`)

### 9. Security
- No API keys, tokens, or credentials in source code — must come from `Env.*` (`String.fromEnvironment`)
- No SQL string interpolation in sqflite queries — use `whereArgs`
- Supabase RLS policies relied upon for server-side enforcement; do not trust client-side checks alone

### 10. Performance
- Heavy operations (DB reads, network calls) not done in `build()` — use providers or `initState`
- `const` constructors used where possible
- No unnecessary rebuilds: providers scoped tightly, `select` used when only part of state matters

### 11. Sharing
- `Share.share(text)` from `share_plus` v9 — **not** `SharePlus.instance.share(ShareParams(...))`

### 12. Tests (if present)
- New features have corresponding widget or unit tests
- No database mocks — tests hit real sqflite in-memory DB

---

## Output Format

```
## Summary
<1–3 sentence overview of the change>

## Issues

### Critical (must fix before merge)
- [FILE:LINE] Description

### Warnings (should fix)
- [FILE:LINE] Description

### Suggestions (nice to have)
- [FILE:LINE] Description

## Checklist Results
| Area | Status | Notes |
|------|--------|-------|
| Correctness | ✅ / ⚠️ / ❌ | ... |
| Error Handling | ... | ... |
| Architecture | ... | ... |
| State Management | ... | ... |
| Local Database | ... | ... |
| Subscription Gating | ... | ... |
| Security | ... | ... |
| UI conventions | ... | ... |

## Verdict
APPROVE / REQUEST CHANGES / NEEDS DISCUSSION
```

Flag anything surprising or non-obvious even if it is not strictly a bug.
