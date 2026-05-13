import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/auth_providers.dart';
import 'features/bookmarks/data/sync_service.dart';
import 'features/subscription/domain/subscription_providers.dart';
import 'shared/models/local/database_helper.dart';
import 'shared/providers/connectivity_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch unhandled Flutter framework errors
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // TODO: forward to Sentry/Crashlytics: Sentry.captureException(details.exception, stackTrace: details.stack)
  };

  // Catch unhandled async errors outside the Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled error: $error\n$stack');
    // TODO: forward to Sentry/Crashlytics
    return false;
  };

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  await DatabaseHelper.instance.database;

  if (Env.revenueCatApiKey.isNotEmpty) {
    await Purchases.configure(PurchasesConfiguration(Env.revenueCatApiKey));
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      try {
        await Purchases.logIn(userId);
      } catch (_) {}
    }
  }

  runApp(const ProviderScope(child: LexRefApp()));
}

class LexRefApp extends ConsumerStatefulWidget {
  const LexRefApp({super.key});

  @override
  ConsumerState<LexRefApp> createState() => _LexRefAppState();
}

class _LexRefAppState extends ConsumerState<LexRefApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SyncService().syncAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep RevenueCat user identity in sync with Supabase auth
    ref.listen(authStateProvider, (prev, next) async {
      if (Env.revenueCatApiKey.isEmpty) return;
      final prevSession = prev?.valueOrNull?.session;
      final nextSession = next.valueOrNull?.session;
      try {
        if (prevSession == null && nextSession != null) {
          await Purchases.logIn(nextSession.user.id);
          ref.invalidate(customerInfoProvider);
        } else if (prevSession != null && nextSession == null) {
          await Purchases.logOut();
          ref.invalidate(customerInfoProvider);
        }
      } catch (_) {}
    });

    // Trigger sync when coming back online after being offline
    ref.listen(isOnlineProvider, (prev, next) {
      final wasOffline = !(prev?.valueOrNull ?? true);
      final isNowOnline = next.valueOrNull ?? false;
      if (wasOffline && isNowOnline) SyncService().syncAll();
    });

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'LexRef',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
