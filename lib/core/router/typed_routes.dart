import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Type-safe navigation helpers.
///
/// Use these instead of raw string paths to get IDE completion and
/// compile-time safety for all route parameters.
///
/// Example:
///   context.goSectionDetail(actId: 'ipc', sectionId: 'ipc_302');
///   context.goCaseDetail('123456');
extension TypedRoutes on BuildContext {
  // ── Auth ──────────────────────────────────────────────────────────────────

  void goLogin() => go('/login');
  void goRegister() => go('/register');
  void goOnboarding() => go('/onboarding');

  // ── Shell tabs ────────────────────────────────────────────────────────────

  void goHome() => go('/home');
  void goSearch({String? initialQuery}) => go(
        '/home/search${initialQuery != null ? '?q=${Uri.encodeComponent(initialQuery)}' : ''}',
      );
  void goActsList() => go('/home/acts');
  void goAiChat({String? initialMessage}) =>
      go('/home/ai', extra: initialMessage);
  void goBookmarks() => go('/home/bookmarks');

  // ── Acts ──────────────────────────────────────────────────────────────────

  void goSectionsForAct(String actId) => go('/acts/$actId');
  void pushSectionsForAct(String actId) => push('/acts/$actId');

  void goSectionDetail({required String actId, required String sectionId}) =>
      go('/acts/$actId/section/$sectionId');
  void pushSectionDetail({required String actId, required String sectionId}) =>
      push('/acts/$actId/section/$sectionId');

  // ── Cases ─────────────────────────────────────────────────────────────────

  void pushCasesList() => push('/cases');

  void goCaseDetail(String caseId) => go('/cases/$caseId');
  void pushCaseDetail(String caseId) => push('/cases/$caseId');

  // ── Notes ─────────────────────────────────────────────────────────────────

  void goNotes() => go('/notes');
  void goNoteDetail(String noteId) => go('/notes/$noteId');
  void pushNoteDetail(String noteId) => push('/notes/$noteId');

  // ── Profile ───────────────────────────────────────────────────────────────

  void goProfile() => push('/profile');

  // ── Subscription ──────────────────────────────────────────────────────────

  void pushPaywall({String reason = 'upgrade'}) =>
      push('/paywall', extra: reason);
}
