import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/acts/presentation/acts_list_screen.dart';
import '../../features/acts/presentation/section_detail_screen.dart';
import '../../features/acts/presentation/sections_list_screen.dart';
import '../../features/ai_chat/presentation/ai_chat_screen.dart';
import '../../features/bookmarks/presentation/bookmarks_screen.dart';
import '../../features/cases/presentation/case_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/main_shell.dart';
import '../../features/notes/presentation/note_detail_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import 'package:flutter/material.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _searchKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _actsKey = GlobalKey<NavigatorState>(debugLabel: 'acts');
final _aiKey = GlobalKey<NavigatorState>(debugLabel: 'ai');
final _bookmarksKey = GlobalKey<NavigatorState>(debugLabel: 'bookmarks');

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    redirect: (context, state) async {
      final loc = state.matchedLocation;
      final publicRoutes = ['/', '/login', '/register', '/onboarding'];
      if (publicRoutes.contains(loc)) return null;

      final authState = authNotifier.valueOrNull;
      final isLoggedIn = authState?.session != null;
      if (!isLoggedIn) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notes',
        builder: (_, __) => const NotesScreen(),
      ),
      GoRoute(
        path: '/notes/:id',
        builder: (_, state) =>
            NoteDetailScreen(noteId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/cases/:caseId',
        builder: (_, state) =>
            CaseDetailScreen(caseId: state.pathParameters['caseId']!),
      ),
      GoRoute(
        path: '/acts/:actId',
        builder: (_, state) =>
            SectionsListScreen(actId: state.pathParameters['actId']!),
        routes: [
          GoRoute(
            path: 'section/:sectionId',
            builder: (_, state) => SectionDetailScreen(
              actId: state.pathParameters['actId']!,
              sectionId: state.pathParameters['sectionId']!,
            ),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _searchKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (_, state) => SearchScreen(
                      initialQuery: state.uri.queryParameters['q'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _actsKey,
            routes: [
              GoRoute(
                path: '/home/acts',
                builder: (_, __) => const ActsListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _aiKey,
            routes: [
              GoRoute(
                path: '/home/ai',
                builder: (_, state) {
                  final extra = state.extra;
                  final initial = extra is String ? extra : null;
                  return AiChatScreen(initialMessage: initial);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _bookmarksKey,
            routes: [
              GoRoute(
                path: '/home/bookmarks',
                builder: (_, __) => const BookmarksScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

Future<String> resolveInitialRoute() async {
  const storage = FlutterSecureStorage();
  final onboarded = await storage.read(key: 'onboarding_complete');
  if (onboarded != 'true') return '/onboarding';
  return '/login';
}
