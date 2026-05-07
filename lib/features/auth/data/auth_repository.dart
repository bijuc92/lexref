import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/result.dart';

class AuthRepository {
  final _client = Supabase.instance.client;

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<Result<void>> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return const Ok(null);
    } on AuthApiException catch (e) {
      if (e.statusCode == '429') return const Err(RateLimitFailure());
      return Err(AuthFailure(e.message));
    } on AuthException catch (e) {
      return Err(NetworkFailure(e.message));
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }

  Future<Result<void>> signUp({
    required String name,
    required String email,
    required String password,
    required String barNo,
    required String state,
    required String court,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _client.from('profiles').upsert({
          'id': response.user!.id,
          'full_name': name,
          'bar_enrollment_no': barNo,
          'state': state,
          'court': court,
        });
      }
      return const Ok(null);
    } on AuthApiException catch (e) {
      if (e.statusCode == '429') return const Err(RateLimitFailure());
      return Err(AuthFailure(e.message));
    } on AuthException catch (e) {
      return Err(NetworkFailure(e.message));
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }

  Future<Result<void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Ok(null);
    } catch (e) {
      return Err(UnknownFailure(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return data;
  }
}
